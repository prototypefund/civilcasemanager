defmodule CaseManagerWeb.CaseLive.Show do
  use CaseManagerWeb, :live_view

  alias CaseManager.Cases
  alias CaseManager.Events.Event

  @impl true
  def mount(_params, _session, socket) do
    if connected?(socket), do: CaseManager.Events.subscribe()
    {:ok, socket, layout: {CaseManagerWeb.Layouts, :autocolumn}}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    case = Cases.get_case!(id)
    events = case.events |> Enum.sort_by(& &1.received_at) |> Enum.reverse()
    positions = CaseManager.Positions.list_positions_for_case(id)

    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:case, Cases.get_case!(id))
     |> stream(:assoc_events, events)
     |> stream(:assoc_positions, positions)}
  end

  @impl true

  def handle_info({:event_created, event}, socket) do
    # We only call stream_insert if the received event has a case in cases with the same case_id as the case we are showing
    case = socket.assigns.case
    # Event.cases is a list of cases that the event is associated with
    if is_list(event.cases) &&
         Enum.any?(event.cases, fn assoc_case -> assoc_case.id == case.id end) do
      {:noreply, stream_insert(socket, :assoc_events, event, at: 0)}
    else
      {:noreply, socket}
    end
  end

  @impl true
  def handle_info({:event_updated, event}, socket) do
    # TODO Use Flop to apply filter here
    {:noreply, stream_insert(socket, :assoc_events, event, at: 0)}
  end

  @impl true
  def handle_info({CaseManagerWeb.EventLive.FormSmall, {:saved, event}}, socket) do
    {:noreply, stream_insert(socket, :assoc_events, event)}
  end

  @impl true
  def handle_info({CaseManagerWeb.CaseLive.FormComponent, {:saved, case}}, socket) do
    {:noreply,
     socket
     |> assign(:case, case)}
  end

  defp page_title(:show), do: "Show Case"

  # Get a mailto link with the body using fill_template_with_case()
  # defp get_mailto_link(case) do
  #   "mailto: ?subject=#{URI.encode("Distress Case #{case.name} in SRR")}
  #   &body=#{URI.encode(Cases.fill_template_with_case(case))}"
  # end
end
