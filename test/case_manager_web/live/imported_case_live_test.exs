defmodule CaseManagerWeb.ImportedCaseLiveTest do
  use CaseManagerWeb.ConnCase

  import Phoenix.LiveViewTest
  import CaseManager.ImportedCasesFixtures

  import CaseManagerWeb.LoginUtils

  defp create_imported_case(_) do
    imported_case = imported_case_fixture()
    %{imported_case: imported_case}
  end

  describe "Anonymous user" do
    test "cannot list cases", %{conn: conn} do
      {:error, _} = live(conn, ~p"/imported_cases")
    end
  end

  describe "Readonly user" do
    setup [:create_imported_case, :login_readonly]

    test "can list all cases", %{conn: conn, imported_case: case} do
      {:ok, _index_live, html} = live(conn, ~p"/imported_cases")

      assert html =~ "Import Queue"
      assert html =~ case.name
    end

    test "cannot saves new case", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/imported_cases")

      refute has_element?(index_live, "a", "New Case")
    end

    test "cannot import cases", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/imported_cases")

      refute has_element?(index_live, "a", "Upload")
    end

    test "cannot clear queue", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/imported_cases")

      refute has_element?(index_live, "a", "Delete queue")
    end

    test "cannot delete case in listing", %{conn: conn, imported_case: case} do
      {:ok, index_live, _html} = live(conn, ~p"/imported_cases")

      refute has_element?(index_live, "#imported_cases-#{case.id} a", "Delete")
    end
  end

  describe "Index" do
    setup [:create_imported_case, :login]

    test "lists all imported_cases", %{conn: conn, imported_case: imported_case} do
      {:ok, _index_live, html} = live(conn, ~p"/imported_cases")

      assert html =~ "Import Queue"
      assert html =~ imported_case.status
    end

    test "deletes imported_case in listing", %{conn: conn, imported_case: imported_case} do
      {:ok, index_live, _html} = live(conn, ~p"/imported_cases")

      assert index_live
             |> element("#imported_cases-#{imported_case.id} a", "Delete")
             |> render_click()

      refute has_element?(index_live, "#imported_cases-#{imported_case.id}")
    end
  end

  describe "Upload" do
    setup [:login]

    test "renders upload form", %{conn: conn} do
      {:ok, view, html} = live(conn, ~p"/imported_cases/upload")

      assert html =~ "Case Importer"
      assert has_element?(view, "form")
      assert has_element?(view, "input[type=file]")
      assert has_element?(view, "button", "Upload")
    end

    test "uploads CSV file successfully", %{conn: conn} do
      {:ok, view, _html} = live(conn, ~p"/imported_cases/upload")

      file_input =
        file_input(view, "#upload-form", :avatar, [
          %{
            last_modified: 1_594_171_879_000,
            name: "test.csv",
            content: File.read!("test/support/fixtures/test.csv"),
            type: "text/csv"
          }
        ])

      render_upload(file_input, "test.csv")

      assert view
             |> element("#upload-form")
             |> render_submit() =~ "2 rows imported"
    end

    test "handles CSV file with errors", %{conn: conn} do
      {:ok, view, _html} = live(conn, ~p"/imported_cases/upload")

      file_input =
        file_input(view, "#upload-form", :avatar, [
          %{
            last_modified: 1_594_171_879_000,
            name: "test_with_errors.csv",
            content: File.read!("test/support/fixtures/test_with_errors.csv"),
            type: "text/csv"
          }
        ])

      render_upload(file_input, "test_with_errors.csv")

      assert view
             |> element("#upload-form")
             |> render_submit() =~ "No valid rows found"
    end
  end
end
