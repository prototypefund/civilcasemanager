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
  @update_attrs %{
    people_dead: 43,
    template: "some updated template",
    pob_per_nationality: "some updated pob_per_nationality",
    outcome_actors: "some updated outcome_actors",
    occurred_at: "2024-07-10T08:22:00Z",
    boat_engine_status: "some updated boat_engine_status",
    boat_engine_working: "some updated boat_engine_working",
    imported_from: "some updated imported_from",
    departure_region: "some updated departure_region",
    outcome: "some updated outcome",
    boat_number_of_engines: 43,
    pob_gender_ambiguous: 43,
    sar_region: "some updated sar_region",
    time_of_disembarkation: "2024-07-10T08:22:00Z",
    confirmation_by: "some updated confirmation_by",
    frontext_involvement: "some updated frontext_involvement",
    pob_total: 43,
    status: "some updated status",
    pob_medical_cases: 43,
    pob_men: 43,
    boat_notes: "some updated boat_notes",
    phonenumber: "some updated phonenumber",
    followup_needed: false,
    authorities_alerted: false,
    actors_involved: "some updated actors_involved",
    authorities_details: "some updated authorities_details",
    place_of_disembarkation: "some updated place_of_disembarkation",
    name: "DC2999",
    pob_minors: 43,
    boat_type: "some updated boat_type",
    place_of_departure: "some updated place_of_departure",
    time_of_departure: "2024-07-10T08:22:00Z",
    pob_women: 43,
    notes: "some updated notes",
    cloud_file_links: "some updated cloud_file_links",
    boat_color: "some updated boat_color",
    people_missing: 43,
    disembarked_by: "some updated disembarked_by",
    url: "some updated url",
    alarmphone_contact: "some updated alarmphone_contact"
  }
  @invalid_attrs %{
    people_dead: nil,
    template: nil,
    pob_per_nationality: nil,
    outcome_actors: nil,
    occurred_at: nil,
    boat_engine_status: nil,
    boat_engine_working: nil,
    imported_from: nil,
    departure_region: nil,
    outcome: nil,
    boat_number_of_engines: nil,
    pob_gender_ambiguous: nil,
    sar_region: nil,
    time_of_disembarkation: nil,
    confirmation_by: nil,
    frontext_involvement: nil,
    pob_total: nil,
    status: nil,
    pob_medical_cases: nil,
    pob_men: nil,
    boat_notes: nil,
    phonenumber: nil,
    followup_needed: false,
    authorities_alerted: false,
    actors_involved: nil,
    authorities_details: nil,
    place_of_disembarkation: nil,
    name: nil,
    pob_minors: nil,
    boat_type: nil,
    place_of_departure: nil,
    time_of_departure: nil,
    pob_women: nil,
    notes: nil,
    cloud_file_links: nil,
    boat_color: nil,
    people_missing: nil,
    disembarked_by: nil,
    url: nil,
    alarmphone_contact: nil
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

    # test "upload csv", %{conn: conn} do
    #   {:ok, index_live, _html} = live(conn, ~p"/imported_cases")

    #   assert index_live |> element("a", "Upload") |> render_click() =~
    #            "Case Importer"

    #   assert_patch(index_live, ~p"/imported_cases/upload")

    #   assert index_live
    #          |> form("#upload-form", imported_case: @invalid_attrs)
    #          |> render_change() =~ "can&#39;t be blank"

    #   assert index_live
    #          |> form("#upload-form", imported_case: @create_attrs)
    #          |> render_submit()

    #   # assert_flash(index_live, :info, "rows imported")

    #   html = render(index_live)
    #   assert html =~ "Imported case created successfully"
    #   assert html =~ "some status"
    # end

    # test "validate imported_case in listing", %{conn: conn, imported_case: imported_case} do
    #   ## TODO: Check that the case is not in the list afterwards

    #   {:ok, index_live, _html} = live(conn, ~p"/imported_cases")

    #   assert index_live
    #          |> element("#imported_cases-#{imported_case.id} a", "Validate")
    #          |> render_click() =~
    #            "Validate Imported case"

    #   assert_patch(index_live, ~p"/imported_cases/#{imported_case}/validate")

    #   assert index_live
    #          |> form("#imported_case-form", case: @invalid_attrs)
    #          |> render_change() =~ "can&#39;t be blank"

    #   assert index_live
    #          |> form("#imported_case-form", case: @update_attrs)
    #          |> render_submit()

    #   assert_patch(index_live, ~p"/imported_cases")

    #   html = render(index_live)
    #   assert html =~ "Imported case updated successfully"
    #   assert html =~ "some updated template"
    # end

    test "deletes imported_case in listing", %{conn: conn, imported_case: imported_case} do
      {:ok, index_live, _html} = live(conn, ~p"/imported_cases")

      assert index_live
             |> element("#imported_cases-#{imported_case.id} a", "Delete")
             |> render_click()

      refute has_element?(index_live, "#imported_cases-#{imported_case.id}")
    end
  end
end
