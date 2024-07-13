defmodule CaseManagerWeb.ImportedCaseLive.Index do
  use CaseManagerWeb, :live_view

  alias CaseManager.ImportedCases
  alias CaseManager.Cases.Case

  import CaseManagerWeb.LiveUtils

  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :imported_cases, [])}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Imported case")
    |> assign(:imported_case, ImportedCases.get_imported_case!(id))
  end

  defp apply_action(socket, :validate, %{"id" => id}) do
    socket
    |> assign(:page_title, "Validate Imported case")
    |> assign(:imported_case, ImportedCases.get_imported_case!(id))
    |> assign(:case, %Case{})
  end

  defp apply_action(socket, :index, params) do
    case ImportedCases.list_imported_cases(params) do
      {:ok, {cases, meta}} ->
        socket
        |> assign(:meta, meta)
        |> stream(:imported_cases, cases, reset: true)
        |> assign(:page_title, "Import Queue")
        |> assign(:imported_case, nil)

      {:error, _meta} ->
        # This will reset invalid parameters. Alternatively, you can assign
        # only the meta and render the errors, or you can ignore the error
        # case entirely.
        push_navigate(socket, to: ~p"/imported_cases")
    end
  end

  @impl true
  def handle_info(
        {CaseManagerWeb.ImportedCaseLive.FormComponent, {:saved, imported_case}},
        socket
      ) do
    {:noreply, stream_insert(socket, :imported_cases, imported_case)}
  end

  def handle_info(
        {CaseManagerWeb.ImportedCaseLive.FormComponent, {:deleted, imported_case}},
        socket
      ) do
    {:noreply, stream_delete(socket, :imported_cases, imported_case)}
  end

  def handle_event("delete", %{"all" => _todo}, socket) do
    ImportedCases.delete_all()

    {:noreply, stream(socket, :imported_cases, [], reset: true)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    imported_case = ImportedCases.get_imported_case!(id)
    {:ok, _} = ImportedCases.delete_imported_case(imported_case)

    {:noreply, stream_delete(socket, :imported_cases, imported_case)}
  end
end
