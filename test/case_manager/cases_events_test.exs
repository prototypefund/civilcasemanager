defmodule CaseManager.CasesEventsTest do
  use CaseManager.DataCase

  alias CaseManager.CasesEvents

  alias CaseManager.CasesEvents.CaseEvent
  import CaseManager.CasesFixtures
  import CaseManager.EventsFixtures

  describe "cases_events" do
    alias CaseManager.CasesEvents.CaseEvent

    import CaseManager.CasesEventsFixtures

    @invalid_attrs %{
      case_id: nil,
      event_id: nil
    }

    test "list_cases_events/0 returns all cases_events" do
      case_event = case_event_fixture()
      assert CasesEvents.list_cases_events() == [case_event]
    end

    test "get_case_event!/1 returns the case_event with given id" do
      case_event = case_event_fixture()
      assert CasesEvents.get_case_event!(case_event.case_id, case_event.event_id) == case_event
    end

    test "create_case_event/1 with valid data creates a case_event" do
      case = case_fixture()
      event = event_fixture()
      valid_attrs = %{case_id: case.id, event_id: event.id}

      assert {:ok, %CaseEvent{} = case_event} = CasesEvents.create_case_event(valid_attrs)
      assert case_event.case_id == case.id
      assert case_event.event_id == event.id
    end

    test "create_case_event/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = CasesEvents.create_case_event(@invalid_attrs)
    end

    test "create_case_event/1 with invanolid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = CasesEvents.create_case_event()
    end

    test "update_case_event/2 with valid data updates the case_event" do
      case_event = case_event_fixture()
      case = case_fixture()

      update_attrs = %{
        case_id: case.id
      }

      assert {:ok, %CaseEvent{} = case_event} =
               CasesEvents.update_case_event(case_event, update_attrs)

      assert case_event.case_id == case.id
    end

    test "update_case_event/2 with invalid data returns error changeset" do
      case_event = case_event_fixture()

      assert {:error, %Ecto.Changeset{}} =
               CasesEvents.update_case_event(case_event, @invalid_attrs)

      assert case_event == CasesEvents.get_case_event!(case_event.case_id, case_event.event_id)
    end

    test "delete_case_event/1 deletes the case_event" do
      case_event = case_event_fixture()
      assert {:ok, %CaseEvent{}} = CasesEvents.delete_case_event(case_event)

      assert_raise Ecto.NoResultsError, fn ->
        CasesEvents.get_case_event!(case_event.case_id, case_event.event_id)
      end
    end

    test "change_case_event/1 returns a case_event changeset" do
      case_event = case_event_fixture()
      assert %Ecto.Changeset{} = CasesEvents.change_case_event(case_event)
    end
  end
end
