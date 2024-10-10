defmodule CaseManager.Cases do
  @moduledoc """
  The Cases context.
  """

  import Ecto.Query, warn: false
  import CaseManager.GeoTools
  alias CaseManager.ImportedCases.ImportedCase
  alias CaseManager.Repo

  alias CaseManager.Cases.Case
  alias CaseManager.DeletedCases.DeletedCase
  alias CaseManager.Positions.Position

  @doc """
  Returns the list of cases.

  ## Examples

      iex> list_cases()
      [%Case{}, ...]

  """
  def list_cases do
    Repo.all(from c in Case, order_by: [desc: c.created_at])
  end

  @doc """
  Returns the list of cases using Flop

  ## Examples

      iex> list_cases(params)
      [%Case{}, ...]

  """
  def list_cases(params) do
    Flop.validate_and_run(Case, params, for: Case)
  end

  @doc """
  Returns the list of open cases.

  ## Examples

  iex> list_open_cases()
  [%Case{},...]

  """
  def list_open_cases do
    Repo.all(from c in Case, where: c.status == :open, order_by: [desc: c.created_at])
  end

  @doc """
  Gets a single case.

  Raises `Ecto.NoResultsError` if the Case does not exist.
  By default also preloads the events relationship.

  ## Examples

      iex> get_case!(123)
      %Case{}

      iex> get_case!(456)
      ** (Ecto.NoResultsError)

  """
  def get_case!(id, preload \\ true) do
    case =
      Repo.one!(
        from c in Case,
          where: c.id == ^id,
          preload:
            ^if(preload,
              do: Case.get_preload_keys(),
              else: []
            )
      )

    if preload, do: populate_shortcodes(case), else: case
  end

  def preload_assoc(case) do
    Repo.preload(case, Case.get_preload_keys())
  end

  def list_positions_for_case(case_identifier) do
    from(p in Position, where: p.item_id == ^case_identifier)
    |> Repo.all()
    |> Enum.map(&add_shortcode/1)
  end

  defp populate_shortcodes(%Case{} = case) do
    positions = Enum.map(case.positions, &add_shortcode/1)
    Map.put(case, :positions, positions)
  end

  defp add_shortcode(%Position{} = position) do
    position
    |> Map.put(:short_code, number_to_short_string({position.lat, position.lon}))
  end

  @doc """
  Gets the list of cases based on provided IDs.

  ## Examples

      iex> get_cases([1, 2, 3])
      [%Case{}, %Case{}, %Case{}]

  """
  def get_cases(ids) do
    Repo.all(from c in Case, where: c.id in ^ids)
  end

  @doc """
  Get a case by the specified identifier.

  ## Examples

      iex> get_case_by_identifier("EB123")
      %Case{}

  """
  def get_case_by_identifier(identifier) do
    Repo.get_by(Case, name: identifier)
  end

  @doc """
  Creates a case.

  ## Examples

      iex> create_case(%{field: value})
      {:ok, %Case{}}

      iex> create_case(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_case(attrs \\ %{}) do
    %Case{}
    |> Case.changeset(attrs)
    |> Repo.insert()
    |> broadcast(:case_created)
  end

  @doc """
  Creates a case and delete the imported case record inside a transaction.
  """
  def create_case_and_delete_imported(attrs, %ImportedCase{} = imported) do
    Ecto.Multi.new()
    |> Ecto.Multi.delete(:delete_imported_case, imported)
    |> Ecto.Multi.insert(:insert_case, %Case{} |> Case.changeset(attrs))
    |> Repo.transaction()
  end

  @doc """
  Updates a case.

  ## Examples

      iex> update_case(case, %{field: new_value})
      {:ok, %Case{}}

      iex> update_case(case, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_case(%Case{} = case, attrs) do
    case
    |> Case.changeset(attrs)
    |> Repo.update()
    |> broadcast(:case_updated)
  end

  @doc """
  Deletes a case.

  ## Examples

      iex> delete_case(case)
      {:ok, %Case{}}

      iex> delete_case(case)
      {:error, %Ecto.Changeset{}}

  """
  def delete_case(%Case{} = case) do
    Ecto.Multi.new()
    |> Ecto.Multi.delete(:delete_case, case)
    |> Ecto.Multi.insert(
      :insert_case_in_deleted_table,
      %DeletedCase{id: case.id}
    )
    |> Repo.transaction()
    |> case do
      {:ok, %{delete_case: case, insert_case_in_deleted_table: _}} -> {:ok, case}
      error -> error
    end
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking case changes.

  ## Examples

      iex> change_case(case)
      %Ecto.Changeset{data: %Case{}}

  """
  def change_case(%Case{} = case, attrs \\ %{}) do
    Case.changeset(case, attrs)
  end

  def get_pretty_identifier(case) do
    # Remove years from identifiers
    case.name
    |> String.replace(~r/-\d{4}/, "")
  end

  @doc """
  Extracts the year from the case using different strategies.
  Returns nil if none found.

  ## Example

  iex> get_year(case)
      2024
  """
  def get_year(case) do
    get_year_from_id(case) || get_year_from_occurred(case)
  end

  @doc """
  Extracts the year from the case identifier.
  Returns nil if the identifier doesn't contain a year.

  ## Example

      iex> get_year_from_id(case)
      2024

  """
  def get_year_from_id(case) do
    case String.split(case.name, "-") do
      [_, year | _] ->
        case Integer.parse(String.trim(year)) do
          {year, ""} -> year
          _ -> nil
        end

      _ ->
        nil
    end
  end

  @doc """
  Extracts the year from the occurred_at field.

  ## Example

      iex> get_year_from_occurred(case)
      2020

  """
  def get_year_from_occurred(case) do
    case case.occurred_at do
      nil -> nil
      _ -> DateTime.to_date(case.occurred_at).year
    end
  end

  @doc """
  Get a formatted status string for the case.

  TODO: Replace with gettext
  """
  def get_pretty_status(case) do
    case case.status do
      :open -> "open"
      :closed -> "closed"
      :ready_for_documentation -> "ready for doc"
      _ -> nil
    end
  end

  def fill_template_with_case(case) do
    """
    Dear officer on duty,

    Our hotline was alarmed at by a distress call from a boat at sea,
    which we assigned the number #{case.name} at #{DateTime.to_string(case.created_at)} .
    This is the information we have received so far:

    Number of People: #{case.pob_men} Men, #{case.pob_women} Women, #{case.pob_minors} Minors.

    Type of Boat: #{case.boat_type}
    COG: !!FILL_ME!! °
    SOG: !!FILL_ME!! kt
    Last position: !!FILL_ME!!

    Regards,
    Air Liaison Officer Seabird 2
    """
  end

  @doc """
  Subscribes to changes to the case.
  """
  def subscribe do
    Phoenix.PubSub.subscribe(CaseManager.PubSub, "cases")
  end

  @doc """
  Broadcasts changes to the case.
  """
  def broadcast({:error, changeset}, _change_type), do: {:error, changeset}

  def broadcast({:ok, case}, change_type) do
    Phoenix.PubSub.broadcast(CaseManager.PubSub, "cases", {change_type, case})
    {:ok, case}
  end
end
