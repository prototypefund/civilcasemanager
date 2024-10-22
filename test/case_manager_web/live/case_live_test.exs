defmodule CaseManagerWeb.CaseLiveTest do
  use CaseManagerWeb.ConnCase

  import Phoenix.LiveViewTest
  import CaseManager.CasesFixtures
  import CaseManagerWeb.LoginUtils

  @create_attrs %{
    name: "AP9001-2022",
    notes: "some notes",
    status: :open,
    occurred_at: ~U[2024-03-07 08:58:00Z],
    departure_region: "Libya",
    time_of_departure: ~U[2024-03-07 08:58:00Z],
    sar_region: :sar1,
    phonenumber: "some phonenumber",
    actors_involved: "some actors_involved",
    authorities_alerted: "MC MALTA",
    authorities_details: "some authorities_details",
    boat_type: :rubber,
    boat_notes: "some boat_notes",
    boat_color: :red,
    boat_engine_failure: "yes",
    boat_number_of_engines: 42,
    pob_total: 42,
    pob_men: 42,
    pob_women: 42,
    pob_minors: 42,
    pob_gender_ambiguous: 42,
    pob_medical_cases: 42,
    people_dead: 42,
    people_missing: 42,
    outcome: :unknown,
    time_of_disembarkation: ~U[2024-03-07 08:58:00Z],
    disembarked_by: "some disembarked_by",
    outcome_actors: "some outcome_actors",
    followup_needed: true,
    url: "some url"
  }
  @update_attrs %{
    name: "DC1001-2002",
    notes: "some updated notes",
    status: :ready_for_documentation,
    occurred_at: ~U[2024-03-08 08:58:00Z],
    departure_region: "Syria",
    time_of_departure: ~U[2024-03-08 08:58:00Z],
    sar_region: :sar2,
    phonenumber: "some updated phonenumber",
    actors_involved: "some updated actors_involved",
    authorities_alerted: "MC ROME",
    authorities_details: "some updated authorities_details",
    boat_type: :wood,
    boat_notes: "some updated boat_notes",
    boat_color: :green,
    boat_engine_failure: "no",
    boat_number_of_engines: 43,
    pob_total: 43,
    pob_men: 43,
    pob_women: 43,
    pob_minors: 43,
    pob_gender_ambiguous: 43,
    pob_medical_cases: 43,
    people_dead: 43,
    people_missing: 43,
    outcome: :interception_libya,
    time_of_disembarkation: ~U[2024-03-08 08:58:00Z],
    disembarked_by: "some updated disembarked_by",
    outcome_actors: "some updated outcome_actors",
    followup_needed: false,
    url: "some updated url"
  }

  @invalid_attrs %{
    name: nil
  }

  # @invalid_name %{
  #   name: "DC100 AC2300"
  # }

  @invalid_status %{
    status: :random
  }

  defp create_case(_) do
    case = case_fixture()
    %{caseStruct: case}
  end

  defp remove_year_from_name(name) do
    String.replace(name, ~r/-\d{4}$/, "")
  end

  describe "Anonymous user" do
    test "cannot list cases", %{conn: conn} do
      {:error, _} = live(conn, ~p"/cases")
    end
  end

  describe "Readonly user" do
    setup [:create_case, :login_readonly]

    test "can list all cases", %{conn: conn, caseStruct: case} do
      {:ok, _index_live, html} = live(conn, ~p"/cases")

      assert html =~ "Listing Cases"
      assert html =~ remove_year_from_name(case.name)
    end

    test "cannot saves new case", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/cases")

      refute has_element?(index_live, "a", "New Case")
    end

    test "cannot delete case in listing", %{conn: conn, caseStruct: case} do
      {:ok, index_live, _html} = live(conn, ~p"/cases")

      refute has_element?(index_live, "#cases-#{case.id} a", "Delete")
    end
  end

  describe "Index" do
    setup [:create_case, :login]

    test "lists all cases", %{conn: conn, caseStruct: case} do
      {:ok, _index_live, html} = live(conn, ~p"/cases")

      assert html =~ "Listing Cases"
      assert html =~ remove_year_from_name(case.name)
    end

    test "saves new case", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/cases")

      assert index_live |> element("a", "New Case") |> render_click() =~
               "New Case"

      assert_patch(index_live, ~p"/cases/new")

      assert index_live
             |> form("#case-form", case: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#case-form", case: @create_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/cases")

      html = render(index_live)
      assert html =~ "Case created successfully"
      assert html =~ "some notes"
    end

    test "updates case in listing", %{conn: conn, caseStruct: case} do
      {:ok, index_live, _html} = live(conn, ~p"/cases")

      assert index_live |> element("#cases-#{case.id} a", "Edit") |> render_click() =~
               "Edit Case"

      assert_patch(index_live, ~p"/cases/#{case}/edit")

      assert index_live
             |> form("#case-form", case: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert_raise ArgumentError, fn ->
        index_live
        |> form("#case-form", case: @invalid_status)
        |> render_change() =~ "must be one of"
      end

      assert {:ok, _view, html} =
               index_live
               |> form("#case-form", case: @update_attrs)
               |> render_submit()
               |> follow_redirect(conn, ~p"/cases")

      assert html =~ "Case updated successfully"
      assert html =~ "some updated notes"
    end

    test "deletes case in listing", %{conn: conn, caseStruct: case} do
      {:ok, index_live, _html} = live(conn, ~p"/cases")

      assert index_live |> element("#cases-#{case.id} a", "Delete") |> render_click()
      # TODO: Needs to accomodate new date grouping
      # assert has_element?(index_live, "#cases-#{case.id}", "display")
    end
  end

  describe "Show" do
    setup [:create_case, :login]

    test "displays case", %{conn: conn, caseStruct: case} do
      {:ok, _show_live, html} = live(conn, ~p"/cases/#{case}")

      assert html =~ "Show Case"
      assert html =~ remove_year_from_name(case.name)
    end

    test "edit button leads to correct URL", %{conn: conn, caseStruct: case} do
      {:ok, show_live, _html} = live(conn, ~p"/cases/#{case}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit case"

      assert_patch(show_live, ~p"/cases/#{case}/show/edit")
    end

    test "adds an event through small form", %{conn: conn, caseStruct: case} do
      {:ok, show_live, _html} = live(conn, ~p"/cases/#{case}")

      assert show_live
             |> form("#event-form", event: %{body: "Test event body"})
             |> render_submit()

      assert_patch(show_live, ~p"/cases/#{case}")

      html = render(show_live)
      assert html =~ "Comment created successfully"
      assert html =~ "Test event body"
    end

    test "updates case content after external edit", %{conn: conn, caseStruct: case} do
      {:ok, show_live, _html} = live(conn, ~p"/cases/#{case}")

      # Initial assertion
      html = render(show_live)
      assert html =~ remove_year_from_name(case.name)
      assert html =~ case.notes

      # Update the case externally
      updated_attrs = %{name: "DC1000-2002", notes: "Updated case notes"}
      {:ok, _} = CaseManager.Cases.update_case(case, updated_attrs)

      # Check that the page now has the updated content
      updated_html = render(show_live)
      assert updated_html =~ updated_attrs.name
      assert updated_html =~ updated_attrs.notes
      refute updated_html =~ remove_year_from_name(case.name)
      refute updated_html =~ case.notes
    end

    test "doesn't update case content if external edit to different case", %{
      conn: conn,
      caseStruct: case
    } do
      {:ok, show_live, _html} = live(conn, ~p"/cases/#{case}")

      # Initial assertion
      html = render(show_live)
      assert html =~ remove_year_from_name(case.name)
      assert html =~ case.notes

      # Create and update a different case
      different_case = case_fixture()
      updated_attrs = %{name: "DC2000-2003", notes: "Different case notes"}
      {:ok, _} = CaseManager.Cases.update_case(different_case, updated_attrs)

      # Check that the page still has the original content
      updated_html = render(show_live)
      assert updated_html =~ remove_year_from_name(case.name)
      assert updated_html =~ case.notes
      refute updated_html =~ updated_attrs.name
      refute updated_html =~ updated_attrs.notes
    end

    test "updates events after external addition", %{conn: conn, caseStruct: case} do
      {:ok, show_live, _html} = live(conn, ~p"/cases/#{case}")

      # Initial assertion
      html = render(show_live)
      refute html =~ "External event 1"
      refute html =~ "External event 2"
      refute html =~ "Event for different case"

      # Add events externally
      CaseManager.Events.create_event(%{cases: [case.id], body: "External event 1"})
      CaseManager.Events.create_event(%{cases: [case.id], body: "External event 2"})

      # Create a second case and add an event to it
      second_case = case_fixture()

      CaseManager.Events.create_event(%{
        cases: [second_case.id],
        body: "Event for different case"
      })

      # Check that the page now has the new events for the current case, but not the event for the second case
      updated_html = render(show_live)
      assert updated_html =~ "External event 1"
      assert updated_html =~ "External event 2"
      refute updated_html =~ "Event for different case"
    end

    test "updates associated event and reflects change", %{conn: conn, caseStruct: case} do
      {:ok, show_live, _html} = live(conn, ~p"/cases/#{case}")

      # Create an associated event
      {:ok, event} =
        CaseManager.Events.create_event(%{cases: [case.id], body: "Initial event body"})

      # Initial assertion
      html = render(show_live)
      assert html =~ "Initial event body"

      # Update the event externally
      CaseManager.Events.update_event(event, %{body: "Updated event body"})

      # Check that the page now has the updated event content
      updated_html = render(show_live)
      assert updated_html =~ "Updated event body"
      refute updated_html =~ "Initial event body"
    end
  end

  describe "Edit" do
    setup [:create_case, :login]

    test "updates case on edit screen", %{conn: conn, caseStruct: case} do
      {:ok, edit_live, _html} = live(conn, ~p"/cases/#{case}/show/edit")

      assert edit_live
             |> form("#case-form", case: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert {:ok, _view, html} =
               edit_live
               |> form("#case-form", case: @update_attrs)
               |> render_submit()
               |> follow_redirect(conn, ~p"/cases/#{case}")

      assert html =~ "Case updated successfully"
      assert html =~ "some updated notes"
    end

    test "refreshes edit form after external update", %{conn: conn, caseStruct: case} do
      {:ok, edit_live, _html} = live(conn, ~p"/cases/#{case}/show/edit")

      # Initial assertion
      assert edit_live |> form("#case-form") |> render() =~ case.notes

      # Edit another field without submitting
      assert edit_live
             |> form("#case-form", case: %{name: "Updated Title"})
             |> render_change() =~ "Updated Title"

      # Update case externally
      CaseManager.Cases.update_case(case, %{notes: "Externally updated notes"})

      # Check that the form has been refreshed with the new data
      updated_form = edit_live |> form("#case-form") |> render()
      assert updated_form =~ "Externally updated notes"
      refute updated_form =~ case.notes

      # Check that the form still has the updated title
      assert updated_form =~ "Updated Title"
    end

    test "doesn't refresh edit when a different case was edited", %{conn: conn, caseStruct: case} do
      {:ok, edit_live, _html} = live(conn, ~p"/cases/#{case}/show/edit")

      # Initial assertion
      assert edit_live |> form("#case-form") |> render() =~ case.notes

      # Create and update a different case
      {:ok, different_case} =
        CaseManager.Cases.create_case(%{
          notes: "Different case notes",
          name: "DC2000-2003",
          status: :open,
          occurred_at: ~U[2023-01-01 10:00:00Z]
        })

      CaseManager.Cases.update_case(different_case, %{notes: "Updated different case notes"})

      # Check that the form hasn't been refreshed
      updated_form = edit_live |> form("#case-form") |> render()
      assert updated_form =~ case.notes
      refute updated_form =~ "Updated different case notes"
    end
  end
end
