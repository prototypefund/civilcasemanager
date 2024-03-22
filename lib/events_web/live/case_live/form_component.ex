defmodule EventsWeb.CaseLive.FormComponent do
  use EventsWeb, :live_component

  alias Events.Cases

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Use this form to manage case records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="case-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:identifier]} type="text" label="Identifier" />
        <.input field={@form[:title]} type="text" label="Title" />
        <.input field={@form[:description]} type="text" label="Description" />
        <.input field={@form[:created_at]} type="datetime-local" label="Created at" />
        <.input field={@form[:freetext]} type="textarea" label="Notes" />
        <.input
          field={@form[:status]}
          type="select"
          label="Status"
          options={Ecto.Enum.values(Events.Cases.Case, :status)}
        />
        <.input field={@form[:status_note]} type="text" label="Status note" />
        <:actions>
          <.button phx-disable-with="Saving...">Save Case</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{case: case} = assigns, socket) do
    changeset = Cases.change_case(case)

    {:ok,
     socket
     |> assign(assigns)
     |> assign_form(changeset)}
  end

  @impl true
  def handle_event("validate", %{"case" => case_params}, socket) do
    changeset =
      socket.assigns.case
      |> Cases.change_case(case_params)
      |> Map.put(:action, :validate)

    {:noreply, assign_form(socket, changeset)}
  end

  def handle_event("save", %{"case" => case_params}, socket) do
    save_case(socket, socket.assigns.action, case_params)
  end

  defp save_case(socket, :edit, case_params) do
    case Cases.update_case(socket.assigns.case, case_params) do
      {:ok, case} ->
        notify_parent({:saved, case})

        {:noreply,
         socket
         |> put_flash(:info, "Case updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp save_case(socket, :new, case_params) do
    case Cases.create_case(case_params) do
      {:ok, case} ->
        notify_parent({:saved, case})

        {:noreply,
         socket
         |> put_flash(:info, "Case created successfully")
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
