defmodule Events.EventlogTest do
  use Events.DataCase

  alias Events.Eventlog

  describe "events" do
    alias Events.Eventlog.Event

    import Events.EventlogFixtures

    @invalid_attrs %{body: nil, case_id: nil, origin: nil, time: nil, title: nil, type: nil}

    test "list_events/0 returns all events" do
      event = event_fixture()
      assert Eventlog.list_events() == [event]
    end

    test "get_event!/1 returns the event with given id" do
      event = event_fixture()
      assert Eventlog.get_event!(event.id) == event
    end

    test "create_event/1 with valid data creates a event" do
      valid_attrs = %{
        body: "some body",
        case_id: "some case_id",
        origin: "some origin",
        time: "some time",
        title: "some title",
        type: "some type"
      }

      assert {:ok, %Event{} = event} = Eventlog.create_event(valid_attrs)
      assert event.body == "some body"
      assert event.origin == "some origin"
      assert event.time == "some time"
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
        case_id: "some updated case_id",
        origin: "some updated origin",
        time: "some updated time",
        title: "some updated title",
        type: "some updated type"
      }

      assert {:ok, %Event{} = event} = Eventlog.update_event(event, update_attrs)
      assert event.body == "some updated body"
      assert event.case_id == "some updated case_id"
      assert event.origin == "some updated origin"
      assert event.time == "some updated time"
      assert event.title == "some updated title"
      assert event.type == "some updated type"
    end

    test "update_event/2 with invalid data returns error changeset" do
      event = event_fixture()
      assert {:error, %Ecto.Changeset{}} = Eventlog.update_event(event, @invalid_attrs)
      assert event == Eventlog.get_event!(event.id)
    end

    test "delete_event/1 deletes the event" do
      event = event_fixture()
      assert {:ok, %Event{}} = Eventlog.delete_event(event)
      assert_raise Ecto.NoResultsError, fn -> Eventlog.get_event!(event.id) end
    end

    test "change_event/1 returns a event changeset" do
      event = event_fixture()
      assert %Ecto.Changeset{} = Eventlog.change_event(event)
    end
  end
end
