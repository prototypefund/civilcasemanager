defmodule CaseManagerWeb.CaseLive.Edit do
  use CaseManagerWeb, :live_view

  alias CaseManager.Cases

  @impl true
  def mount(_params, _session, socket) do
    if connected?(socket) do
      CaseManager.Events.subscribe()
      CaseManager.Cases.subscribe()
    end

    {:ok, socket, layout: {CaseManagerWeb.Layouts, :autocolumn}}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    case = Cases.get_case!(id)

    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:case, case)}
  end

  @impl true

  def handle_event("keyup", %{"key" => "Escape"}, socket) do
    {:noreply, socket |> push_navigate(to: ~p"/cases")}
  end

  def handle_event("keyup", _, socket) do
    {:noreply, socket}
  end

  @impl true
  def handle_info({CaseManagerWeb.CaseForm, {:saved, case}}, socket) do
    {:noreply,
     socket
     |> assign(:case, case)}
  end

  @impl true
  def handle_info({:case_updated, case}, socket) do
    {:noreply,
     socket
     |> assign(:case, Cases.preload_assoc(case))}
  end

  @impl true
  def handle_info({:case_created, _case}, socket) do
    {:noreply, socket}
  end

  defp page_title(:edit), do: "Edit Case"
end
