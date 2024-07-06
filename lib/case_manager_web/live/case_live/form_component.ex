defmodule CaseManagerWeb.CaseLive.FormComponent do
  use CaseManagerWeb, :live_component

  alias CaseManager.Cases

  @impl true
  def render(assigns) do
    ~H"""
    <div class="flex flex-col h-full">
      <.header>
        <%= @title %>
      </.header>

      <.simple_form
        for={@form}
        id="case-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
        class="h-full overflow-y-scroll pb-4 pr-4"
      >
        <h1 class="text-indigo-600 pt-8 font-semibold">Base data</h1>
        <.input field={@form[:name]} type="text" label="Identifier" />
        <.input field={@form[:notes]} type="text" label="Notes" />

        <.input
          field={@form[:status]}
          type="select"
          label="Status"
          options={Ecto.Enum.values(CaseManager.Cases.Case, :status)}
        />

        <.input field={@form[:created_at]} type="datetime-local" label="Created at" />
        <.input field={@form[:occurred_at]} type="datetime-local" label="Occurred at" />

        <h1 class="text-indigo-600 pt-8 font-semibold">Departure</h1>
        <.input field={@form[:departure_region]} type="text" label="Departure Region" />

        <%!-- Should be autocomplete --%>
        <.input field={@form[:place_of_departure]} type="text" label="Place of Departure" />
        <.input field={@form[:time_of_departure]} type="datetime-local" label="Time of Departure" />
        <.input field={@form[:sar_region]} type="text" label="SAR Region" />

        <h1 class="text-indigo-600 pt-8 font-semibold">Involved parties</h1>
        <.input field={@form[:phonenumber]} type="text" label="Phone number" />
        <.input field={@form[:alarmphone_contact]} type="text" label="Alarmphone contact" />
        <.input field={@form[:confirmation_by]} type="text" label="Confirmation by" />
        <.input field={@form[:actors_involved]} type="text" label="Actors involved" />
        <.input field={@form[:authorities_alerted]} type="checkbox" label="Authorities alerted" />
        <.input field={@form[:authorities_details]} type="text" label="Authorities details" />

        <h1 class="text-indigo-600 pt-8 font-semibold">The boat</h1>
        <.input
          field={@form[:boat_type]}
          type="select"
          label="Boat Type"
          options={Ecto.Enum.values(CaseManager.Cases.Case, :boat_type)}
        />
        <.input field={@form[:boat_notes]} type="text" label="Boat Notes" />
        <.input field={@form[:boat_color]} type="text" label="Boat Color" />
        <.input field={@form[:boat_engine_status]} type="text" label="Boat Engine Status" />
        <.input field={@form[:boat_engine_working]} type="text" label="Boat Engine Working" />
        <.input field={@form[:boat_number_of_engines]} type="number" label="Boat Number of Engines" />

        <h1 class="text-indigo-600 pt-8 font-semibold">People on Board</h1>
        <div class="flex gap-4 flex-row flex-wrap">
          <.input
            field={@form[:pob_total]}
            type="number"
            label="Total"
            wrapper_class="w-2/5 flex-grow"
          />
          <.input field={@form[:pob_men]} type="number" label="Men" wrapper_class="w-2/5 flex-grow" />
          <.input
            field={@form[:pob_women]}
            type="number"
            label="Women"
            wrapper_class="w-2/5 flex-grow"
          />
          <.input
            field={@form[:pob_minors]}
            type="number"
            label="Minors"
            wrapper_class="w-2/5 flex-grow"
          />
          <.input
            field={@form[:pob_gender_ambiguous]}
            type="number"
            label="Gender ambigous"
            wrapper_class="w-2/5 flex-grow"
          />
          <.input
            field={@form[:pob_medical_cases]}
            type="number"
            label="Medical Cases"
            wrapper_class="w-2/5 flex-grow"
          />
          <.input
            field={@form[:people_dead]}
            type="number"
            label="Dead"
            wrapper_class="w-2/5 flex-grow"
          />
          <.input
            field={@form[:people_missing]}
            type="number"
            label="Missing"
            wrapper_class="w-2/5 flex-grow"
          />
          <.input
            field={@form[:pob_per_nationality]}
            type="text"
            label="Per nationality"
            wrapper_class="w-2/5 flex-grow"
          />
        </div>

        <h1 class="text-indigo-600 pt-8 font-semibold">Outcome</h1>
        <.input field={@form[:outcome]} type="text" label="Outcome" />
        <.input
          field={@form[:time_of_disembarkation]}
          type="datetime-local"
          label="Time of Disembarkation"
        />
        <.input field={@form[:place_of_disembarkation]} type="text" label="Place of Disembarkation" />
        <.input field={@form[:disembarked_by]} type="text" label="Disembarked by" />
        <.input field={@form[:outcome_actors]} type="text" label="Outcome Actors" />
        <.input field={@form[:frontext_involvement]} type="text" label="Frontext Involvement" />
        <.input field={@form[:followup_needed]} type="checkbox" label="Followup needed" />

        <h1 class="text-indigo-600 pt-8 font-semibold">Meta</h1>
        <.input field={@form[:url]} type="textarea" label="URL" />
        <.input field={@form[:cloud_file_links]} type="textarea" label="Cloud file links" />

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
    # Check user is not readonly
    if socket.assigns.current_user.role != :readonly do
      save_case(socket, socket.assigns.action, case_params)
    end
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
