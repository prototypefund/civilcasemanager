defmodule CaseManager.Repo.Migrations.AddCasesTable do
  use Ecto.Migration

  def change do
    create table(:cases, primary_key: false) do
      add :id, :string
      add :name, :string
      add :notes, :text
      add :created_at, :utc_datetime
      add :occurred_at, :utc_datetime
      add :confirmation_by, :string
      add :status, :string
      add :outcome, :string
      add :outcome_actors, :string
      add :frontext_involvement, :string
      add :departure_region, :string
      add :place_of_departure, :string
      add :time_of_departure, :utc_datetime
      add :time_of_disembarkation, :utc_datetime
      add :place_of_disembarkation, :string
      add :disembarked_by, :string
      add :actors_involved, :string
      add :boat_type, :string
      add :boat_color, :string
      add :boat_number_of_engines, :integer
      add :boat_engine_status, :string
      add :boat_engine_working, :string
      add :boat_notes, :text
      add :pob_total, :integer
      add :pob_women, :integer
      add :pob_men, :integer
      add :pob_minors, :integer
      add :pob_medical_cases, :integer
      add :people_dead, :integer
      add :people_missing, :integer
      add :authorities_alerted, :boolean
      add :authorities_details, :text
      add :phonenumber, :string
      add :alarmphone_contact, :string
      add :sar_region, :string
      add :url, :string
      add :template, :string
      add :imported_from, :string
      add :pob_gender_ambiguous, :integer
      add :followup_needed, :boolean
      add :pob_per_nationality, :string
      add :cloud_file_links, :string
    end
  end
end
