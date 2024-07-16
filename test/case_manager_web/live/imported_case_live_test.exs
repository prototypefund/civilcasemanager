defmodule CaseManagerWeb.ImportedCaseLiveTest do
  use CaseManagerWeb.ConnCase

  import Phoenix.LiveViewTest
  import CaseManager.ImportedCasesFixtures

  import CaseManagerWeb.LoginUtils

  @create_attrs %{
    people_dead: 42,
    template: "some template",
    pob_per_nationality: "some pob_per_nationality",
    outcome_actors: "some outcome_actors",
    occurred_at: "2024-07-09T08:22:00Z",
    boat_engine_status: "some boat_engine_status",
    boat_engine_working: "some boat_engine_working",
    imported_from: "some imported_from",
    departure_region: "some departure_region",
    outcome: "some outcome",
    boat_number_of_engines: 42,
    pob_gender_ambiguous: 42,
    sar_region: "some sar_region",
    time_of_disembarkation: "2024-07-09T08:22:00Z",
    confirmation_by: "some confirmation_by",
    frontext_involvement: "some frontext_involvement",
    pob_total: 42,
    status: "some status",
    pob_medical_cases: 42,
    pob_men: 42,
    boat_notes: "some boat_notes",
    phonenumber: "some phonenumber",
    followup_needed: true,
    authorities_alerted: true,
    actors_involved: "some actors_involved",
    authorities_details: "some authorities_details",
    place_of_disembarkation: "some place_of_disembarkation",
    name: "some name",
    pob_minors: 42,
    boat_type: "some boat_type",
    place_of_departure: "some place_of_departure",
    time_of_departure: "2024-07-09T08:22:00Z",
    pob_women: 42,
    notes: "some notes",
    cloud_file_links: "some cloud_file_links",
    boat_color: "some boat_color",
    people_missing: 42,
    disembarked_by: "some disembarked_by",
    url: "some url",
    alarmphone_contact: "some alarmphone_contact"
  }

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
            content: File.read!("test/fixtures/test.csv"),
            type: "text/csv"
          }
        ])

      assert render_upload(file_input, "test.csv") =~ "100%"

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
            content: "header1,header2\nvalue1\nvalue3,value4,extra",
            type: "text/csv"
          }
        ])

      assert render_upload(file_input, "test_with_errors.csv") =~ "100%"

      assert view
             |> element("#upload-form")
             |> render_submit() =~ "1 row imported 1 row failed Failed rows: 2"
    end

    test "cancels upload", %{conn: conn} do
      {:ok, view, _html} = live(conn, ~p"/imported_cases/upload")

      file_input =
        file_input(view, "#upload-form", :avatar, [
          %{
            last_modified: 1_594_171_879_000,
            name: "test.csv",
            content: "header1,header2\nvalue1,value2",
            type: "text/csv"
          }
        ])

      assert render_upload(file_input, "test.csv") =~ "100%"

      assert view
             |> element("button", "Cancel")
             |> render_click()

      refute has_element?(view, "progress")
    end
  end
end
