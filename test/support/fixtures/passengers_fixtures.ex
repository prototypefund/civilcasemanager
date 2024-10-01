defmodule CaseManager.PassengersFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `CaseManager.Passengers` context.
  """

  @doc """
  Generate a passenger.
  """
  def passenger_fixture(attrs \\ %{}) do
    {:ok, passenger} =
      attrs
      |> Enum.into(%{
        description: "some description",
        name: "some name"
      })
      |> CaseManager.Passengers.create_passenger()

    passenger
  end
end
