defmodule CaseManager.CasesEventsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `CaseManager.CasesEvents` context.
  """

  import CaseManager.CasesFixtures
  import CaseManager.EventsFixtures

  @doc """
  Generate a case_event.
  """
  def case_event_fixture(attrs \\ %{}) do
    case = case_fixture()
    event = event_fixture()

    {:ok, case_event} =
      attrs
      |> Enum.into(%{
        case_id: case.id,
        event_id: event.id
      })
      |> CaseManager.CasesEvents.create_case_event()

    case_event
  end
end
