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

      attrs = %{name: "AP0303-2001", notes: "Some notes"}

      assert view
             |> form("#case-form", case: attrs)
             |> render_submit() =~ "Case created successfully"

      assert_patch(view, ~p"/cases")

      assert Cases.get_case_by_identifier(attrs.name)
    end

    test "updates existing case", %{conn: conn} do
      case = case_fixture()
      {:ok, view, _html} = live(conn, ~p"/cases/#{case}/edit")

      attrs = %{name: "EB1001-2002", notes: "Updated notes"}

      view
      |> form("#case-form", case: attrs)
      |> render_submit()

      assert_redirected(view, ~p"/cases")

      updated_case = Cases.get_case!(case.id)
      assert updated_case.name == attrs.name
      assert updated_case.notes == attrs.notes
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

    test "renders imported case with occurred_at_string", %{conn: conn} do
      imported_case =
        imported_case_fixture(%{
          occurred_at_string: "occurred_at_string_content",
          time_of_departure_string: "time_of_departure_string_content",
          last_position: "last_position_content",
          time_of_disembarkation_string: "time_of_disembarkation_string_content",
          people_missing_string: "people_missing_string_content",
          first_position: "first_position_content",
          people_dead_string: "people_dead_string_content",
          pob_total_string: "pob_total_string_content",
          pob_minors_string: "pob_minors_string_content",
          boat_number_of_engines_string: "boat_number_of_engines_string_content",
          pob_men_string: "pob_men_string_content",
          pob_women_string: "pob_women_string_content",
          pob_gender_ambiguous_string: "pob_gender_ambiguous_string_content",
          followup_needed_string: "followup_needed_string_content"
        })

      {:ok, view, _html} = live(conn, ~p"/imported_cases/#{imported_case}/validate")

      assert view |> render() =~ "occurred_at_string_content"
      assert view |> render() =~ "time_of_departure_string_content"
      assert view |> render() =~ "last_position_content"
      assert view |> render() =~ "time_of_disembarkation_string_content"
      assert view |> render() =~ "people_missing_string_content"
      assert view |> render() =~ "first_position_content"
      assert view |> render() =~ "people_dead_string_content"
      assert view |> render() =~ "pob_total_string_content"
      assert view |> render() =~ "pob_minors_string_content"
      assert view |> render() =~ "boat_number_of_engines_string_content"
      assert view |> render() =~ "pob_men_string_content"
      assert view |> render() =~ "pob_women_string_content"
      assert view |> render() =~ "pob_gender_ambiguous_string_content"
      assert view |> render() =~ "followup_needed_string_content"
    end

    test "cannot save form with invalid data", %{conn: conn} do
      imported_case = imported_case_fixture()
      {:ok, view, _html} = live(conn, ~p"/imported_cases/#{imported_case}/validate")

      invalid_params = %{
        "case" => %{
          # Required field left empty
          "name" => "",
          # Invalid number format
          "pob_total" => "not a number"
        }
      }

      result =
        view
        |> form("#case-form", invalid_params)
        |> render_submit()

      assert result =~ "can&#39;t be blank"
      assert result =~ "is invalid"

      # Ensure the form wasn't saved
      assert view
             |> form("#case-form")
             |> render_change() =~ "can&#39;t be blank"
    end

    test "can set nullable enum and integer fields back to null", %{conn: conn} do
      case =
        case_fixture(%{
          boat_type: :rubber,
          boat_color: :blue,
          boat_engine_failure: :yes,
          sar_region: :sar1,
          outcome: :ngo_rescue,
          boat_number_of_engines: 2,
          pob_total: 50
        })

      {:ok, view, _html} = live(conn, ~p"/cases/#{case}/edit")

      params = %{
        "case" => %{
          "boat_type" => "unknown",
          "boat_color" => "unknown",
          "boat_engine_failure" => "unknown",
          "sar_region" => "unknown",
          "outcome" => "unknown",
          "boat_number_of_engines" => "",
          "pob_total" => ""
        }
      }

      view
      |> form("#case-form", params)
      |> render_submit()

      updated_case = CaseManager.Cases.get_case!(case.id)

      assert updated_case.boat_type == :unknown
      assert updated_case.boat_color == :unknown
      assert updated_case.boat_engine_failure == :unknown
      assert updated_case.sar_region == :unknown
      assert updated_case.outcome == :unknown
      assert updated_case.boat_number_of_engines == nil
      assert updated_case.pob_total == nil
    end
  end
end
