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

  @doc """
  Splits a string in the format Countrycode:count,Countrycode:count into a list of CaseNationalities.

  ## Examples

      iex> split_nationalities("US:10,UK:5")
      {:ok, [%CaseNationality{country_code: "US", count: 10}, %CaseNationality{country_code: "UK", count: 5}]}

      iex> split_nationalities("US:-,UK:unknown")
      {:ok, [%CaseNationality{country_code: "US", count: nil}, %CaseNationality{country_code: "UK", count: nil}]}

      iex> split_nationalities("US:invalid")
      {:error, "Invalid count for country code US"}

      iex> split_nationalities("")
      {:ok, []}

  """
  def split_nationalities(nil), do: {:ok, []}
  def split_nationalities(""), do: {:ok, []}

  def split_nationalities(string) when is_binary(string) do
    result =
      string
      |> String.split(";")
      |> Enum.map(&parse_individual_nationality/1)
      |> Enum.reduce_while({:ok, []}, fn
        {:ok, nationality}, {:ok, acc} -> {:cont, {:ok, [nationality | acc]}}
        {:error, reason}, _ -> {:halt, {:error, reason}}
      end)

    case result do
      {:ok, nationalities} -> {:ok, Enum.reverse(nationalities)}
      error -> error
    end
  end

  defp parse_individual_nationality(string) do
    case String.split(string, ":") do
      [country_code, count] when byte_size(country_code) == 2 ->
        create_nationality_struct(country_code, count)

      _ ->
        {:error, "Invalid format: #{string}"}
    end
  end

  defp parse_int_with_null(count) do
    case count do
      "x" ->
        nil

      "" ->
        nil

      "-" ->
        nil

      "unknown" ->
        nil

      _ ->
        case Integer.parse(count) do
          {int_count, ""} -> int_count
          _ -> {:error, "Cannot parse #{count} into a number."}
        end
    end
  end

  defp create_nationality_struct(country_code, count) do
    parsed_int = parse_int_with_null(count)

    case parsed_int do
      {:error, _} = error -> error
      parsed_int -> {:ok, %CaseNationality{country: country_code, count: parsed_int}}
    end
  end
end
