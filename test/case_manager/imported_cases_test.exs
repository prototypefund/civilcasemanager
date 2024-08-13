defmodule CaseManager.ImportedCasesTest do
  use CaseManager.DataCase

  alias CaseManager.ImportedCases

  describe "imported_cases" do
    alias CaseManager.ImportedCases.ImportedCase

    import CaseManager.ImportedCasesFixtures

    @invalid_attrs %{
      people_dead: nil,
      template: nil,
      pob_per_nationality: nil,
      outcome_actors: nil,
      occurred_at: 3333,
      boat_engine_status: nil,
      boat_engine_failure: nil,
      imported_from: nil,
      departure_region: nil,
      outcome: nil,
      boat_number_of_engines: nil,
      pob_gender_ambiguous: nil,
      sar_region: nil,
      time_of_disembarkation: nil,
      pob_total: nil,
      status: nil,
      pob_medical_cases: nil,
      pob_men: nil,
      boat_notes: nil,
      phonenumber: nil,
      followup_needed: nil,
      authorities_alerted: nil,
      actors_involved: nil,
      authorities_details: nil,
      place_of_disembarkation: nil,
      name: nil,
      pob_minors: nil,
      boat_type: nil,
      place_of_departure: nil,
      time_of_departure: nil,
      pob_women: nil,
      notes: nil,
      boat_color: nil,
      people_missing: "eeee",
      disembarked_by: nil,
      url: nil
    }

    test "list_imported_cases/0 returns all imported_cases" do
      imported_case = imported_case_fixture()
      assert ImportedCases.list_imported_cases() == [imported_case]
    end

    test "get_imported_case!/1 returns the imported_case with given id" do
      imported_case = imported_case_fixture()
      assert ImportedCases.get_imported_case!(imported_case.id) == imported_case
    end

    test "create_imported_case/1 with valid data creates a imported_case" do
      valid_attrs = %{
        people_dead: 42,
        template: "some template",
        pob_per_nationality: "some pob_per_nationality",
        outcome_actors: "some outcome_actors",
        occurred_at: ~U[2024-07-09 08:22:00Z],
        boat_engine_status: "some boat_engine_status",
        boat_engine_failure: "yes",
        imported_from: "some imported_from",
        departure_region: "some departure_region",
        outcome: "interception_tn",
        boat_number_of_engines: 42,
        pob_gender_ambiguous: 42,
        sar_region: "some sar_region",
        time_of_disembarkation: ~U[2024-07-09 08:22:00Z],
        pob_total: 42,
        status: "some status",
        pob_medical_cases: 42,
        pob_men: 42,
        boat_notes: "some boat_notes",
        phonenumber: "some phonenumber",
        followup_needed: true,
        authorities_alerted: true,
        actors_involved: "some actors_involved",
        authorities_details: "some authorities_details",
        place_of_disembarkation: "Salerno",
        name: "some name",
        pob_minors: 42,
        boat_type: "some boat_type",
        place_of_departure: "some place_of_departure",
        time_of_departure: ~U[2024-07-09 08:22:00Z],
        pob_women: 42,
        notes: "some notes",
        boat_color: "some boat_color",
        people_missing: 42,
        disembarked_by: "some disembarked_by",
        url: "some url"
      }

      assert {:ok, %ImportedCase{} = imported_case} =
               ImportedCases.create_imported_case(valid_attrs)

      assert imported_case.url == "some url"
      assert imported_case.disembarked_by == "some disembarked_by"
      assert imported_case.people_missing == 42
      assert imported_case.boat_color == "some boat_color"
      assert imported_case.notes == "some notes"
      assert imported_case.pob_women == 42
      assert imported_case.time_of_departure == ~U[2024-07-09 08:22:00Z]
      assert imported_case.place_of_departure == "some place_of_departure"
      assert imported_case.boat_type == "some boat_type"
      assert imported_case.pob_minors == 42
      assert imported_case.name == "some name"
      assert imported_case.place_of_disembarkation == "Salerno"
      assert imported_case.authorities_details == "some authorities_details"
      assert imported_case.actors_involved == "some actors_involved"
      assert imported_case.authorities_alerted == true
      assert imported_case.followup_needed == true
      assert imported_case.phonenumber == "some phonenumber"
      assert imported_case.boat_notes == "some boat_notes"
      assert imported_case.pob_men == 42
      assert imported_case.pob_medical_cases == 42
      assert imported_case.status == "some status"
      assert imported_case.pob_total == 42
      assert imported_case.time_of_disembarkation == ~U[2024-07-09 08:22:00Z]
      assert imported_case.sar_region == "some sar_region"
      assert imported_case.pob_gender_ambiguous == 42
      assert imported_case.boat_number_of_engines == 42
      assert imported_case.outcome == "interception_tn"
      assert imported_case.departure_region == "some departure_region"
      assert imported_case.imported_from == "some imported_from"
      assert imported_case.boat_engine_failure == "yes"
      assert imported_case.boat_engine_status == "some boat_engine_status"
      assert imported_case.occurred_at == ~U[2024-07-09 08:22:00Z]
      assert imported_case.outcome_actors == "some outcome_actors"
      assert imported_case.pob_per_nationality == "some pob_per_nationality"
      assert imported_case.people_dead == 42
    end

    test "create_imported_case/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = ImportedCases.create_imported_case(@invalid_attrs)
    end

    test "update_imported_case/2 with valid data updates the imported_case" do
      imported_case = imported_case_fixture()

      update_attrs = %{
        people_dead: 43,
        template: "some updated template",
        pob_per_nationality: "some updated pob_per_nationality",
        outcome_actors: "some updated outcome_actors",
        occurred_at: ~U[2024-07-10 08:22:00Z],
        boat_engine_status: "some updated boat_engine_status",
        boat_engine_failure: "no",
        imported_from: "some updated imported_from",
        departure_region: "Tunisia",
        outcome: "some updated outcome",
        boat_number_of_engines: 43,
        pob_gender_ambiguous: 43,
        sar_region: "some updated sar_region",
        time_of_disembarkation: ~U[2024-07-10 08:22:00Z],
        pob_total: 43,
        status: "some updated status",
        pob_medical_cases: 43,
        pob_men: 43,
        boat_notes: "some updated boat_notes",
        phonenumber: "some updated phonenumber",
        followup_needed: false,
        authorities_alerted: false,
        actors_involved: "some updated actors_involved",
        authorities_details: "some updated authorities_details",
        place_of_disembarkation: "some updated place_of_disembarkation",
        name: "some updated name",
        pob_minors: 43,
        boat_type: "some updated boat_type",
        place_of_departure: "some updated place_of_departure",
        time_of_departure: ~U[2024-07-10 08:22:00Z],
        pob_women: 43,
        notes: "some updated notes",
        boat_color: "some updated boat_color",
        people_missing: 43,
        disembarked_by: "some updated disembarked_by",
        url: "some updated url",
        alarmphone_contact: "some updated alarmphone_contact"
      }

      assert {:ok, %ImportedCase{} = imported_case} =
               ImportedCases.update_imported_case(imported_case, update_attrs)

      assert imported_case.alarmphone_contact == "some updated alarmphone_contact"
      assert imported_case.url == "some updated url"
      assert imported_case.disembarked_by == "some updated disembarked_by"
      assert imported_case.people_missing == 43
      assert imported_case.boat_color == "some updated boat_color"
      assert imported_case.notes == "some updated notes"
      assert imported_case.pob_women == 43
      assert imported_case.time_of_departure == ~U[2024-07-10 08:22:00Z]
      assert imported_case.place_of_departure == "some updated place_of_departure"
      assert imported_case.boat_type == "some updated boat_type"
      assert imported_case.pob_minors == 43
      assert imported_case.name == "some updated name"
      assert imported_case.place_of_disembarkation == "some updated place_of_disembarkation"
      assert imported_case.authorities_details == "some updated authorities_details"
      assert imported_case.actors_involved == "some updated actors_involved"
      assert imported_case.authorities_alerted == false
      assert imported_case.followup_needed == false
      assert imported_case.phonenumber == "some updated phonenumber"
      assert imported_case.boat_notes == "some updated boat_notes"
      assert imported_case.pob_men == 43
      assert imported_case.pob_medical_cases == 43
      assert imported_case.status == "some updated status"
      assert imported_case.pob_total == 43
      assert imported_case.time_of_disembarkation == ~U[2024-07-10 08:22:00Z]
      assert imported_case.sar_region == "some updated sar_region"
      assert imported_case.pob_gender_ambiguous == 43
      assert imported_case.boat_number_of_engines == 43
      assert imported_case.outcome == "some updated outcome"
      assert imported_case.departure_region == "Tunisia"
      assert imported_case.imported_from == "some updated imported_from"
      assert imported_case.boat_engine_failure == "no"
      assert imported_case.boat_engine_status == "some updated boat_engine_status"
      assert imported_case.occurred_at == ~U[2024-07-10 08:22:00Z]
      assert imported_case.outcome_actors == "some updated outcome_actors"
      assert imported_case.pob_per_nationality == "some updated pob_per_nationality"
      assert imported_case.template == "some updated template"
      assert imported_case.people_dead == 43
    end

    test "update_imported_case/2 with invalid data returns error changeset" do
      imported_case = imported_case_fixture()

      assert {:error, %Ecto.Changeset{}} =
               ImportedCases.update_imported_case(imported_case, @invalid_attrs)

      assert imported_case == ImportedCases.get_imported_case!(imported_case.id)
    end

    test "delete_imported_case/1 deletes the imported_case" do
      imported_case = imported_case_fixture()
      assert {:ok, %ImportedCase{}} = ImportedCases.delete_imported_case(imported_case)

      assert_raise Ecto.NoResultsError, fn ->
        ImportedCases.get_imported_case!(imported_case.id)
      end
    end

    test "change_imported_case/1 returns a imported_case changeset" do
      imported_case = imported_case_fixture()
      assert %Ecto.Changeset{} = ImportedCases.change_imported_case(imported_case)
    end
  end
end
