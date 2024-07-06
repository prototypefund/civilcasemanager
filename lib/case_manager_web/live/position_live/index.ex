defmodule CaseManagerWeb.PositionLive.Index do
  use CaseManagerWeb, :live_view

  alias CaseManager.Positions
  alias CaseManager.Positions.Position

  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :positions, Positions.list_positions())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Position")
    |> assign(:position, Positions.get_position!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Position")
    |> assign(:position, %Position{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Positions")
    |> assign(:position, nil)
  end

  @impl true
  def handle_info({CaseManagerWeb.PositionLive.FormComponent, {:saved, position}}, socket) do
    {:noreply, stream_insert(socket, :positions, position)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    if socket.assigns.current_user.role != :readonly do
      position = Positions.get_position!(id)
      {:ok, _} = Positions.delete_position(position)

      {:noreply, stream_delete(socket, :positions, position)}
    end
  end
end
