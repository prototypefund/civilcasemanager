defmodule CaseManager.Repo.Migrations.AddCasesTable do
  use Ecto.Migration

  def up do
    execute """
    CREATE TABLE IF NOT EXISTS public.cases (
      id text NULL,
      "name" text NULL,
      notes text NULL,
      created_at timestamp NULL,
      occurred_at timestamp NULL,
      confirmation_by text NULL,
      status text NULL,
      outcome text NULL,
      outcome_actors text NULL,
      frontext_involvement text NULL,
      departure_region text NULL,
      place_of_departure text NULL,
      time_of_departure timestamp NULL,
      time_of_disembarkation timestamp NULL,
      place_of_disembarkation text NULL,
      disembarked_by text NULL,
      actors_involved text NULL,
      boat_type text NULL,
      boat_color text NULL,
      boat_number_of_engines int4 NULL,
      boat_engine_status text NULL,
      boat_engine_working text NULL,
      boat_notes text NULL,
      pob_total int4 NULL,
      pob_women int4 NULL,
      pob_men int4 NULL,
      pob_minors int4 NULL,
      pob_medical_cases int4 NULL,
      people_dead int4 NULL,
      people_missing int4 NULL,
      authorities_alerted bool NULL,
      authorities_details text NULL,
      phonenumber text NULL,
      alarmphone_contact text NULL,
      sar_region text NULL,
      url text NULL,
      "template" text NULL,
      imported_from text NULL,
      pob_gender_ambiguous int4 NULL,
      followup_needed bool NULL,
      pob_per_nationality varchar NULL,
      cloud_file_links varchar NULL
    );
    """
  end

  def down do
  end
end
