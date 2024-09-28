defmodule CaseManager.EventsTest do
  use CaseManager.DataCase

  alias CaseManager.Events

  describe "events" do
    alias CaseManager.Events.Event

    import CaseManager.EventsFixtures
    import CaseManager.CasesFixtures

    @invalid_attrs %{
      body: nil,
      case_id: nil,
      title: nil,
      type: nil
    }

    test "list_events/0 returns all events" do
      event = event_fixture()
      assert Events.list_events() == [event]
    end

    test "get_event!/1 returns the event with given id" do
      event = event_fixture()
      assert Events.get_event!(event.id, false) == event
    end

    test "create_event/1 with valid data creates a event" do
      valid_attrs = %{
        body: "some body",
        case_id: "some case_id",
        title: "some title",
        type: "some type"
      }

      assert {:ok, %Event{} = event} = Events.create_event(valid_attrs)
      assert event.body == "some body"
      assert event.title == "some title"
      assert event.type == "some type"
    end

    test "create_event/1 with no data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Events.create_event()
    end

    test "create_event/1 can assign cases by reference" do
      case = case_fixture()

      valid_attrs = %{
        body: "some body",
        cases: [case],
        title: "some title",
        type: "some type"
      }

      assert {:ok, %Event{} = event} = Events.create_event(valid_attrs)
      assert event.body == "some body"
      assert event.title == "some title"
      assert event.type == "some type"
      assert event.cases == [case]
    end

    test "create_event/1 can assign case by id" do
      case = case_fixture()

      valid_attrs = %{
        body: "some body",
        cases: [case.id],
        title: "some title",
        type: "some type"
      }

      assert {:ok, %Event{} = event} = Events.create_event(valid_attrs)
      assert event.body == "some body"
      assert event.title == "some title"
      assert event.type == "some type"
      assert event.cases == [case]
    end

    test "update_event/2 with empty cases list clears associated cases" do
      case = case_fixture()
      event = event_fixture(%{cases: [case]})

      update_attrs = %{cases: []}

      assert {:ok, %Event{} = updated_event} = Events.update_event(event, update_attrs)
      assert updated_event.cases == []
    end

    test "create_event/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Events.create_event(@invalid_attrs)
    end

    test "update_event/2 with valid data updates the event" do
      event = event_fixture()

      update_attrs = %{
        body: "some updated body",
        title: "some updated title",
        type: "some updated type"
      }

      assert {:ok, %Event{} = event} = Events.update_event(event, update_attrs)
      assert event.body == "some updated body"
      assert event.title == "some updated title"
      assert event.type == "some updated type"
    end

    test "update_event/2 with invalid data returns error changeset" do
      event = event_fixture()
      assert {:error, %Ecto.Changeset{}} = Events.update_event(event, @invalid_attrs)
      assert event == Events.get_event!(event.id, false)
    end

    test "delete_event/1 deletes the event" do
      event = event_fixture()
      assert {:ok, %Event{}} = Events.delete_event(event)
      assert_raise Ecto.NoResultsError, fn -> Events.get_event!(event.id, false) end
    end

    test "change_event/1 returns a event changeset" do
      event = event_fixture()
      assert %Ecto.Changeset{} = Events.change_event(event)
    end
  end
end
