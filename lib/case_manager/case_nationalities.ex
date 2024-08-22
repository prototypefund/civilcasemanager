defmodule CaseManager.CaseNationalities do
  @moduledoc """
  The CaseNationalities context.
  """

  import Ecto.Query, warn: false
  alias CaseManager.Repo

  alias CaseManager.CaseNationalities.CaseNationality

  @doc """
  Returns the list of case_nationalities.

  ## Examples

      iex> list_case_nationalities()
      [%CaseNationality{}, ...]

  """
  def list_case_nationalities do
    Repo.all(CaseNationality)
  end

  @doc """
  Gets a single case_nationality.

  Raises `Ecto.NoResultsError` if the Case nationality does not exist.

  ## Examples

      iex> get_case_nationality!(123, "US")
      %CaseNationality{}

      iex> get_case_nationality!(456, "CA")
      ** (Ecto.NoResultsError)

  """
  def get_case_nationality!(case_id, country),
    do: Repo.get_by!(CaseNationality, case_id: case_id, country: country)

  @doc """
  Creates a case_nationality.

  ## Examples

      iex> create_case_nationality(%{field: value})
      {:ok, %CaseNationality{}}

      iex> create_case_nationality(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_case_nationality(attrs \\ %{}) do
    %CaseNationality{}
    |> CaseNationality.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a case_nationality.

  ## Examples

      iex> update_case_nationality(case_nationality, %{field: new_value})
      {:ok, %CaseNationality{}}

      iex> update_case_nationality(case_nationality, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_case_nationality(%CaseNationality{} = case_nationality, attrs) do
    case_nationality
    |> CaseNationality.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a case_nationality.

  ## Examples

      iex> delete_case_nationality(case_nationality)
      {:ok, %CaseNationality{}}

      iex> delete_case_nationality(case_nationality)
      {:error, %Ecto.Changeset{}}

  """
  def delete_case_nationality(%CaseNationality{} = case_nationality) do
    Repo.delete(case_nationality)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking case_nationality changes.

  ## Examples

      iex> change_case_nationality(case_nationality)
      %Ecto.Changeset{data: %CaseNationality{}}

  """
  def change_case_nationality(%CaseNationality{} = case_nationality, attrs \\ %{}) do
    CaseNationality.changeset(case_nationality, attrs)
  end
end
