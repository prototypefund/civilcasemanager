defmodule CaseManager.PlacesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `CaseManager.Places` context.
  """

  @doc """
  Generate a unique place name.
  """
  def unique_place_name, do: "some name#{System.unique_integer([:positive])}"

  @doc """
  Generate a place.
  """
  def place_fixture(attrs \\ %{}) do
    {:ok, place} =
      attrs
      |> Enum.into(%{
        country: "some country",
        lat: "120.5",
        lon: "120.5",
        name: unique_place_name(),
        type: :departure
      })
      |> CaseManager.Places.create_place()

    place
  end
end
