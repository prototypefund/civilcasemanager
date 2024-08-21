defmodule CaseManager.DeletedCases do
  @moduledoc """
  The DeletedCases context.
  """

  import Ecto.Query, warn: false
  alias CaseManager.Repo

  alias CaseManager.DeletedCases.DeletedCase

  @doc """
  Returns the list of deleted_cases.

  ## Examples

      iex> list_deleted_cases()
      [%DeletedCase{}, ...]

  """
  def list_deleted_cases do
    Repo.all(DeletedCase)
  end

  @doc """
  Gets a single deleted_case.

  Raises `Ecto.NoResultsError` if the Deleted case does not exist.

  ## Examples

      iex> get_deleted_case!(123)
      %DeletedCase{}

      iex> get_deleted_case!(456)
      ** (Ecto.NoResultsError)

  """
  def get_deleted_case!(id), do: Repo.get!(DeletedCase, id)

  @doc """
  Creates a deleted_case.

  ## Examples

      iex> create_deleted_case(%{field: value})
      {:ok, %DeletedCase{}}

      iex> create_deleted_case(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_deleted_case(attrs \\ %{}) do
    %DeletedCase{}
    |> DeletedCase.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a deleted_case.

  ## Examples

      iex> update_deleted_case(deleted_case, %{field: new_value})
      {:ok, %DeletedCase{}}

      iex> update_deleted_case(deleted_case, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_deleted_case(%DeletedCase{} = deleted_case, attrs) do
    deleted_case
    |> DeletedCase.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a deleted_case.

  ## Examples

      iex> delete_deleted_case(deleted_case)
      {:ok, %DeletedCase{}}

      iex> delete_deleted_case(deleted_case)
      {:error, %Ecto.Changeset{}}

  """
  def delete_deleted_case(%DeletedCase{} = deleted_case) do
    Repo.delete(deleted_case)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking deleted_case changes.

  ## Examples

      iex> change_deleted_case(deleted_case)
      %Ecto.Changeset{data: %DeletedCase{}}

  """
  def change_deleted_case(%DeletedCase{} = deleted_case, attrs \\ %{}) do
    DeletedCase.changeset(deleted_case, attrs)
  end
end
