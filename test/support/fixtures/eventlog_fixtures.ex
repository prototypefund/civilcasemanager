defmodule CaseManager.EventsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `CaseManager.Events` context.
  """

  @doc """
  Generate a event.
  """
  def event_fixture(attrs \\ %{}) do
    {:ok, event} =
      attrs
      |> Enum.into(%{
        body: "some body",
        title: "some title",
        type: "some type"
      })
      |> CaseManager.Events.create_event()

    event
  end
end
