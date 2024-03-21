defmodule Events.EventlogFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Events.Eventlog` context.
  """

  @doc """
  Generate a event.
  """
  def event_fixture(attrs \\ %{}) do
    {:ok, event} =
      attrs
      |> Enum.into(%{
        body: "some body",
        case_id: "some case_id",
        origin: "some origin",
        time: "some time",
        title: "some title",
        type: "some type"
      })
      |> Events.Eventlog.create_event()

    event
  end
end
