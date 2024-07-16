defmodule CaseManager.Positions do
  import CaseManager.GeoTools

  @moduledoc """
  The Positions context.
  """

  import Ecto.Query, warn: false
  alias CaseManager.Repo

  alias CaseManager.Positions.Position

  @doc """
  Returns the list of positions.

  ## Examples

      iex> list_positions()
      [%Position{}, ...]

  """
  def list_positions() do
    Repo.all(Position)
  end

  @doc """
  Returns the list of positions using Flop.

  ## Examples

      iex> list_positions(params)
      [%Position{}, ...]

  """
  def list_positions(params) do
    Flop.validate_and_run(Position, params, for: Position)
  end

  @doc """
  Returns the list of positions for a given case identifier.

  ## Examples

      iex> list_positions_for_case("CASE_00000001")
      [%Position{}, ...]

  """
  def list_positions_for_case(case_identifier) do
    from(p in Position, where: p.item_id == ^case_identifier)
    |> Repo.all()
    |> Enum.map(&add_shortcode/1)
  end

  defp add_shortcode(position) do
    position
    |> Map.put(:short_code, number_to_short_string({position.lat, position.lon}))
  end

  @doc """
  Gets a single position.

  Raises `Ecto.NoResultsError` if the Position does not exist.

  ## Examples

      iex> get_position!(123)
      %Position{}

      iex> get_position!(456)
      ** (Ecto.NoResultsError)

  """
  def get_position!(id), do: Repo.get!(Position, id)

  @doc """
  Creates a position.

  ## Examples

      iex> create_position(%{field: value})
      {:ok, %Position{}}

      iex> create_position(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_position(attrs \\ %{}) do
    %Position{}
    |> Position.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a position.

  ## Examples

      iex> update_position(position, %{field: new_value})
      {:ok, %Position{}}

      iex> update_position(position, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_position(%Position{} = position, attrs) do
    position
    |> Position.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a position.

  ## Examples

      iex> delete_position(position)
      {:ok, %Position{}}

      iex> delete_position(position)
      {:error, %Ecto.Changeset{}}

  """
  def delete_position(%Position{} = position) do
    Repo.delete(position)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking position changes.

  ## Examples

      iex> change_position(position)
      %Ecto.Changeset{data: %Position{}}

  """
  def change_position(%Position{} = position, attrs \\ %{}) do
    Position.changeset(position, attrs)
  end
end
