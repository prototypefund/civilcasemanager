defmodule CaseManagerWeb.CaseFormTest do
  use CaseManagerWeb.ConnCase

  import Phoenix.LiveViewTest
  alias CaseManager.Cases
  alias CaseManager.ImportedCases
  import CaseManagerWeb.LoginUtils

  import CaseManager.CasesFixtures
  import CaseManager.ImportedCasesFixtures

  @endpoint CaseManagerWeb.Endpoint

  describe "CaseForm" do
    setup [:login]

    test "renders form for new case", %{conn: conn} do
      {:ok, view, _html} = live(conn, ~p"/cases/new")
      assert has_element?(view, "h1", "Base data")
      assert has_element?(view, "form#case-form")
    end

    test "renders form for editing existing case", %{conn: conn} do
      case = case_fixture()
      {:ok, view, _html} = live(conn, ~p"/cases/#{case}/edit")
      assert has_element?(view, "h1", "Base data")
      assert has_element?(view, "form#case-form")
    end

    test "validates form inputs", %{conn: conn} do
      {:ok, view, _html} = live(conn, ~p"/cases/new")

      view
      |> form("#case-form", case: %{name: ""})
      |> render_change()

      assert has_element?(view, "#case-form", "can't be blank")
    end

    test "saves new case", %{conn: conn} do
      {:ok, view, _html} = live(conn, ~p"/cases/new")

      attrs = %{name: "AP303", notes: "Some notes"}

      assert view
             |> form("#case-form", case: attrs)
             |> render_submit() =~ "Case created successfully"

      assert_patch(view, ~p"/cases")

      assert Cases.get_case_by_identifier("AP303")
    end

    test "updates existing case", %{conn: conn} do
      case = case_fixture()
      {:ok, view, _html} = live(conn, ~p"/cases/#{case}/edit")

      attrs = %{name: "Updated Case", notes: "Updated notes"}

      view
      |> form("#case-form", case: attrs)
      |> render_submit()

      assert_redirected(view, ~p"/cases")

      updated_case = Cases.get_case!(case.id)
      assert updated_case.name == "Updated Case"
      assert updated_case.notes == "Updated notes"
    end

    test "deletes imported case", %{conn: conn} do
      imported_case = imported_case_fixture()
      {:ok, view, _html} = live(conn, ~p"/imported_cases/#{imported_case}/validate")

      view
      |> element("a", "Delete row")
      |> render_click()

      assert_redirected(view, ~p"/imported_cases")

      assert_raise Ecto.NoResultsError, fn ->
        ImportedCases.get_imported_case!(imported_case.id)
      end
    end
  end
end
