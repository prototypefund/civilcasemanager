defmodule EventsWeb.CaseLive.Show do
  use EventsWeb, :live_view

  alias Events.Cases
  alias Events.Eventlog.Event

  @impl true
  def mount(_params, _session, socket) do
    if connected?(socket), do: Events.Eventlog.subscribe()
    {:ok, socket, layout: {EventsWeb.Layouts, :column}}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    case = Cases.get_case!(id)
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:case, Cases.get_case!(id))
     |> stream(:assoc_events, case.events)
    }
  end

  def handle_info({:event_created, event}, socket) do
    {:noreply, stream_insert(socket, :assoc_events, event, at: 0)}
  end

  @impl true
  def handle_info({:event_updated, event}, socket) do
    {:noreply, stream_insert(socket, :assoc_events, event, at: 0)}
  end

  @impl true
  def handle_info({EventsWeb.EventLive.FormSmall, {:saved, event}}, socket) do
    {:noreply, stream_insert(socket, :assoc_events, event)}
  end

  defp page_title(:show), do: "Show Case"
  defp page_title(:edit), do: "Edit Case"
end
