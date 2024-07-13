defmodule CaseManager.ImportedCasesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `CaseManager.ImportedCases` context.
  """

  @doc """
  Generate a imported_case.
  """
  def imported_case_fixture(attrs \\ %{}) do
    {:ok, imported_case} =
      attrs
      |> Enum.into(%{
        actors_involved: "some actors_involved",
        alarmphone_contact: "some alarmphone_contact",
        authorities_alerted: true,
        authorities_details: "some authorities_details",
        boat_color: "some boat_color",
        boat_engine_status: "some boat_engine_status",
        boat_engine_working: "some boat_engine_working",
        boat_notes: "some boat_notes",
        boat_number_of_engines: 42,
        boat_type: "some boat_type",
        cloud_file_links: "some cloud_file_links",
        confirmation_by: "some confirmation_by",
        departure_region: "some departure_region",
        disembarked_by: "some disembarked_by",
        followup_needed: true,
        frontext_involvement: "some frontext_involvement",
        imported_from: "some imported_from",
        name: "some name",
        notes: "some notes",
        occurred_at: ~U[2024-07-09 08:22:00Z],
        outcome: "interception_tn",
        outcome_actors: "some outcome_actors",
        people_dead: 42,
        people_missing: 42,
        phonenumber: "some phonenumber",
        place_of_departure: "some place_of_departure",
        place_of_disembarkation: "some place_of_disembarkation",
        pob_gender_ambiguous: 42,
        pob_medical_cases: 42,
        pob_men: 42,
        pob_minors: 42,
        pob_per_nationality: "some pob_per_nationality",
        pob_total: 42,
        pob_women: 42,
        sar_region: "some sar_region",
        status: "some status",
        template: "some template",
        time_of_departure: ~U[2024-07-09 08:22:00Z],
        time_of_disembarkation: ~U[2024-07-09 08:22:00Z],
        url: "some url"
      })
      |> CaseManager.ImportedCases.create_imported_case()

    imported_case
  end
end
