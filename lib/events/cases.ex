defmodule Events.Cases do
  @moduledoc """
  The Cases context.
  """

  import Ecto.Query, warn: false
  alias Events.Repo

  alias Events.Cases.Case

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

  ## Examples

      iex> get_case!(123)
      %Case{}

      iex> get_case!(456)
      ** (Ecto.NoResultsError)

  """
  def get_case!(id) do
    Repo.one(
      from c in Case,
      where: c.id == ^id,
      preload: [:events]
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
    Repo.get_by(Case, identifier: identifier)
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
    case_data[:identifier] <> "-" <> year
  end

  def get_pretty_identifier(case) do
    # Get first part of identifier
    case.identifier
    |> String.split("-")
    |> hd()
  end

  def get_year_from_id(case) do
    # Get second part of identifier or nothing if it doesn't exist
    case.identifier
    |> String.split("-")
    |> tl()
    |> Enum.at(0)
  end

  @doc """
  Subscribes to changes to the case.
  """
  def subscribe do
    Phoenix.PubSub.subscribe(Events.PubSub, "cases")
  end

  @doc """
  Broadcasts changes to the case.
  """
  def broadcast({:error, changeset}, _change_type), do: {:error, changeset}
  def broadcast({:ok, case}, change_type) do
    Phoenix.PubSub.broadcast(Events.PubSub, "cases", {change_type, case})
    {:ok, case}
  end

end
