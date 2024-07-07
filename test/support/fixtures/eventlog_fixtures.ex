defmodule CaseManager.EventlogFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `CaseManager.Eventlog` context.
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
      |> CaseManager.Eventlog.create_event()

    event
  end
end
