defmodule CaseManagerWeb.EventLive.FormSmall do
  use CaseManagerWeb, :live_component

  alias CaseManager.Events
  require Logger

  @impl true

  # TODO Remove margin-top
  def render(assigns) do
    ~H"""
    <div>
      <.simple_form
        for={@form}
        id="event-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:type]} type="hidden" value="manual" />
        <.input field={@form[:title]} type="hidden" value={@case.name} />
        <.input field={@form[:body]} type="textarea" placeholder={gettext("Enter some notes here")} />
        <.input field={@form[:from]} type="hidden" value={@current_user.name} />
        <.input field={@form[:cases]} type="hidden" value={[@case.id]} />
        <:actions>
          <.button
            phx-disable-with="Saving..."
            class="text-white !bg-indigo-600 rounded-md !hover:bg-indigo-500 ml-auto"
          >
            Submit
          </.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{event: event} = assigns, socket) do
    changeset = Events.change_event(event)

    {:ok,
     socket
     |> assign(assigns)
     |> assign_form(changeset)}
  end

  @impl true
  def handle_event("validate", %{"event" => event_params}, socket) do
    changeset =
      socket.assigns.event
      |> Events.change_event(event_params)
      |> Map.put(:action, :validate)

    {:noreply, assign_form(socket, changeset)}
  end

  def handle_event("save", %{"event" => event_params}, socket) do
    CaseManagerWeb.UserLive.Auth.run_if_user_can_write(socket, Events.Event, fn ->
      case Events.create_event(event_params) do
        {:ok, event} ->
          notify_parent({:saved, event})

          {
            :noreply,
            socket
            |> put_flash(:info, "Event created successfully")
            # put_patch...
          }

        {:error, %Ecto.Changeset{} = changeset} ->
          {:noreply, assign_form(socket, changeset)}
      end
    end)
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    assign(socket, :form, to_form(changeset))
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
