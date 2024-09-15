defmodule CaseManager.DataQualityToolsTest do
  use CaseManager.DataCase

  import CaseManager.DataQualityTools
  alias CaseManager.CaseNationalities.CaseNationality
  import CaseManager.CasesFixtures
  import CaseManager.PlacesFixtures

  describe "split_nationalities/1" do
    test "returns empty list for nil input" do
      assert {:ok, []} = split_nationalities(nil)
    end

    test "returns empty list for empty string input" do
      assert {:ok, []} = split_nationalities("")
    end

    test "parses single nationality correctly" do
      assert {:ok, [%CaseNationality{country: "US", count: 5}]} =
               split_nationalities("US:5")
    end

    test "parses multiple nationalities correctly" do
      input = "US:5;GB:3;FR:2"

      expected = [
        %CaseNationality{country: "US", count: 5},
        %CaseNationality{country: "GB", count: 3},
        %CaseNationality{country: "FR", count: 2}
      ]

      assert {:ok, ^expected} = split_nationalities(input)
    end

    test "handles unknown count correctly" do
      assert {:ok, [%CaseNationality{country: "US", count: nil}]} =
               split_nationalities("US:unknown")
    end

    test "handles null count correctly" do
      assert {:ok, [%CaseNationality{country: "US", count: nil}]} =
               split_nationalities("US:-")
    end

    test "returns error for invalid country code" do
      assert {:error, "Invalid format: USA:5"} = split_nationalities("USA:5")
    end

    test "returns error for invalid count" do
      assert {:error, "Cannot parse abc into a number."} =
               split_nationalities("US:abc")
    end

    test "returns error for first invalid entry in multiple nationalities" do
      assert {:error, "Invalid format: USA:5"} =
               split_nationalities("USA:5;GB:3,FR:2")
    end

    test "returns error for non-first invalid entry in multiple nationalities" do
      assert {:error, "Invalid format: USA:5"} =
               split_nationalities("GB:3;USA:5;FR:2")
    end

    test "handles missing count correctly" do
      input = "GB:;US:"

      expected = [
        %CaseNationality{country: "GB", count: nil},
        %CaseNationality{country: "US", count: nil}
      ]

      assert {:ok, ^expected} = split_nationalities(input)
    end

    test "fixup_nationality_strings updates case nationalities" do
      case = case_fixture(%{pob_per_nationality: "US:10;UK:5"})

      CaseManager.DataQualityTools.fixup_nationality_strings(case.id)

      updated_case = CaseManager.Repo.get!(CaseManager.Cases.Case, case.id)
      assert updated_case.pob_per_nationality == nil

      nationalities = CaseManager.Repo.all(CaseManager.CaseNationalities.CaseNationality)
      assert length(nationalities) == 2
      assert Enum.any?(nationalities, fn n -> n.country == "US" and n.count == 10 end)
      assert Enum.any?(nationalities, fn n -> n.country == "UK" and n.count == 5 end)
    end

    test "fixup_departure_regions updates case departure regions" do
      case = case_fixture(%{place_of_departure: "Tunesia", departure_region: nil})

      CaseManager.DataQualityTools.fixup_departure_regions(case.id)

      updated_case = CaseManager.Repo.get!(CaseManager.Cases.Case, case.id)
      assert updated_case.departure_region == "Tunisia"
      assert updated_case.place_of_departure == nil
    end

    test "clear_unknown_places removes unknown place values" do
      case1 = case_fixture(%{place_of_disembarkation: "unknown"})
      case2 = case_fixture(%{place_of_departure: "permanently unknown"})

      CaseManager.DataQualityTools.clear_unknown_places()

      updated_case1 = CaseManager.Repo.get!(CaseManager.Cases.Case, case1.id)
      updated_case2 = CaseManager.Repo.get!(CaseManager.Cases.Case, case2.id)
      assert updated_case1.place_of_disembarkation == nil
      assert updated_case2.place_of_departure == nil
    end

    test "migrate_places updates place references" do
      place1 = place_fixture(%{name: "Tripoli"})
      place2 = place_fixture(%{name: "Lampedusa"})
      case1 = case_fixture(%{place_of_departure: "Tripoli", place_of_disembarkation: "Lampedusa"})
      case2 = case_fixture(%{place_of_departure: "Tipoli", place_of_disembarkation: "LMP"})

      CaseManager.DataQualityTools.migrate_places()

      updated_case1 = CaseManager.Repo.get!(CaseManager.Cases.Case, case1.id)
      updated_case2 = CaseManager.Repo.get!(CaseManager.Cases.Case, case2.id)

      assert updated_case1.departure_id == place1.id
      assert updated_case1.arrival_id == place2.id
      assert updated_case1.place_of_departure == nil
      assert updated_case1.place_of_disembarkation == nil

      assert updated_case2.departure_id == place1.id
      assert updated_case2.arrival_id == place2.id
      assert updated_case2.place_of_departure == nil
      assert updated_case2.place_of_disembarkation == nil
    end
  end
end
