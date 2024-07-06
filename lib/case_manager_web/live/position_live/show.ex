defmodule CaseManagerWeb.PositionLive.Show do
  use CaseManagerWeb, :live_view

  alias CaseManager.Positions

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:position, Positions.get_position!(id))}
  end

  defp page_title(:show), do: "Show Position"
  defp page_title(:edit), do: "Edit Position"
end
