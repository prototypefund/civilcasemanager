defmodule EventsWeb.CaseLive.Show do
  use EventsWeb, :live_view

  alias Events.Cases

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket, layout: {EventsWeb.Layouts, "column.html"}}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:case, Cases.get_case!(id))}
  end

  defp page_title(:show), do: "Show Case"
  defp page_title(:edit), do: "Edit Case"
end
