defmodule CaseManagerWeb.CaseLive.Index do
  use CaseManagerWeb, :live_view

  require Logger

  alias CaseManager.Cases
  alias CaseManager.Cases.Case
  import CaseManagerWeb.LiveUtils

  @impl true
  def mount(_params, _session, socket) do
    if connected?(socket), do: Cases.subscribe()
    {:ok, stream(socket, :cases, [])}
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

  defp apply_action(socket, :index, params) do
    case Cases.list_cases(params) do
      {:ok, {cases, meta}} ->
        grouped_cases =
          cases
          |> Enum.group_by(&get_key_from_date(&1.occurred_at))
          |> Enum.map(fn {date, case_list} -> %{id: date, case_list: case_list} end)
          |> Enum.sort_by(fn %{id: date} -> date_to_compare_value(date) end, {:desc, Date})

        socket
        |> assign(:meta, meta)
        |> stream(:cases, grouped_cases, reset: true)
        |> assign(:page_title, "Listing Cases")
        |> assign(:case, nil)

      {:error, meta} ->
        Logger.warning("Invalid filter parameters: #{inspect(meta)}")

        # Reset the parameters to the default values
        push_navigate(socket, to: ~p"/cases")
    end
  end

  defp date_to_compare_value(:unknown) do
    ~D[9999-12-31]
  end

  defp date_to_compare_value(date) do
    date
  end

  defp get_key_from_date(nil) do
    :unknown
  end

  defp get_key_from_date(date) do
    DateTime.to_date(date)
  end

  defp key_to_string(:unknown) do
    "Unknown date"
  end

  defp key_to_string(date) do
    Date.to_string(date)
  end

  @impl true
  def handle_info({:case_created, _case}, socket) do
    # TODO: Must be rethought to accomodate date grouping
    # {:noreply, stream_insert(socket, :cases, case, at: 0)}
    {:noreply, socket}
  end

  @impl true
  def handle_info({:case_updated, _case}, socket) do
    # TODO: Must be rethought to accomodate date grouping
    # {:noreply, stream_insert(socket, :cases, case, at: 0)}
    {:noreply, socket}
  end

  @impl true
  def handle_info({CaseManagerWeb.CaseForm, {:saved, _case}}, socket) do
    # TODO: Must be rethought to accomodate date grouping
    # {:noreply, stream_insert(socket, :cases, case)}
    {:noreply, socket}
  end

  @impl true
  def handle_event("update-filter", params, socket) do
    params = Map.delete(params, "_target")
    {:noreply, push_patch(socket, to: ~p"/cases?#{params}")}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    if socket.assigns.current_user.role != :readonly do
      case = Cases.get_case!(id)
      {:ok, _} = Cases.delete_case(case)

      # TODO: Must be rethought to accomodate date grouping
      # {:noreply, stream_delete(socket, :cases, case)}
      {:noreply, socket}
    else
      Logger.warning(
        "User #{socket.assigns.current_user.email} tried to delete case, but is a read-only user."
      )

      {:noreply,
       socket
       |> put_flash(:error, "Method not allowed")}
    end
  end

  defp get_color_for_year_tag(case) do
    year = Cases.get_year(case)

    if year do
      if year == Date.utc_today().year do
        "emerald"
      else
        "gray"
      end
    end
  end

  defp get_color_for_status(status) do
    case status do
      :open -> "emerald"
      :closed -> "gray"
      :archived -> "gray"
      :ready_for_documentation -> "blue"
      _ -> "blue"
    end
  end

  defp escape_id(id) do
    String.replace(id, "/", "")
  end

  attr :status, :atom, required: true
  attr :class, :string, default: ""

  def status_icon(%{status: status} = assigns) do
    classes =
      case status do
        :open -> "hero-inbox-solid text-"
        :closed -> "hero-lock-closed text-"
        :archived -> "hero-archive-box text-"
        :ready_for_documentation -> "hero-clipboard-document-list text-0"
        _ -> "hero-question-mark-circle text-"
      end

    classes = classes <> get_color_for_status(status) <> "-500"

    assigns = assign(assigns, :icon_name, classes)
    ~H"<span class={[@icon_name, @class]} />"
  end
end
