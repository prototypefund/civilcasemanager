defmodule CaseManagerWeb.PassengerLive.Show do
  use CaseManagerWeb, :live_view

  alias CaseManager.Passengers

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:passenger, Passengers.get_passenger!(id))}
  end

  defp page_title(:show), do: "Show Passenger"
  defp page_title(:edit), do: "Edit Passenger"
end
