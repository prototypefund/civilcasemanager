defmodule CaseManagerWeb.ImportedCaseLive.Validate do
  use CaseManagerWeb, :live_view

  alias CaseManager.ImportedCases
  alias CaseManager.Cases.Case

  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :imported_cases, [])}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :validate, %{"id" => id}) do
    socket
    |> assign(:page_title, "Validate Imported case")
    |> assign(:imported_case, ImportedCases.get_imported_case!(id))
    |> assign(:case, %Case{})
  end

  # @impl true
  # def handle_info(
  #       {CaseManagerWeb.ImportedCaseLive.FormComponent, {:saved, imported_case}},
  #       socket
  #     ) do
  #   {:noreply, stream_insert(socket, :imported_cases, imported_case)}
  # end

  # def handle_info(
  #       {CaseManagerWeb.ImportedCaseLive.FormComponent, {:deleted, imported_case}},
  #       socket
  #     ) do
  #   {:noreply, stream_delete(socket, :imported_cases, imported_case)}
  # end

  # def handle_event("delete", %{"all" => _todo}, socket) do
  #   ImportedCases.delete_all()

  #   {:noreply, stream(socket, :imported_cases, [], reset: true)}
  # end

  # @impl true
  # def handle_event("delete", %{"id" => id}, socket) do
  #   imported_case = ImportedCases.get_imported_case!(id)
  #   {:ok, _} = ImportedCases.delete_imported_case(imported_case)

  #   {:noreply, stream_delete(socket, :imported_cases, imported_case)}
  # end
end
