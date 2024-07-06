defmodule CaseManagerWeb.EventLive.Index do
  use CaseManagerWeb, :live_view

  alias CaseManager.Eventlog
  alias CaseManager.Eventlog.Event

  @impl true
  def mount(_params, _session, socket) do
    if connected?(socket), do: Eventlog.subscribe()
    {:ok, stream(socket, :events, Eventlog.list_events())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Event")
    |> assign(:event, Eventlog.get_event!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "Add Manual Event")
    |> assign(:event, %Event{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing CaseManager")
    |> assign(:event, nil)
  end

  @impl true
  def handle_info({:event_created, event}, socket) do
    {:noreply, stream_insert(socket, :events, event, at: 0)}
  end

  @impl true
  def handle_info({:event_updated, event}, socket) do
    {:noreply, stream_insert(socket, :events, event, at: 0)}
  end

  @impl true
  def handle_info({CaseManagerWeb.EventLive.FormComponent, {:saved, event}}, socket) do
    {:noreply, stream_insert(socket, :events, event)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    event = Eventlog.get_event!(id)
    {:ok, _} = Eventlog.delete_event(event)

    {:noreply, stream_delete(socket, :events, event)}
  end
end
