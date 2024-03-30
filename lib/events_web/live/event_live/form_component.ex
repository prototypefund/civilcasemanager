defmodule EventsWeb.EventLive.FormComponent do
  use EventsWeb, :live_component

  alias Events.Eventlog

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Use this form to manage event records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="event-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:type]} type="hidden" />
        <.input field={@form[:received_at]} type="datetime-local" label="Zulu time received" />
        <.input field={@form[:title]} type="text" label="Title" />
        <.input field={@form[:body]} type="textarea" label="Body" />
        <.input field={@form[:metadata]} type="textarea" label="Metadata" />
        <.input field={@form[:from]} type="text" label="From" />

        <.input
          field={@form[:cases]}
          type="select"
          label="Associated cases"
          multiple
          autocomplete="on"
          options={Enum.map(Events.Cases.list_open_cases(), &{&1.identifier, &1.id})}
          value={if is_list(@form.data.cases), do: Enum.map(@form.data.cases, &(&1.id)), else: []}
        />

        <:actions>
          <.button phx-disable-with="Saving...">Save Event</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{event: event} = assigns, socket) do
    changeset = Eventlog.change_event(event)

    {:ok,
     socket
     |> assign(assigns)
     |> assign_form(changeset)}
  end

  @impl true
  def handle_event("validate", %{"event" => event_params}, socket) do
    changeset =
      socket.assigns.event
      |> Eventlog.change_event(event_params)
      |> Map.put(:action, :validate)

    {:noreply, assign_form(socket, changeset)}
  end

  def handle_event("save", %{"event" => event_params}, socket) do
    save_event(socket, socket.assigns.action, event_params)
  end

  defp save_event(socket, :edit, event_params) do
    case Eventlog.update_event(socket.assigns.event, event_params) do
      {:ok, event} ->
        notify_parent({:saved, event})

        {:noreply,
         socket
         |> put_flash(:info, "Event updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp save_event(socket, :new, event_params) do
    case Eventlog.create_event(event_params) do
      {:ok, event} ->
        notify_parent({:saved, event})

        {:noreply,
         socket
         |> put_flash(:info, "Event created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    assign(socket, :form, to_form(changeset))
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
