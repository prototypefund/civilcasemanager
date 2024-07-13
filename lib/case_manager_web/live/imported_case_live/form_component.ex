defmodule CaseManagerWeb.ImportedCaseLive.FormComponent do
  require Logger
  alias CaseManager.ImportedCases
  use CaseManagerWeb, :live_component

  alias CaseManager.Cases

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Check the import data</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="imported_case-form"
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
          options={get_options(CaseManager.Cases.Case, :status, @form[:status], true)}
        />

        <%= if @imported_case.occurred_at_string do %>
          <div class="text-rose-600">
            <strong>Occurred at (original):</strong> <%= @imported_case.occurred_at_string %>
          </div>
        <% end %>
        <.input field={@form[:occurred_at]} type="datetime-local" label="Occurred at" />

        <h1 class="text-indigo-600 pt-8 font-semibold">Departure</h1>
        <.input field={@form[:departure_region]} type="text" label="Departure Region" />

        <%!-- Should be autocomplete --%>
        <.input field={@form[:place_of_departure]} type="text" label="Place of Departure" />
        <%= if @imported_case.time_of_departure_string do %>
          <div class="text-rose-600">
            <strong>Time of departure (original):</strong> <%= @imported_case.time_of_departure_string %>
          </div>
        <% end %>
        <.input field={@form[:time_of_departure]} type="datetime-local" label="Time of Departure" />
        <.input
          field={@form[:sar_region]}
          type="select"
          label="SAR Region"
          options={get_options(CaseManager.Cases.Case, :sar_region, @form[:sar_region], true)}
        />

        <h1 class="text-indigo-600 pt-8 font-semibold">Involved parties</h1>
        <.input field={@form[:phonenumber]} type="text" label="Phone number" />
        <.input field={@form[:alarmphone_contact]} type="text" label="Alarmphone contact" />
        <.input field={@form[:confirmation_by]} type="text" label="Confirmation by" />
        <.input field={@form[:actors_involved]} type="text" label="Actors involved" />
        <%= if @imported_case.authorities_alerted_string do %>
          <div class="text-rose-600">
            <strong>Authorities alerted (original):</strong> <%= @imported_case.authorities_alerted_string %>
          </div>
        <% end %>
        <.input field={@form[:authorities_alerted]} type="checkbox" label="Authorities alerted" />
        <.input field={@form[:authorities_details]} type="text" label="Authorities details" />

        <h1 class="text-indigo-600 pt-8 font-semibold">The boat</h1>
        <.input
          field={@form[:boat_type]}
          type="select"
          label="Boat Type"
          options={get_options(CaseManager.Cases.Case, :boat_type, @form[:boat_type], true)}
        />
        <.input field={@form[:boat_notes]} type="text" label="Boat Notes" />
        <.input field={@form[:boat_color]} type="text" label="Boat Color" />
        <.input field={@form[:boat_engine_status]} type="text" label="Boat Engine Status" />
        <.input field={@form[:boat_engine_working]} type="text" label="Boat Engine Working" />
        <%= if @imported_case.boat_number_of_engines_string do %>
          <div class="text-rose-600">
            <strong>Boat number of engines (original):</strong> <%= @imported_case.boat_number_of_engines_string %>
          </div>
        <% end %>
        <.input field={@form[:boat_number_of_engines]} type="number" label="Boat Number of Engines" />

        <h1 class="text-indigo-600 pt-8 font-semibold">People on Board</h1>
        <div class="flex gap-4 flex-row flex-wrap">
          <%= if @imported_case.pob_total_string do %>
            <div class="text-rose-600">
              <strong>Pob total (original):</strong> <%= @imported_case.pob_total_string %>
            </div>
          <% end %>
          <.input
            field={@form[:pob_total]}
            type="number"
            label="Total"
            wrapper_class="w-2/5 flex-grow"
          />
          <%= if @imported_case.pob_men_string do %>
            <div class="text-rose-600">
              <strong>Pob men (original):</strong> <%= @imported_case.pob_men_string %>
            </div>
          <% end %>
          <.input field={@form[:pob_men]} type="number" label="Men" wrapper_class="w-2/5 flex-grow" />
          <%= if @imported_case.pob_women_string do %>
            <div class="text-rose-600">
              <strong>Pob women (original):</strong> <%= @imported_case.pob_women_string %>
            </div>
          <% end %>
          <.input
            field={@form[:pob_women]}
            type="number"
            label="Women"
            wrapper_class="w-2/5 flex-grow"
          />
          <%= if @imported_case.pob_minors_string do %>
            <div class="text-rose-600">
              <strong>Pob minors (original):</strong> <%= @imported_case.pob_minors_string %>
            </div>
          <% end %>
          <.input
            field={@form[:pob_minors]}
            type="number"
            label="Minors"
            wrapper_class="w-2/5 flex-grow"
          />
          <%= if @imported_case.pob_gender_ambiguous_string do %>
            <div class="text-rose-600">
              <strong>Pob gender ambiguous (original):</strong> <%= @imported_case.pob_gender_ambiguous_string %>
            </div>
          <% end %>
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
          <%= if @imported_case.people_dead_string do %>
            <div class="text-rose-600">
              <strong>People dead (original):</strong> <%= @imported_case.people_dead_string %>
            </div>
          <% end %>
          <.input
            field={@form[:people_dead]}
            type="number"
            label="Dead"
            wrapper_class="w-2/5 flex-grow"
          />
          <%= if @imported_case.people_missing_string do %>
            <div class="text-rose-600">
              <strong>People missing (original):</strong> <%= @imported_case.people_missing_string %>
            </div>
          <% end %>
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
        <.input
          field={@form[:outcome]}
          type="select"
          label="Outcome"
          options={get_options(CaseManager.Cases.Case, :outcome, @form[:outcome], true)}
        />

        <%= if @imported_case.time_of_disembarkation_string do %>
          <div class="text-rose-600">
            <strong>Time of disembarkation (original):</strong> <%= @imported_case.time_of_disembarkation_string %>
          </div>
        <% end %>

        <.input
          field={@form[:time_of_disembarkation]}
          type="datetime-local"
          label="Time of Disembarkation"
        />
        <.input field={@form[:place_of_disembarkation]} type="text" label="Place of Disembarkation" />
        <.input field={@form[:disembarked_by]} type="text" label="Disembarked by" />
        <.input field={@form[:outcome_actors]} type="text" label="Outcome Actors" />
        <.input field={@form[:frontext_involvement]} type="text" label="Frontext Involvement" />
        <%= if @imported_case.followup_needed_string do %>
          <div class="text-rose-600">
            <strong>Followup needed (original):</strong> <%= @imported_case.followup_needed_string %>
          </div>
        <% end %>
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

  def get_options(module, key, field, allow_invalid \\ false) do
    valid_values = Ecto.Enum.values(module, key)

    if allow_invalid && field.value && field.value not in valid_values do
      valid_values ++ [{"INVALID -> " <> field.value <> " <- INVALID", field.value}]
    else
      valid_values
    end
  end

  @impl true
  def update(%{imported_case: imported_case} = assigns, socket) do
    changeset = Cases.change_case(assigns.case, Map.from_struct(imported_case))

    {:ok,
     socket
     |> assign(assigns)
     |> assign_new(:form, fn ->
       to_form(changeset, action: :validate)
     end)}
  end

  @impl true
  def handle_event("validate", %{"case" => imported_case_params}, socket) do
    changeset =
      Cases.change_case(socket.assigns.case, imported_case_params)

    {:noreply, assign(socket, form: to_form(changeset, action: :validate))}
  end

  def handle_event("save", %{"case" => imported_case_params}, socket) do
    save_imported_case(socket, socket.assigns.action, imported_case_params)
  end

  defp save_imported_case(socket, _, imported_case_params) do
    # creating the case and deleting the imported case should be done in a transaction.
    case Cases.create_case_and_delete_imported(
           imported_case_params,
           socket.assigns.imported_case
         ) do
      {:ok, case} ->
        notify_parent({:deleted, case})

        ## FIXME get actually next in list based on current
        next_case =
          ImportedCases.get_next_case_after(socket.assigns.imported_case)

        patch_url =
          if next_case,
            do: ~p"/imported_cases/#{next_case.id}/validate#imported_case-modal-content",
            else: ~p"/imported_cases"

        {:noreply,
         socket
         |> push_patch(to: patch_url)
         |> put_flash(:info, "Case added to the main database successfully")}

      {:error, :insert_case, %Ecto.Changeset{} = changeset, _} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
