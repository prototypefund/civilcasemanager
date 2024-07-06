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
    events = case.events |> Enum.sort_by(& &1.received_at) |> Enum.reverse()
    positions = Events.Positions.list_positions_for_case(id)
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:case, Cases.get_case!(id))
     |> stream(:assoc_events, events)
     |> stream(:assoc_positions, positions)
    }
  end

  def handle_info({:event_created, event}, socket) do
    # We only call stream_insert if the received event has a case in cases with the same case_id as the case we are showing
    case = socket.assigns.case
    # Event.cases is a list of cases that the event is associated with
    if is_list(event.cases) && Enum.any?(event.cases, fn assoc_case -> assoc_case.id == case.id end) do
      {:noreply, stream_insert(socket, :assoc_events, event, at: 0)}
    else
      {:noreply, socket}
    end
  end

  @impl true
  def handle_info({:event_updated, event}, socket) do
    #TODO Filter correctly here
    {:noreply, stream_insert(socket, :assoc_events, event, at: 0)}
  end

  @impl true
  def handle_info({EventsWeb.EventLive.FormSmall, {:saved, event}}, socket) do
    {:noreply, stream_insert(socket, :assoc_events, event)}
  end

  @impl true
  def handle_info({EventsWeb.CaseLive.FormComponent, {:saved, case}}, socket) do
    {:noreply,
      socket
      |> assign(:case, case)
    }
  end

  defp page_title(:show), do: "Show Case"
  defp page_title(:edit), do: "Edit Case"

  # Get a mailto link with the body using fill_template_with_case()
  defp get_mailto_link(case) do
    "mailto: ?subject=#{URI.encode("Distress Case #{case.name} in SRR")}
    &body=#{URI.encode(Cases.fill_template_with_case(case))}"
  end
end
