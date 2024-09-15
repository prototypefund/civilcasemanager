defmodule CaseManager.DeletedCasesTest do
  use CaseManager.DataCase

  alias CaseManager.DeletedCases

  describe "deleted_cases" do
    alias CaseManager.DeletedCases.DeletedCase

    import CaseManager.DeletedCasesFixtures

    test "list_deleted_cases/0 returns all deleted_cases" do
      deleted_case = deleted_case_fixture()
      assert DeletedCases.list_deleted_cases() == [deleted_case]
    end

    test "get_deleted_case!/1 returns the deleted_case with given id" do
      deleted_case = deleted_case_fixture()
      assert DeletedCases.get_deleted_case!(deleted_case.id) == deleted_case
    end

    test "create_deleted_case/1 with valid data creates a deleted_case" do
      valid_attrs = %{id: "S234234"}

      assert {:ok, %DeletedCase{} = deleted_case} = DeletedCases.create_deleted_case(valid_attrs)
      assert deleted_case.id == valid_attrs.id
    end

    test "update_deleted_case/2 with valid data updates the deleted_case" do
      deleted_case = deleted_case_fixture()
      update_attrs = %{id: "09809"}

      assert {:ok, %DeletedCase{} = deleted_case} =
               DeletedCases.update_deleted_case(deleted_case, update_attrs)

      assert deleted_case.id == update_attrs.id
    end

    test "create_deleted_case/1 without args returns error" do
      assert {:error, _error} = DeletedCases.create_deleted_case()
    end

    test "delete_deleted_case/1 deletes the deleted_case" do
      deleted_case = deleted_case_fixture()
      assert {:ok, %DeletedCase{}} = DeletedCases.delete_deleted_case(deleted_case)
      assert_raise Ecto.NoResultsError, fn -> DeletedCases.get_deleted_case!(deleted_case.id) end
    end

    test "change_deleted_case/1 returns a deleted_case changeset" do
      deleted_case = deleted_case_fixture()
      assert %Ecto.Changeset{} = DeletedCases.change_deleted_case(deleted_case)
    end
  end
end
