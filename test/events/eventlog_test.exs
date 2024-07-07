defmodule CaseManager.EventlogTest do
  use CaseManager.DataCase

  alias CaseManager.Eventlog

  describe "events" do
    alias CaseManager.Eventlog.Event

    import CaseManager.EventlogFixtures

    @invalid_attrs %{
      body: nil,
      case_id: nil,
      title: nil,
      type: nil
    }

    test "list_events/0 returns all events" do
      event = event_fixture()
      assert Eventlog.list_events() == [event]
    end

    test "get_event!/1 returns the event with given id" do
      event = event_fixture()
      assert Eventlog.get_event!(event.id, false) == event
    end

    test "create_event/1 with valid data creates a event" do
      valid_attrs = %{
        body: "some body",
        case_id: "some case_id",
        title: "some title",
        type: "some type"
      }

      assert {:ok, %Event{} = event} = Eventlog.create_event(valid_attrs)
      assert event.body == "some body"
      assert event.title == "some title"
      assert event.type == "some type"
    end

    test "create_event/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Eventlog.create_event(@invalid_attrs)
    end

    test "update_event/2 with valid data updates the event" do
      event = event_fixture()

      update_attrs = %{
        body: "some updated body",
        title: "some updated title",
        type: "some updated type"
      }

      assert {:ok, %Event{} = event} = Eventlog.update_event(event, update_attrs)
      assert event.body == "some updated body"
      assert event.title == "some updated title"
      assert event.type == "some updated type"
    end

    test "update_event/2 with invalid data returns error changeset" do
      event = event_fixture()
      assert {:error, %Ecto.Changeset{}} = Eventlog.update_event(event, @invalid_attrs)
      assert event == Eventlog.get_event!(event.id, false)
    end

    test "delete_event/1 deletes the event" do
      event = event_fixture()
      assert {:ok, %Event{}} = Eventlog.delete_event(event)
      assert_raise Ecto.NoResultsError, fn -> Eventlog.get_event!(event.id, false) end
    end

    test "change_event/1 returns a event changeset" do
      event = event_fixture()
      assert %Ecto.Changeset{} = Eventlog.change_event(event)
    end
  end
end
