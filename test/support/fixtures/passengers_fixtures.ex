defmodule CaseManager.PassengersFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `CaseManager.Passengers` context.
  """

  import CaseManager.CasesFixtures

  @doc """
  Generate a passenger.
  """
  def passenger_fixture(attrs \\ %{}) do
    case = case_fixture()

    {:ok, passenger} =
      attrs
      |> Enum.into(%{
        description: "some description",
        name: "some name",
        case_id: case.id
      })
      |> CaseManager.Passengers.create_passenger()

    passenger
  end
end
