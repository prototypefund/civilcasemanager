defmodule CaseManager.CasesTest do
  use CaseManager.DataCase

  alias CaseManager.Cases
  alias CaseManager.ImportedCases

  describe "cases" do
    alias CaseManager.Cases.Case

    import CaseManager.CasesFixtures
    import CaseManager.ImportedCasesFixtures

    @invalid_attrs %{
      archived_at: nil,
      closed_at: nil,
      created_at: nil,
      deleted_at: nil,
      description: nil,
      identifier: nil,
      is_archived: nil,
      opened_at: nil,
      status: nil,
      status_note: nil,
      title: nil,
      updated_at: nil
    }

    @valid_attrs %{
      name: "TC0012",
      notes: "some notes",
      status: :open,
      occurred_at: ~U[2024-03-08 08:58:00Z],
      departure_region: "some departure_region",
      place_of_departure: "some place_of_departure",
      time_of_departure: ~U[2024-03-08 08:58:00Z],
      sar_region: :sar1,
      phonenumber: "some phonenumber",
      actors_involved: "some actors_involved",
      authorities_alerted: true,
      authorities_details: "some authorities_details",
      boat_type: :rubber,
      boat_notes: "some boat_notes",
      boat_color: :red,
      boat_engine_status: "some boat_engine_status",
      boat_engine_failure: "yes",
      boat_number_of_engines: 42,
      pob_total: 42,
      pob_men: 42,
      pob_women: 42,
      pob_minors: 42,
      pob_gender_ambiguous: 42,
      pob_medical_cases: 42,
      people_dead: 42,
      people_missing: 42,
      pob_per_nationality: "some pob_per_nationality",
      outcome: :interception_libya,
      time_of_disembarkation: ~U[2024-03-08 08:58:00Z],
      place_of_disembarkation: "Salerno",
      disembarked_by: "some disembarked_by",
      outcome_actors: "some outcome_actors",
      followup_needed: true,
      url: "some url"
    }

    test "list_cases/0 returns all cases" do
      case = case_fixture()
      assert Cases.list_cases() == [case]
    end

    test "get_case!/1 returns the case with given id" do
      case = case_fixture()
      assert Cases.get_case!(case.id, false) == case
    end

    test "create_case/1 with valid data creates a case" do
      assert {:ok, %Case{} = case} = Cases.create_case(@valid_attrs)
      assert case.name == "TC0012"
      assert case.notes == "some notes"
      assert case.status == :open
      assert case.occurred_at == ~U[2024-03-08 08:58:00Z]
      assert case.departure_region == "some departure_region"
      assert case.place_of_departure == "some place_of_departure"
      assert case.time_of_departure == ~U[2024-03-08 08:58:00Z]
      assert case.sar_region == :sar1
      assert case.phonenumber == "some phonenumber"
      assert case.actors_involved == "some actors_involved"
      assert case.authorities_alerted == true
      assert case.authorities_details == "some authorities_details"
      assert case.boat_type == :rubber
      assert case.boat_notes == "some boat_notes"
      assert case.boat_color == :red
      assert case.boat_engine_status == "some boat_engine_status"
      assert case.boat_engine_failure == :yes
      assert case.boat_number_of_engines == 42
      assert case.pob_total == 42
      assert case.pob_men == 42
      assert case.pob_women == 42
      assert case.pob_minors == 42
      assert case.pob_gender_ambiguous == 42
      assert case.pob_medical_cases == 42
      assert case.people_dead == 42
      assert case.people_missing == 42
      assert case.pob_per_nationality == "some pob_per_nationality"
      assert case.outcome == :interception_libya
      assert case.time_of_disembarkation == ~U[2024-03-08 08:58:00Z]
      assert case.place_of_disembarkation == "Salerno"
      assert case.disembarked_by == "some disembarked_by"
      assert case.outcome_actors == "some outcome_actors"
      assert case.followup_needed == true
      assert case.url == "some url"
    end

    test "create_case/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Cases.create_case(@invalid_attrs)
    end

    test "update_case/2 with valid data updates the case" do
      case = case_fixture()

      update_attrs = %{
        name: "DC0011",
        notes: "some updated notes",
        status: :closed,
        occurred_at: ~U[2024-03-08 08:58:00Z],
        departure_region: "Libya",
        place_of_departure: "some updated place_of_departure",
        time_of_departure: ~U[2024-03-08 08:58:00Z],
        sar_region: :sar1,
        phonenumber: "some updated phonenumber",
        actors_involved: "some updated actors_involved",
        authorities_alerted: true,
        authorities_details: "some updated authorities_details",
        boat_type: :rubber,
        boat_notes: "some updated boat_notes",
        boat_color: :red,
        boat_engine_status: "some updated boat_engine_status",
        boat_engine_failure: "no",
        boat_number_of_engines: 42,
        pob_total: 42,
        pob_men: 42,
        pob_women: 42,
        pob_minors: 42,
        pob_gender_ambiguous: 42,
        pob_medical_cases: 42,
        people_dead: 42,
        people_missing: 42,
        pob_per_nationality: "some updated pob_per_nationality",
        outcome: :interception_libya,
        time_of_disembarkation: ~U[2024-03-08 08:58:00Z],
        place_of_disembarkation: "Salento",
        disembarked_by: "some updated disembarked_by",
        outcome_actors: "some updated outcome_actors",
        followup_needed: true,
        url: "some updated url"
      }

      assert {:ok, %Case{} = case} = Cases.update_case(case, update_attrs)

      assert case.name == "DC0011"
      assert case.notes == "some updated notes"
      assert case.status == :closed
      assert case.occurred_at == ~U[2024-03-08 08:58:00Z]
      assert case.departure_region == "Libya"
      assert case.place_of_departure == "some updated place_of_departure"
      assert case.time_of_departure == ~U[2024-03-08 08:58:00Z]
      assert case.sar_region == :sar1
      assert case.phonenumber == "some updated phonenumber"
      assert case.actors_involved == "some updated actors_involved"
      assert case.authorities_alerted == true
      assert case.authorities_details == "some updated authorities_details"
      assert case.boat_type == :rubber
      assert case.boat_notes == "some updated boat_notes"
      assert case.boat_color == :red
      assert case.boat_engine_status == "some updated boat_engine_status"
      assert case.boat_engine_failure == :no
      assert case.boat_number_of_engines == 42
      assert case.pob_total == 42
      assert case.pob_men == 42
      assert case.pob_women == 42
      assert case.pob_minors == 42
      assert case.pob_gender_ambiguous == 42
      assert case.pob_medical_cases == 42
      assert case.people_dead == 42
      assert case.people_missing == 42
      assert case.pob_per_nationality == "some updated pob_per_nationality"
      assert case.outcome == :interception_libya
      assert case.time_of_disembarkation == ~U[2024-03-08 08:58:00Z]
      assert case.place_of_disembarkation == "Salento"
      assert case.disembarked_by == "some updated disembarked_by"
      assert case.outcome_actors == "some updated outcome_actors"
      assert case.followup_needed == true
      assert case.url == "some updated url"
    end

    test "update_case/2 with invalid data returns error changeset" do
      case = case_fixture()
      assert {:error, %Ecto.Changeset{}} = Cases.update_case(case, @invalid_attrs)
      assert case == Cases.get_case!(case.id, false)
    end

    test "delete_case/1 deletes the case" do
      case = case_fixture()
      assert {:ok, %Case{}} = Cases.delete_case(case)
      assert_raise Ecto.NoResultsError, fn -> Cases.get_case!(case.id) end
    end

    test "change_case/1 returns a case changeset" do
      case = case_fixture()
      assert %Ecto.Changeset{} = Cases.change_case(case)
    end

    test "create_case_and_delete_imported/2 creates a case and deletes the imported case" do
      imported = imported_case_fixture()

      assert {:ok, %{delete_imported_case: _, insert_case: _}} =
               Cases.create_case_and_delete_imported(@valid_attrs, imported)

      assert_raise Ecto.NoResultsError, fn -> ImportedCases.get_imported_case!(imported.id) end
    end

    test "create_case_and_delete_imported/2 fails if imported case is not in db" do
      imported = imported_case_fixture()

      assert {:ok, %{delete_imported_case: _, insert_case: _}} =
               Cases.create_case_and_delete_imported(@valid_attrs, imported)

      assert_raise Ecto.NoResultsError, fn -> ImportedCases.get_imported_case!(imported.id) end

      assert_raise Ecto.StaleEntryError, fn ->
        Cases.create_case_and_delete_imported(@valid_attrs, imported)
      end
    end

    test "get_year_from_id/1 extracts year from case identifier" do
      case_with_year = %Case{name: "EB123-2024"}
      case_without_year = %Case{name: "EB123"}

      assert Cases.get_year_from_id(case_with_year) == 2024
      assert Cases.get_year_from_id(case_without_year) == nil
    end

    test "get_year_from_occurred/1 extracts year from occurred_at field" do
      case_with_occurred = %Case{occurred_at: ~U[2023-01-01 00:00:00Z]}
      case_without_occurred = %Case{occurred_at: nil}

      assert Cases.get_year_from_occurred(case_with_occurred) == 2023
      assert Cases.get_year_from_occurred(case_without_occurred) == nil
    end

    test "get_year/1 returns year using different strategies" do
      case_with_id = %Case{name: "EB123-2024", occurred_at: ~U[2023-01-01 00:00:00Z]}
      case_with_occurred = %Case{name: "EB123", occurred_at: ~U[2023-01-01 00:00:00Z]}
      case_without_year = %Case{name: "EB123", occurred_at: nil}

      assert Cases.get_year(case_with_id) == 2024
      assert Cases.get_year(case_with_occurred) == 2023
      assert Cases.get_year(case_without_year) == nil
    end

    test "get_year_from_id/1 returns nil for multiple identifiers or slash" do
      case_with_multiple_ids = %Case{name: "EB123-2024/AB456-2025"}
      case_with_slash_ids = %Case{name: "EB123 - AB456 / 2025"}
      case_with_slash = %Case{name: "EB123/2024"}

      assert Cases.get_year_from_id(case_with_multiple_ids) == nil
      assert Cases.get_year_from_id(case_with_slash_ids) == nil
      assert Cases.get_year_from_id(case_with_slash) == nil
    end
  end
end
