defmodule CaseManagerWeb.PlaceLive.FormComponent do
  use CaseManagerWeb, :live_component

  alias CaseManager.Places

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Use this form to manage place records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="place-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:name]} type="text" label="Name" />
        <.input field={@form[:country]} type="text" label="Country" />
        <.input
          field={@form[:sar_zone]}
          type="select"
          label="SAR Zone"
          prompt="Choose a value"
          options={Ecto.Enum.values(CaseManager.Places.Place, :sar_zone)}
        />
        <.input field={@form[:lat]} type="number" label="Lat" step="any" />
        <.input field={@form[:lon]} type="number" label="Lon" step="any" />
        <.input
          field={@form[:type]}
          type="select"
          label="Type"
          prompt="Choose a value"
          options={Ecto.Enum.values(CaseManager.Places.Place, :type)}
        />
        <:actions>
          <.button phx-disable-with="Saving...">Save Place</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{place: place} = assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> assign_new(:form, fn ->
       to_form(Places.change_place(place))
     end)}
  end

  @impl true
  def handle_event("validate", %{"place" => place_params}, socket) do
    changeset = Places.change_place(socket.assigns.place, place_params)
    {:noreply, assign(socket, form: to_form(changeset, action: :validate))}
  end

  def handle_event("save", %{"place" => place_params}, socket) do
    CaseManagerWeb.UserLive.Auth.run_if_user_can_write(socket, Places.Place, fn ->
      save_place(socket, socket.assigns.action, place_params)
    end)
  end

  defp save_place(socket, :edit, place_params) do
    case Places.update_place(socket.assigns.place, place_params) do
      {:ok, place} ->
        notify_parent({:saved, place})

        {:noreply,
         socket
         |> put_flash(:info, "Place updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp save_place(socket, :new, place_params) do
    case Places.create_place(place_params) do
      {:ok, place} ->
        notify_parent({:saved, place})

        {:noreply,
         socket
         |> put_flash(:info, "Place created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
