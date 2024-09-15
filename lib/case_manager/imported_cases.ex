defmodule CaseManager.ImportedCases do
  @moduledoc """
  The ImportedCases context.
  """

  import Ecto.Query, warn: false
  alias CaseManager.Repo

  alias CaseManager.ImportedCases.ImportedCase

  @doc """
  Returns the list of imported_cases.

  ## Examples

      iex> list_imported_cases()
      [%ImportedCase{}, ...]

  """
  def list_imported_cases do
    Repo.all(ImportedCase)
  end

  @doc """
  Returns the list of imported_cases using Flop.

  ## Examples

      iex> list_imported_cases(params)
      [%ImportedCase{}, ...]

  """
  def list_imported_cases(params) do
    ImportedCase
    |> preload([:arrival_place, :departure_place])
    |> Flop.validate_and_run(params, for: ImportedCase)
  end

  @doc """
  Gets a single imported_case.

  Raises `Ecto.NoResultsError` if the Imported case does not exist.

  ## Examples

      iex> get_imported_case!(123)
      %ImportedCase{}

      iex> get_imported_case!(456)
      ** (Ecto.NoResultsError)

  """
  def get_imported_case!(id, preload \\ true) do
    Repo.one!(
      from c in ImportedCase,
        where: c.id == ^id,
        preload:
          ^if(preload,
            do: [:departure_place, :arrival_place],
            else: []
          )
    )
  end

  @doc """
  Gets the case with the lowest id, or nil if no cases exist

  ## Examples

      iex> get_first_case()
      %ImportedCase{}

      iex> get_first_case()
      nil

  """
  def get_first_case() do
    Repo.one(from c in ImportedCase, order_by: [asc: c.id], limit: 1)
  end

  @doc """
  Gets the next case after the given one (using the id counter)

  ## Examples

      iex> get_next_case_after(%ImportedCase{inserted_at: ~U[2021-01-01 00:00:00Z]})
      %ImportedCase{}

  """
  def get_next_case_after(imported_case) do
    Repo.one(
      from c in ImportedCase,
        where: c.id > ^imported_case.id,
        limit: 1
    ) || get_first_case()
  end

  @doc """
  Creates a imported_case.

  ## Examples

      iex> create_imported_case(%{field: value})
      {:ok, %ImportedCase{}}

      iex> create_imported_case(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_imported_case(attrs \\ %{}) do
    %ImportedCase{}
    |> ImportedCase.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Creates multiple imported_cases from a list of attributes.
  Use one db commit so on error all changes are rolled back.
  """
  def create_imported_cases_from_list(attrs \\ []) do
    Repo.transaction(fn ->
      Enum.map(attrs, &create_imported_case/1)
    end)
  end

  @doc """
  Updates a imported_case.

  ## Examples

      iex> update_imported_case(imported_case, %{field: new_value})
      {:ok, %ImportedCase{}}

      iex> update_imported_case(imported_case, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_imported_case(%ImportedCase{} = imported_case, attrs) do
    imported_case
    |> ImportedCase.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a imported_case.

  ## Examples

      iex> delete_imported_case(imported_case)
      {:ok, %ImportedCase{}}

      iex> delete_imported_case(imported_case)
      {:error, %Ecto.Changeset{}}

  """
  def delete_imported_case(%ImportedCase{} = imported_case) do
    Repo.delete(imported_case)
  end

  @doc """
  Deletes all imported_cases.
  """
  def delete_all do
    Repo.delete_all(ImportedCase)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking imported_case changes.

  ## Examples

      iex> change_imported_case(imported_case)
      %Ecto.Changeset{data: %ImportedCase{}}

  """
  def change_imported_case(%ImportedCase{} = imported_case, attrs \\ %{}) do
    ImportedCase.changeset(imported_case, attrs)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking uploaded changes.
  """
  def change_upload_case(%ImportedCase{} = imported_case, attrs \\ %{}) do
    ImportedCase.upload_changeset(imported_case, attrs)
  end
end
