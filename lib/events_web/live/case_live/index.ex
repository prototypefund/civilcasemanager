defmodule EventsWeb.CaseLive.Index do
  use EventsWeb, :live_view

  alias Events.Cases
  alias Events.Cases.Case

  use PhoenixHTMLHelpers

  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :cases, Cases.list_cases())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Case")
    |> assign(:case, Cases.get_case!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Case")
    |> assign(:case, %Case{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Cases")
    |> assign(:case, nil)
  end

  @impl true
  def handle_info({EventsWeb.CaseLive.FormComponent, {:saved, case}}, socket) do
    {:noreply, stream_insert(socket, :cases, case)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    case = Cases.get_case!(id)
    {:ok, _} = Cases.delete_case(case)

    {:noreply, stream_delete(socket, :cases, case)}
  end

  ## Render an icon based on the case status
  defp render_status_icon(case) do
    icon_name = case case.status do
      :open -> "hero-lock-open-solid text-emerald-500"
      :closed -> "hero-lock-closed text-gray-500"
      :invalid -> "hero-question-mark-circle text-red-500"
      _ -> "hero-help-outline text-blue-500"
    end

    content_tag(:span, class: "#{icon_name} h-5 w-5") do

    end

  end
end
