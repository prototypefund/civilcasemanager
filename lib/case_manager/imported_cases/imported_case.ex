defmodule CaseManager.ImportedCases.ImportedCase do
  use Ecto.Schema
  import Ecto.Changeset

  @derive {
    Flop.Schema,
    filterable: [:name],
    sortable: [:inserted_at],
    default_order: %{
      order_by: [:inserted_at],
      order_directions: [:desc, :asc]
    }
  }

  schema "imported_cases" do
    field :alarmphone_contact, :string
    field :url, :string
    field :disembarked_by, :string
    field :people_missing, :integer
    field :people_missing_string, :string
    field :boat_color, :string, default: "unknown"
    field :cloud_file_links, :string
    field :notes, :string
    field :pob_women, :integer
    field :pob_women_string, :string
    field :time_of_departure, :utc_datetime
    field :time_of_departure_string, :string
    field :place_of_departure, :string
    field :boat_type, :string, default: "unknown"
    field :pob_minors, :integer
    field :pob_minors_string, :string
    field :name, :string
    field :place_of_disembarkation, :string
    field :authorities_details, :string
    field :actors_involved, :string
    field :authorities_alerted, :boolean, default: false
    field :authorities_alerted_string, :string
    field :followup_needed, :boolean, default: false
    field :followup_needed_string, :string
    field :phonenumber, :string
    field :boat_notes, :string
    field :pob_men, :integer
    field :pob_men_string, :string
    field :pob_medical_cases, :integer
    field :pob_medical_cases_string, :string
    field :status, :string, default: "closed"
    field :pob_total, :integer
    field :pob_total_string, :string
    field :frontext_involvement, :string
    field :confirmation_by, :string
    field :time_of_disembarkation, :utc_datetime
    field :time_of_disembarkation_string, :string
    field :sar_region, :string, default: "unknown"
    field :pob_gender_ambiguous, :integer
    field :pob_gender_ambiguous_string, :string
    field :boat_number_of_engines, :integer
    field :boat_number_of_engines_string, :string
    field :outcome, :string
    field :departure_region, :string
    field :imported_from, :string
    field :boat_engine_working, :boolean
    field :boat_engine_status, :string
    field :occurred_at, :utc_datetime
    field :occurred_at_string, :string
    field :outcome_actors, :string
    field :pob_per_nationality, :string
    field :template, :string
    field :people_dead, :integer
    field :people_dead_string, :string
    field :first_position, :string
    field :last_position, :string
    field :source, :string
    field :row, :integer

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(imported_case, attrs) do
    imported_case
    |> cast(attrs, __MODULE__.__schema__(:fields))
  end

  def upload_changeset(imported_case, attrs) do
    imported_case
    |> cast(attrs, [
      :url,
      :cloud_file_links,
      :imported_from
    ])
  end
end
