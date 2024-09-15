defmodule CaseManagerWeb.ImportedCaseLive.ValidateTest do
  use CaseManagerWeb.ConnCase

  import Phoenix.LiveViewTest
  alias CaseManager.ImportedCases

  import CaseManagerWeb.LoginUtils

  import CaseManager.ImportedCasesFixtures

  def create_imported_case(_a) do
    imported_case = imported_case_fixture()
    {:ok, %{imported_case: imported_case}}
  end

  describe "Validate" do
    setup [:create_imported_case, :login]

    test "displays imported case details", %{conn: conn, imported_case: imported_case} do
      {:ok, view, html} = live(conn, ~p"/imported_cases/#{imported_case.id}/validate")
      assert render(view) =~ "Validate Row #{imported_case.row}"
      assert html =~ imported_case.notes
    end

    test "navigates to next case", %{conn: conn, imported_case: imported_case} do
      next_case = imported_case_fixture()
      {:ok, view, _html} = live(conn, ~p"/imported_cases/#{imported_case.id}/validate")

      assert view
             |> form("#case-form", %{})
             |> render_submit()

      assert_redirect(
        view,
        ~p"/imported_cases/#{next_case.id}/validate#imported_case-modal-content"
      )
    end

    test "deletes imported case", %{conn: conn, imported_case: imported_case} do
      {:ok, view, _html} = live(conn, ~p"/imported_cases/#{imported_case.id}/validate")
      assert view |> element("a", "Delete") |> render_click()
      assert_redirect(view, ~p"/imported_cases")

      assert_raise Ecto.NoResultsError, fn ->
        ImportedCases.get_imported_case!(imported_case.id)
      end
    end
  end
end
