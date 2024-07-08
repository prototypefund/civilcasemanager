defmodule CaseManagerWeb.PositionLive.FormComponent do
  use CaseManagerWeb, :live_component
  require Logger
  alias CaseManager.Positions

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Use this form to manage position records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="position-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:id]} type="text" label="Id" />
        <.input field={@form[:altitude]} type="number" label="Altitude" step="any" />
        <.input field={@form[:course]} type="number" label="Course" step="any" />
        <.input field={@form[:heading]} type="number" label="Heading" step="any" />
        <.input field={@form[:lat]} type="number" label="Lat" step="any" />
        <.input field={@form[:lon]} type="number" label="Lon" step="any" />
        <.input field={@form[:source]} type="text" label="Source" />
        <.input field={@form[:speed]} type="number" label="Speed" step="any" />
        <.input field={@form[:timestamp]} type="datetime-local" label="Timestamp" />
        <.input field={@form[:imported_from]} type="text" label="Imported from" />
        <.input field={@form[:soft_deleted]} type="checkbox" label="Soft deleted" />
        <:actions>
          <.button phx-disable-with="Saving...">Save Position</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{position: position} = assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> assign_new(:form, fn ->
       to_form(Positions.change_position(position))
     end)}
  end

  @impl true
  def handle_event("validate", %{"position" => position_params}, socket) do
    changeset = Positions.change_position(socket.assigns.position, position_params)
    {:noreply, assign(socket, form: to_form(changeset, action: :validate))}
  end

  def handle_event("save", %{"position" => position_params}, socket) do
    if socket.assigns.current_user.role != :readonly do
      save_position(socket, socket.assigns.action, position_params)
    else
      Logger.info(
        "User #{socket.assigns.current_user.email} tried to save positions, but is a read-only user."
      )
    end
  end

  defp save_position(socket, :edit, position_params) do
    case Positions.update_position(socket.assigns.position, position_params) do
      {:ok, position} ->
        notify_parent({:saved, position})

        {:noreply,
         socket
         |> put_flash(:info, "Position updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp save_position(socket, :new, position_params) do
    case Positions.create_position(position_params) do
      {:ok, position} ->
        notify_parent({:saved, position})

        {:noreply,
         socket
         |> put_flash(:info, "Position created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
