defmodule CaseManagerWeb.CaseForm do
  require Logger

  use CaseManagerWeb, :live_component

  alias CaseManager.Cases

  @impl true
  def render(assigns) do
    ~H"""
    <div class="">
      <%= if assigns[:flash_copy] && @flash_copy["info"] do %>
        <div
          id="loader"
          class="fixed inset-0 flex items-center justify-center z-1  text-4xl font-bold "
          style="animation: fadeOut 700ms 100ms forwards, hide 800ms 1ms forwards;"
        >
          <div class="p-5 rounded-lg bg-gray-800 bg-opacity-75 text-white">Opening next Case...</div>
        </div>
      <% end %>

      <.header>
        <%= @title %>
        <:subtitle :if={assigns[:subtitle]}><%= @subtitle %></:subtitle>
        <:actions :if={assigns[:imported_case]}>
          <.link
            phx-click={JS.push("delete", value: %{imported_id: @imported_case.id})}
            data-confirm="Are you sure?"
          >
            <.button class="!bg-rose-600 text-white">Delete row</.button>
          </.link>
        </:actions>
      </.header>

      <.simple_form
        for={@form}
        id="case-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
        class="pb-4 pr-4"
      >
        <%= if assigns[:imported_case] do %>
          <.input field={@form[:imported_id]} type="hidden" value={@imported_case.id} />
        <% end %>
        <h1 class="dark:text-indigo-300 text-indigo-600 pt-8 font-semibold">Base data</h1>
        <.input field={@form[:name]} type="text" label="Identifier" force_validate={@validate_now} />
        <.input field={@form[:notes]} type="textarea" label="Notes" force_validate={@validate_now} />

        <.input
          field={@form[:status]}
          type="select"
          label="Status"
          options={Ecto.Enum.values(CaseManager.Cases.Case, :status)}
        />
        <%= if assigns[:imported_case] && @imported_case.occurred_at_string do %>
          <.parsing_hint field_name="Occurred at">
            <%= @imported_case.occurred_at_string %>
          </.parsing_hint>
        <% end %>
        <.input
          field={@form[:occurred_at]}
          type="datetime-local"
          label="Occurred at"
          force_validate={@validate_now}
        />

        <%= if assigns[:imported_case] && @imported_case.time_of_departure_string do %>
          <.parsing_hint field_name="Time of departure">
            <%= @imported_case.time_of_departure_string %>
          </.parsing_hint>
        <% end %>
        <h1 class="dark:text-indigo-300 text-indigo-600 pt-8 font-semibold">Departure</h1>
        <.input
          field={@form[:departure_region]}
          type="select"
          label="Departure Region"
          options={CaseManager.Places.valid_departure_regions()}
          force_validate={@validate_now}
        />
        <.input
          field={@form[:place_of_departure]}
          type="select"
          label="Place of Departure"
          options={CaseManager.Places.valid_departure_places()}
          force_validate={@validate_now}
        />
        <.input
          field={@form[:time_of_departure]}
          type="datetime-local"
          label="Time of Departure"
          force_validate={@validate_now}
        />

        <.input
          field={@form[:sar_region]}
          type="select"
          label="SAR Region"
          options={Ecto.Enum.values(CaseManager.Cases.Case, :sar_region)}
        />

        <h1 class="dark:text-indigo-300 text-indigo-600 pt-8 font-semibold">Positions</h1>

        <%= if assigns[:imported_case] && @imported_case.first_position do %>
          <.parsing_hint field_name="First position">
            <%= @imported_case.first_position %>
          </.parsing_hint>
        <% end %>
        <%= if assigns[:imported_case] && @imported_case.last_position do %>
          <.parsing_hint field_name="Last position">
            <%= @imported_case.last_position %>
          </.parsing_hint>
        <% end %>
        <button
          type="button"
          name="case[positions_sort][]"
          value="new"
          phx-click={JS.dispatch("change")}
          class={[
            "phx-submit-loading:opacity-75 rounded-lg bg-emerald-600 hover:dark:bg-emerald-700 py-2 px-3",
            "text-sm font-semibold leading-5 text-white active:text-white/80"
          ]}
        >
          <.icon name="hero-plus-circle" class="w-5 h-5 text-white" />
        </button>
        <.inputs_for :let={ef} field={@form[:positions]}>
          <div class="break-inside-avoid-column flex flex-row gap-4">
            <input type="hidden" name="case[positions_sort][]" value={ef.index} />
            <.input type="text" field={ef[:short_code]} placeholder="12 22 / 33 44" />
            <.input type="datetime-local" field={ef[:timestamp]} />
            <button
              type="button"
              name="case[positions_drop][]"
              value={ef.index}
              class="w-9 h-9 mt-2 bg-rose-600 hover:bg-rose-700 rounded-lg py-1 px-2"
              phx-click={JS.dispatch("change")}
              data-confirm="Are you sure to delete this position?"
            >
              <.icon name="hero-trash" class="w-5 h-5 text-white" />
            </button>
          </div>
        </.inputs_for>

        <input type="hidden" name="case[positions_drop][]" />

        <h1 class="dark:text-indigo-300 text-indigo-600 pt-8 font-semibold">Involved parties</h1>
        <.input
          field={@form[:phonenumber]}
          type="text"
          label="Phone number"
          force_validate={@validate_now}
        />
        <.input
          field={@form[:alarmphone_contact]}
          type="text"
          label="Alarmphone contact"
          force_validate={@validate_now}
        />
        <.input
          field={@form[:confirmation_by]}
          type="text"
          label="Confirmation by"
          force_validate={@validate_now}
        />
        <.input
          field={@form[:actors_involved]}
          type="text"
          label="Actors involved"
          force_validate={@validate_now}
        />
        <%= if assigns[:imported_case] && @imported_case.authorities_alerted_string do %>
          <.parsing_hint field_name="Authorities alerted">
            <%= @imported_case.authorities_alerted_string %>
          </.parsing_hint>
        <% end %>
        <.input
          field={@form[:authorities_alerted]}
          type="checkbox"
          label="Authorities alerted"
          force_validate={@validate_now}
        />
        <.input
          field={@form[:authorities_details]}
          type="text"
          label="Details of contact w/ authorities"
          force_validate={@validate_now}
        />

        <h1 class="dark:text-indigo-300 text-indigo-600 pt-8 font-semibold">The boat</h1>
        <.input
          field={@form[:boat_type]}
          type="select"
          label="Boat Type"
          options={Ecto.Enum.values(CaseManager.Cases.Case, :boat_type)}
        />
        <.input
          field={@form[:boat_notes]}
          type="text"
          label="Boat Notes"
          force_validate={@validate_now}
        />
        <.input
          field={@form[:boat_color]}
          type="select"
          label="Boat Color"
          options={Ecto.Enum.values(CaseManager.Cases.Case, :boat_color)}
        />
        <.input
          field={@form[:boat_engine_working]}
          type="radiogroup"
          label="Boat Engine Working"
          options={["true", "false", Null]}
          force_validate={@validate_now}
        />

        <%= if assigns[:imported_case] && @imported_case.boat_number_of_engines_string do %>
          <.parsing_hint field_name="Number of engines">
            <%= @imported_case.boat_number_of_engines_string %>
          </.parsing_hint>
        <% end %>
        <.input
          field={@form[:boat_number_of_engines]}
          type="number"
          label="Boat Number of Engines"
          force_validate={@validate_now}
        />

        <h1 class="dark:text-indigo-300 text-indigo-600 pt-8 font-semibold">People on Board</h1>
        <div class="flex gap-4 flex-row flex-wrap">
          <%= if assigns[:imported_case] && @imported_case.pob_total_string do %>
            <.parsing_hint field_name="POB Total">
              <%= @imported_case.pob_total_string %>
            </.parsing_hint>
          <% end %>
          <.input
            field={@form[:pob_total]}
            type="number"
            label="Total"
            wrapper_class="w-2/5 flex-grow"
            force_validate={true}
          />
          <%= if assigns[:imported_case] && @imported_case.pob_men_string do %>
            <.parsing_hint field_name="Men">
              <%= @imported_case.pob_men_string %>
            </.parsing_hint>
          <% end %>
          <.input
            field={@form[:pob_men]}
            type="number"
            label="Men"
            wrapper_class="w-2/5 flex-grow"
            force_validate={true}
          />
          <%= if assigns[:imported_case] && @imported_case.pob_women_string do %>
            <.parsing_hint field_name="Women">
              <%= @imported_case.pob_women_string %>
            </.parsing_hint>
          <% end %>
          <.input
            field={@form[:pob_women]}
            type="number"
            label="Women"
            wrapper_class="w-2/5 flex-grow"
            force_validate={true}
          />
          <%= if assigns[:imported_case] && @imported_case.pob_minors_string do %>
            <.parsing_hint field_name="Minors">
              <%= @imported_case.pob_minors_string %>
            </.parsing_hint>
          <% end %>
          <.input
            field={@form[:pob_minors]}
            type="number"
            label="Minors"
            wrapper_class="w-2/5 flex-grow"
            force_validate={true}
          />
          <%= if assigns[:imported_case] && @imported_case.pob_gender_ambiguous_string do %>
            <.parsing_hint field_name="Gender ambigous">
              <%= @imported_case.pob_gender_ambiguous_string %>
            </.parsing_hint>
          <% end %>
          <.input
            field={@form[:pob_gender_ambiguous]}
            type="number"
            label="Gender ambigous"
            wrapper_class="w-2/5 flex-grow"
            force_validate={true}
          />
          <.input
            field={@form[:pob_medical_cases]}
            type="number"
            label="Medical Cases"
            wrapper_class="w-2/5 flex-grow"
            force_validate={true}
          />
          <%= if assigns[:imported_case] && @imported_case.people_dead_string do %>
            <.parsing_hint field_name="People dead">
              <%= @imported_case.people_dead_string %>
            </.parsing_hint>
          <% end %>
          <.input
            field={@form[:people_dead]}
            type="number"
            label="Dead"
            wrapper_class="w-2/5 flex-grow"
            force_validate={true}
          />
          <%= if assigns[:imported_case] && @imported_case.people_missing_string do %>
            <.parsing_hint field_name="People missing">
              <%= @imported_case.people_missing_string %>
            </.parsing_hint>
          <% end %>
          <.input
            field={@form[:people_missing]}
            type="number"
            label="Missing"
            wrapper_class="w-2/5 flex-grow"
            force_validate={true}
          />
          <.input
            field={@form[:pob_per_nationality]}
            type="text"
            label="Per nationality"
            wrapper_class="w-2/5 flex-grow"
            force_validate={true}
          />
        </div>

        <h1 class="dark:text-indigo-300 text-indigo-600 pt-8 font-semibold">Outcome</h1>
        <.input
          field={@form[:outcome]}
          type="select"
          label="Outcome"
          options={Ecto.Enum.values(CaseManager.Cases.Case, :outcome)}
        />

        <%= if assigns[:imported_case] && @imported_case.time_of_disembarkation_string do %>
          <.parsing_hint field_name="Time of disembarkation">
            <%= @imported_case.time_of_disembarkation_string %>
          </.parsing_hint>
        <% end %>

        <.input
          field={@form[:time_of_disembarkation]}
          type="datetime-local"
          label="Time of Disembarkation"
        />
        <.input
          field={@form[:place_of_disembarkation]}
          type="select"
          label="Place of Disembarkation"
          options={CaseManager.Places.valid_disembarkation_places()}
          force_validate={@validate_now}
        />
        <.input
          field={@form[:disembarked_by]}
          type="text"
          label="Disembarked by"
          force_validate={@validate_now}
        />
        <.input
          field={@form[:outcome_actors]}
          type="text"
          label="Outcome Actors"
          force_validate={@validate_now}
        />
        <.input
          field={@form[:frontext_involvement]}
          type="text"
          label="Frontext Involvement"
          force_validate={@validate_now}
        />

        <%= if assigns[:imported_case] && @imported_case.followup_needed_string do %>
          <.parsing_hint field_name="Followup needed">
            <%= @imported_case.followup_needed_string %>
          </.parsing_hint>
        <% end %>

        <.input
          field={@form[:followup_needed]}
          type="checkbox"
          label="Followup needed"
          force_validate={@validate_now}
        />

        <.input field={@form[:source]} label="Source" force_validate={@validate_now} />

        <h1 class="dark:text-indigo-300 text-indigo-600 pt-8 font-semibold">Meta</h1>
        <.input field={@form[:url]} type="textarea" label="URLs" force_validate={@validate_now} />
        <.input
          field={@form[:cloud_file_links]}
          type="textarea"
          label="Cloud file links"
          force_validate={@validate_now}
        />

        <:actions>
          <.button phx-disable-with="Saving...">Save Case</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{imported_case: imported_case, action: :import} = assigns, socket) do
    changeset = Cases.change_case(assigns.case, Map.from_struct(imported_case))

    {:ok,
     socket
     |> assign(assigns)
     |> assign_new(:form, fn ->
       to_form(changeset, action: :validate)
     end)}
  end

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
      Cases.change_case(socket.assigns.case, case_params)

    {:noreply, assign(socket, form: to_form(changeset, action: :validate))}
  end

  def handle_event("save", %{"case" => case_params}, socket) do
    # Check user is not readonly
    if socket.assigns.current_user.role != :readonly do
      save_case(socket, socket.assigns.action, case_params)
    else
      Logger.warning(
        "User #{socket.assigns.current_user.email} tried to save case, but is a read-only user."
      )

      {:noreply,
       socket
       |> put_flash(:error, "Method not allowed")}
    end
  end

  defp save_case(socket, :edit, case_params) do
    case Cases.update_case(socket.assigns.case, case_params) do
      {:ok, case} ->
        notify_parent({:saved, case})

        {:noreply,
         socket
         |> put_flash(:info, "Case updated successfully")
         |> push_navigate(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply,
         socket
         |> assign_form(changeset)
         |> put_flash(:warning, "Cannot save case: There are invalid fields in the form")
         |> push_patch(to: socket.assigns.patch_error)}
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

  defp save_case(socket, :import, case_params) do
    case Cases.create_case_and_delete_imported(
           case_params,
           socket.assigns.imported_case
         ) do
      {:ok, %{insert_case: case}} ->
        {:noreply,
         socket
         |> push_event("transition", %{name: "Case"})
         |> assign(transition: true)
         |> put_flash(:info, "Case #{case.name} added to the main database successfully")
         |> push_navigate(to: socket.assigns.patch)}

      {:error, :insert_case, %Ecto.Changeset{} = changeset, _} ->
        {:noreply,
         socket
         |> assign(form: to_form(changeset))
         |> put_flash(:warning, "Cannot save case: There are invalid fields in the form")
         |> push_patch(to: socket.assigns.patch_error)}
    end
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    assign(socket, :form, to_form(changeset))
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
