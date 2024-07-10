defmodule CaseManager.Cases do
  @moduledoc """
  The Cases context.
  """

  import Ecto.Query, warn: false
  alias CaseManager.Repo

  alias CaseManager.Cases.Case

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
  def list_cases!(params) do
    case Flop.validate_and_run(Case, params, for: Case) do
      {:ok, cases} -> cases
      {:error, _} -> []
    end
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

  @spec list_open_cases() :: any()
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
    Repo.one!(
      from c in Case,
        where: c.id == ^id,
        preload: ^if(preload, do: [:events], else: [])
    )
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
    Repo.delete(case)
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

  def get_combined_identifier(case_data) do
    year = DateTime.to_date(case_data[:created_at]).year |> Integer.to_string()
    case_data[:name] <> "-" <> year
  end

  def get_pretty_identifier(case) do
    # Get first part of identifier
    case.name
    |> String.split("-")
    |> hd()
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
    # Get second part of identifier or nothing if it doesn't exist
    case.name
    |> String.split("-")
    |> tl()
    |> Enum.at(0)
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
