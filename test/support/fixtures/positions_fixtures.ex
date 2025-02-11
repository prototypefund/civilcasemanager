defmodule CaseManager.PositionsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `CaseManager.Positions` context.
  """

  @doc """
  Generate a position.
  """
  def position_fixture(attrs \\ %{}) do
    {:ok, position} =
      attrs
      |> Enum.into(%{
        altitude: "120.5",
        course: "120.5",
        heading: "120.5",
        id: Ecto.UUID.generate(),
        imported_from: "some imported_from",
        lat: "120.5",
        lon: "120.5",
        soft_deleted: true,
        source: "some source",
        speed: "120.5",
        timestamp: ~U[2024-07-04 16:34:00Z]
      })
      |> CaseManager.Positions.create_position()

    position
  end
end
