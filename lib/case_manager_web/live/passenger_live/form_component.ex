defmodule CaseManagerWeb.PassengerLive.FormComponent do
  use CaseManagerWeb, :live_component

  alias CaseManager.Passengers

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Use this form to manage passenger records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="passenger-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:name]} type="text" label="Name" />
        <.input field={@form[:description]} type="text" label="Description" />
        <.input field={@form[:case_id]} type="text" label="Case ID" />
        <:actions>
          <.button phx-disable-with="Saving...">Save Passenger</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{passenger: passenger} = assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> assign_new(:form, fn ->
       to_form(Passengers.change_passenger(passenger))
     end)}
  end

  @impl true
  def handle_event("validate", %{"passenger" => passenger_params}, socket) do
    changeset = Passengers.change_passenger(socket.assigns.passenger, passenger_params)
    {:noreply, assign(socket, form: to_form(changeset, action: :validate))}
  end

  def handle_event("save", %{"passenger" => passenger_params}, socket) do
    save_passenger(socket, socket.assigns.action, passenger_params)
  end

  defp save_passenger(socket, :edit, passenger_params) do
    case Passengers.update_passenger(socket.assigns.passenger, passenger_params) do
      {:ok, passenger} ->
        notify_parent({:saved, passenger})

        {:noreply,
         socket
         |> put_flash(:info, "Passenger updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp save_passenger(socket, :new, passenger_params) do
    case Passengers.create_passenger(passenger_params) do
      {:ok, passenger} ->
        notify_parent({:saved, passenger})

        {:noreply,
         socket
         |> put_flash(:info, "Passenger created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
