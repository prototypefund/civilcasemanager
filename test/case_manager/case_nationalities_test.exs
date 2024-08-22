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
end
