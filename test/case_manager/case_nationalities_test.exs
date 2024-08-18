defmodule CaseManager.CaseNationalitiesTest do
  use CaseManager.DataCase

  alias CaseManager.CaseNationalities
  alias CaseManager.CaseNationalities.CaseNationality

  describe "case_nationalities" do
    import CaseManager.CaseNationalitiesFixtures

    @invalid_attrs %{count: nil, country: nil, case_id: nil}

    test "list_case_nationalities/0 returns all case_nationalities" do
      case_nationality = case_nationality_fixture()
      assert CaseNationalities.list_case_nationalities() == [case_nationality]
    end

    test "get_case_nationality!/2 returns the case_nationality with given country and case_id" do
      case_nationality = case_nationality_fixture()

      assert CaseNationalities.get_case_nationality!(
               case_nationality.case_id,
               case_nationality.country
             ) == case_nationality
    end

    test "create_case_nationality/1 with valid data creates a case_nationality" do
      valid_case = CaseManager.CasesFixtures.case_fixture()
      valid_attrs = %{count: 42, country: "TU", case_id: valid_case.id}

      assert {:ok, %CaseNationality{} = case_nationality} =
               CaseNationalities.create_case_nationality(valid_attrs)

      assert case_nationality.count == 42
      assert case_nationality.country == "TU"
    end

    test "create_case_nationality/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} =
               CaseNationalities.create_case_nationality(@invalid_attrs)
    end

    test "update_case_nationality/2 with valid data updates the case_nationality" do
      case_nationality = case_nationality_fixture()
      update_attrs = %{count: 43, country: "MX"}

      assert {:ok, %CaseNationality{} = case_nationality} =
               CaseNationalities.update_case_nationality(case_nationality, update_attrs)

      assert case_nationality.count == 43
      assert case_nationality.country == "MX"
    end

    test "update_case_nationality/2 with invalid data returns error changeset" do
      case_nationality = case_nationality_fixture()

      assert {:error, %Ecto.Changeset{}} =
               CaseNationalities.update_case_nationality(case_nationality, @invalid_attrs)

      assert case_nationality ==
               CaseNationalities.get_case_nationality!(
                 case_nationality.case_id,
                 case_nationality.country
               )
    end

    test "delete_case_nationality/1 deletes the case_nationality" do
      case_nationality = case_nationality_fixture()

      assert {:ok, %CaseNationality{}} =
               CaseNationalities.delete_case_nationality(case_nationality)

      assert_raise Ecto.NoResultsError, fn ->
        CaseNationalities.get_case_nationality!(
          case_nationality.country,
          case_nationality.case_id
        )
      end
    end

    test "change_case_nationality/1 returns a case_nationality changeset" do
      case_nationality = case_nationality_fixture()
      assert %Ecto.Changeset{} = CaseNationalities.change_case_nationality(case_nationality)
    end
  end

  describe "split_nationalities/1" do
    test "returns empty list for nil input" do
      assert {:ok, []} = CaseNationalities.split_nationalities(nil)
    end

    test "returns empty list for empty string input" do
      assert {:ok, []} = CaseNationalities.split_nationalities("")
    end

    test "parses single nationality correctly" do
      assert {:ok, [%CaseNationality{country: "US", count: 5}]} =
               CaseNationalities.split_nationalities("US:5")
    end

    test "parses multiple nationalities correctly" do
      input = "US:5;GB:3;FR:2"

      expected = [
        %CaseNationality{country: "US", count: 5},
        %CaseNationality{country: "GB", count: 3},
        %CaseNationality{country: "FR", count: 2}
      ]

      assert {:ok, ^expected} = CaseNationalities.split_nationalities(input)
    end

    test "handles unknown count correctly" do
      assert {:ok, [%CaseNationality{country: "US", count: nil}]} =
               CaseNationalities.split_nationalities("US:unknown")
    end

    test "handles null count correctly" do
      assert {:ok, [%CaseNationality{country: "US", count: nil}]} =
               CaseNationalities.split_nationalities("US:-")
    end

    test "returns error for invalid country code" do
      assert {:error, "Invalid format: USA:5"} = CaseNationalities.split_nationalities("USA:5")
    end

    test "returns error for invalid count" do
      assert {:error, "Cannot parse abc into a number."} =
               CaseNationalities.split_nationalities("US:abc")
    end

    test "returns error for first invalid entry in multiple nationalities" do
      assert {:error, "Invalid format: USA:5"} =
               CaseNationalities.split_nationalities("USA:5;GB:3,FR:2")
    end

    test "returns error for non-first invalid entry in multiple nationalities" do
      assert {:error, "Invalid format: USA:5"} =
               CaseNationalities.split_nationalities("GB:3;USA:5;FR:2")
    end

    test "handles missing count correctly" do
      input = "GB:;US:"

      expected = [
        %CaseNationality{country: "GB", count: nil},
        %CaseNationality{country: "US", count: nil}
      ]

      assert {:ok, ^expected} = CaseNationalities.split_nationalities(input)
    end
  end
end
