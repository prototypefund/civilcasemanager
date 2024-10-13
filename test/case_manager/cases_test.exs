defmodule CaseManager.CasesTest do
  use CaseManager.DataCase

  alias CaseManager.Cases
  alias CaseManager.Positions
  alias CaseManager.ImportedCases
  alias CaseManager.CaseNationalities
  alias CaseManager.Cases.Case
  alias CaseManager.DeletedCases.DeletedCase
  import CaseManager.CasesFixtures
  import CaseManager.PositionsFixtures
  import CaseManager.ImportedCasesFixtures
  import CaseManager.CaseNationalitiesFixtures

  describe "cases" do
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
      name: "DC0011-2023",
      notes: "some notes",
      status: :open,
      occurred_at: ~U[2024-03-08 08:58:00Z],
      departure_region: "some departure_region",
      place_of_departure: "some place_of_departure",
      time_of_departure: ~U[2024-03-08 08:58:00Z],
      sar_region: :sar1,
      phonenumber: "some phonenumber",
      actors_involved: "some actors_involved",
      authorities_alerted: "MC ROME",
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
      assert case.name == "DC0011-2023"
      assert case.notes == "some notes"
      assert case.status == :open
      assert case.occurred_at == ~U[2024-03-08 08:58:00Z]
      assert case.departure_region == "some departure_region"
      assert case.place_of_departure == "some place_of_departure"
      assert case.time_of_departure == ~U[2024-03-08 08:58:00Z]
      assert case.sar_region == :sar1
      assert case.phonenumber == "some phonenumber"
      assert case.actors_involved == "some actors_involved"
      assert case.authorities_alerted == "MC ROME"
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

    test "create_case/1 with no data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Cases.create_case()
    end

    test "update_case/2 with valid data updates the case" do
      case = case_fixture()

      update_attrs = %{
        name: "DC0011-2022",
        notes: "some updated notes",
        status: :closed,
        occurred_at: ~U[2024-03-08 08:58:00Z],
        departure_region: "Libya",
        place_of_departure: "some updated place_of_departure",
        time_of_departure: ~U[2024-03-08 08:58:00Z],
        sar_region: :sar1,
        phonenumber: "some updated phonenumber",
        actors_involved: "some updated actors_involved",
        authorities_alerted: "MC MALTA",
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

      assert case.name == "DC0011-2022"
      assert case.notes == "some updated notes"
      assert case.status == :closed
      assert case.occurred_at == ~U[2024-03-08 08:58:00Z]
      assert case.departure_region == "Libya"
      assert case.place_of_departure == "some updated place_of_departure"
      assert case.time_of_departure == ~U[2024-03-08 08:58:00Z]
      assert case.sar_region == :sar1
      assert case.phonenumber == "some updated phonenumber"
      assert case.actors_involved == "some updated actors_involved"
      assert case.authorities_alerted == "MC MALTA"
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

    test "delete_case/1 creates an entry in deleted_cases" do
      case = case_fixture()
      {:ok, %Case{}} = Cases.delete_case(case)

      deleted_case = Repo.get!(DeletedCase, case.id)
      assert deleted_case != nil
      assert deleted_case.id == case.id
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

    test "delete_case/1 deletes a case with positions" do
      case_with_positions = case_fixture()
      position_fixture(%{item_id: case_with_positions.id})

      case = Cases.get_case!(case_with_positions.id)
      assert Repo.preload(case, :positions).positions != []

      assert {:ok, %Case{}} = Cases.delete_case(case_with_positions)
      assert_raise Ecto.NoResultsError, fn -> Cases.get_case!(case_with_positions.id) end

      assert_raise Ecto.NoResultsError, fn ->
        Repo.get_by!(Positions.Position, item_id: case_with_positions.id)
      end
    end

    test "get_cases/1 returns cases based on provided IDs" do
      case1 = case_fixture()
      case2 = case_fixture()
      case3 = case_fixture()

      cases = Cases.get_cases([case1.id, case2.id])
      assert length(cases) == 2
      assert Enum.map(cases, & &1.id) == [case1.id, case2.id]

      cases = Cases.get_cases([case1.id, case2.id, case3.id])
      assert length(cases) == 3

      assert Enum.map(cases, & &1.id) |> Enum.sort() ==
               [case1.id, case2.id, case3.id] |> Enum.sort()
    end

    test "list_positions_for_case/1 returns positions for a given case identifier" do
      case = case_fixture()

      position1 =
        position_fixture(%{
          item_id: case.id,
          lat: 10.0,
          lon: 20.0,
          timestamp: ~N[2023-01-01 10:00:00]
        })

      position2 =
        position_fixture(%{
          item_id: case.id,
          lat: 30.0,
          lon: 40.0,
          timestamp: ~N[2023-01-02 14:30:00]
        })

      positions = Cases.list_positions_for_case(case.id)
      assert length(positions) == 2

      assert Enum.map(positions, & &1.id) |> Enum.sort() ==
               [position1.id, position2.id] |> Enum.sort()

      assert Enum.all?(positions, &(&1.short_code != nil))
    end

    test "list_cases/1 returns cases using Flop" do
      case_fixture(%{name: "DC0001-2022"})
      case_fixture(%{name: "DC0002-2022"})
      case_fixture(%{name: "AP0003-2022"})

      params = %{filters: [%{field: :name, op: :=~, value: "DC"}], order_by: [:name], limit: 2}
      {:ok, {cases, _meta}} = Cases.list_cases(params)

      assert length(cases) == 2
      assert Enum.map(cases, & &1.name) == ["DC0001-2022", "DC0002-2022"]

      params = %{filters: [%{field: :name, op: :=~, value: "Non-existent"}]}
      {:ok, {cases, _meta}} = Cases.list_cases(params)

      assert cases == []
    end

    test "list_cases/1 with invalid params returns error tuple" do
      case_fixture(%{name: "DC0001-2022"})
      case_fixture(%{name: "DC0002-2022"})
      case_fixture(%{name: "AP0003-2022"})

      invalid_params = %{filters: [%{field: :invalid_field, op: :=, value: "Some Value"}]}
      {:error, _changeset} = Cases.list_cases(invalid_params)
    end

    test "can delete case with case_nationalities, positions etc..." do
      case = case_fixture()

      case_nationality =
        case_nationality_fixture(%{case_id: case.id})

      position =
        position_fixture(%{
          item_id: case.id,
          lat: 10.0,
          lon: 20.0,
          timestamp: ~N[2023-01-01 10:00:00]
        })

      assert {:ok, deleted_case} = Cases.delete_case(case)
      assert deleted_case.id == case.id

      assert_raise Ecto.NoResultsError, fn -> Cases.get_case!(case.id) end

      assert_raise Ecto.NoResultsError, fn ->
        CaseNationalities.get_case_nationality!(case.id, case_nationality.country)
      end

      assert_raise Ecto.NoResultsError, fn -> Positions.get_position!(position.id) end
    end

    test "cannot set duplicate names" do
      case_fixture(%{name: "DC0001-2022"})
      {:error, changeset} = Cases.create_case(%{name: "DC0001-2022", status: :closed})
      assert "has already been taken" in errors_on(changeset).name
    end

    test "cannot set invalid names" do
      {:error, changeset} = Cases.create_case(%{name: "Invalid Name"})
      assert errors_on(changeset).name != []

      {:error, changeset} = Cases.create_case(%{name: ""})
      assert "can't be blank" in errors_on(changeset).name
    end

    test "multiple valid ids separated by / are permitted" do
      {:ok, case1} = Cases.create_case(%{name: "DC0001-2002 / AP0002-2022", status: :closed})
      assert case1.name == "DC0001-2002 / AP0002-2022"

      {:error, changeset} = Cases.create_case(%{name: "Invalid/Name-2022"})
      assert errors_on(changeset).name != []
    end

    test "date validation checks for dates before 2020" do
      {:error, changeset} =
        Cases.create_case(%{name: "DC0001-2022", occurred_at: ~U[2019-12-31 23:59:59Z]})

      assert "Date must be after 2020" in errors_on(changeset).occurred_at
    end

    test "date validation checks for dates too far in the future" do
      future_date = Date.add(Date.utc_today(), 31) |> DateTime.new!(~T[00:00:00], "Etc/UTC")
      {:error, changeset} = Cases.create_case(%{name: "DC0001-2022", occurred_at: future_date})
      assert "Date is in the future" in errors_on(changeset).occurred_at
    end

    test "date validation checks for valid dates" do
      valid_date = DateTime.utc_now() |> DateTime.add(-1, :day)

      {:ok, _case} =
        Cases.create_case(%{name: "DC0001-2022", occurred_at: valid_date, status: :open})
    end

    test "date validation checks for date difference validation" do
      base_date = ~U[2023-01-01 12:00:00Z]

      {:error, changeset} =
        Cases.create_case(%{
          name: "DC0001-2022",
          occurred_at: base_date,
          alerted_at: DateTime.add(base_date, 31, :day),
          status: "open"
        })

      assert "Date cannot be more than 30 days apart from alerted_at" in errors_on(changeset).occurred_at
    end

    test "date validation checks for multiple valid date fields" do
      base_date = ~U[2023-01-01 12:00:00Z]

      {:ok, _case} =
        Cases.create_case(%{
          name: "DC0001-2022",
          occurred_at: base_date,
          alerted_at: DateTime.add(base_date, 1, :day),
          time_of_departure: DateTime.add(base_date, 2, :day),
          time_of_disembarkation: DateTime.add(base_date, 3, :day),
          status: "open"
        })
    end

    test "date validation checks for one invalid date among multiple date fields" do
      base_date = ~U[2023-01-01 12:00:00Z]

      {:error, changeset} =
        Cases.create_case(%{
          name: "DC0001-2022",
          occurred_at: base_date,
          alerted_at: DateTime.add(base_date, 1, :day),
          time_of_departure: DateTime.add(base_date, 2, :day),
          time_of_disembarkation: DateTime.add(base_date, 35, :day),
          status: "open"
        })

      assert "Date cannot be more than 30 days apart from occurred_at" in errors_on(changeset).time_of_disembarkation
    end
  end
end
