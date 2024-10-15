defmodule CaseManager.Repo.Migrations.CreateImportedCases do
  use Ecto.Migration

  def change do
    create table(:imported_cases) do
      add :name, :string
      add :notes, :text
      add :status, :string
      add :occurred_at, :utc_datetime
      add :departure_region, :string
      add :place_of_departure, :string
      add :time_of_departure, :utc_datetime
      add :sar_region, :string
      add :phonenumber, :string
      add :alarmphone_contact, :string
      add :confirmation_by, :string
      add :actors_involved, :string
      add :authorities_alerted, :boolean, default: false
      add :authorities_details, :string
      add :boat_type, :string
      add :boat_notes, :string
      add :boat_color, :string
      add :boat_engine_status, :string
      add :boat_engine_failure, :string
      add :boat_number_of_engines, :integer
      add :pob_total, :integer
      add :pob_men, :integer
      add :pob_women, :integer
      add :pob_minors, :integer
      add :pob_gender_ambiguous, :integer
      add :pob_medical_cases, :integer
      add :people_dead, :integer
      add :people_missing, :integer
      add :pob_per_nationality, :string
      add :outcome, :string
      add :time_of_disembarkation, :utc_datetime
      add :place_of_disembarkation, :string
      add :disembarked_by, :string
      add :outcome_actors, :string
      add :frontext_involvement, :string
      add :followup_needed, :boolean, default: false
      add :template, :string
      add :url, :string
      add :cloud_file_links, :string
      add :imported_from, :string
      add :first_position, :string
      add :last_position, :string
      ## Fallback keys for dirty data
      add :people_missing_string, :string
      add :pob_women_string, :string
      add :time_of_departure_string, :string
      add :pob_minors_string, :string
      add :authorities_alerted_string, :string
      add :followup_needed_string, :string
      add :pob_men_string, :string
      add :pob_medical_cases_string, :string
      add :pob_total_string, :string
      add :time_of_disembarkation_string, :string
      add :pob_gender_ambiguous_string, :string
      add :boat_number_of_engines_string, :string
      add :occurred_at_string, :string
      add :people_dead_string, :string
      add :source, :string
      add :row, :integer

      timestamps(type: :utc_datetime)
    end
  end
end
