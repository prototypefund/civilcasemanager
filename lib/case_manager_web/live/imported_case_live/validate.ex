defmodule CaseManagerWeb.ImportedCaseLive.Validate do
  use CaseManagerWeb, :live_view

  alias CaseManager.ImportedCases
  alias CaseManager.Cases.Case

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket, layout: {CaseManagerWeb.Layouts, :autocolumn}}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :validate, %{"id" => id}) do
    imported_case = ImportedCases.get_imported_case!(id)
    title = "Validate Row #{imported_case.row}"

    next_case =
      ImportedCases.get_next_case_after(imported_case)

    next_url =
      if next_case,
        do: ~p"/imported_cases/#{next_case.id}/validate#imported_case-modal-content",
        else: ~p"/imported_cases"

    socket
    |> assign(:page_title, title)
    |> assign(:imported_case, imported_case)
    |> assign(:case, %Case{})
    |> assign(:force_validate, true)
    |> assign(:next_url, next_url)
  end

  @impl true
  def handle_event("keyup", %{"key" => "Escape"}, socket) do
    {:noreply, socket |> push_navigate(to: ~p"/imported_cases")}
  end

  def handle_event("keyup", %{"key" => _}, socket) do
    {:noreply, socket}
  end
end
