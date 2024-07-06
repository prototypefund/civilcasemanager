defmodule CaseManager.CasesTest do
  use CaseManager.DataCase

  alias CaseManager.Cases

  describe "cases" do
    alias CaseManager.Cases.Case

    import CaseManager.CasesFixtures

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

    test "list_cases/0 returns all cases" do
      case = case_fixture()
      assert Cases.list_cases() == [case]
    end

    test "get_case!/1 returns the case with given id" do
      case = case_fixture()
      assert Cases.get_case!(case.id) == case
    end

    test "create_case/1 with valid data creates a case" do
      valid_attrs = %{
        archived_at: ~U[2024-03-07 08:58:00Z],
        closed_at: ~U[2024-03-07 08:58:00Z],
        created_at: ~U[2024-03-07 08:58:00Z],
        deleted_at: ~U[2024-03-07 08:58:00Z],
        description: "some description",
        identifier: "some identifier",
        is_archived: true,
        opened_at: ~U[2024-03-07 08:58:00Z],
        status: "some status",
        status_note: "some status_note",
        title: "some title",
        updated_at: ~U[2024-03-07 08:58:00Z]
      }

      assert {:ok, %Case{} = case} = Cases.create_case(valid_attrs)
      assert case.archived_at == ~U[2024-03-07 08:58:00Z]
      assert case.closed_at == ~U[2024-03-07 08:58:00Z]
      assert case.created_at == ~U[2024-03-07 08:58:00Z]
      assert case.deleted_at == ~U[2024-03-07 08:58:00Z]
      assert case.description == "some description"
      assert case.identifier == "some identifier"
      assert case.is_archived == true
      assert case.opened_at == ~U[2024-03-07 08:58:00Z]
      assert case.status == "some status"
      assert case.status_note == "some status_note"
      assert case.title == "some title"
      assert case.updated_at == ~U[2024-03-07 08:58:00Z]
    end

    test "create_case/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Cases.create_case(@invalid_attrs)
    end

    test "update_case/2 with valid data updates the case" do
      case = case_fixture()

      update_attrs = %{
        archived_at: ~U[2024-03-08 08:58:00Z],
        closed_at: ~U[2024-03-08 08:58:00Z],
        created_at: ~U[2024-03-08 08:58:00Z],
        deleted_at: ~U[2024-03-08 08:58:00Z],
        description: "some updated description",
        identifier: "some updated identifier",
        is_archived: false,
        opened_at: ~U[2024-03-08 08:58:00Z],
        status: "some updated status",
        status_note: "some updated status_note",
        title: "some updated title",
        updated_at: ~U[2024-03-08 08:58:00Z]
      }

      assert {:ok, %Case{} = case} = Cases.update_case(case, update_attrs)
      assert case.archived_at == ~U[2024-03-08 08:58:00Z]
      assert case.closed_at == ~U[2024-03-08 08:58:00Z]
      assert case.created_at == ~U[2024-03-08 08:58:00Z]
      assert case.deleted_at == ~U[2024-03-08 08:58:00Z]
      assert case.description == "some updated description"
      assert case.identifier == "some updated identifier"
      assert case.is_archived == false
      assert case.opened_at == ~U[2024-03-08 08:58:00Z]
      assert case.status == "some updated status"
      assert case.status_note == "some updated status_note"
      assert case.title == "some updated title"
      assert case.updated_at == ~U[2024-03-08 08:58:00Z]
    end

    test "update_case/2 with invalid data returns error changeset" do
      case = case_fixture()
      assert {:error, %Ecto.Changeset{}} = Cases.update_case(case, @invalid_attrs)
      assert case == Cases.get_case!(case.id)
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
  end
end
