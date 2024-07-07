defmodule EventsWeb.CaseLiveTest do
  use EventsWeb.ConnCase

  import Phoenix.LiveViewTest
  import Events.CasesFixtures

  @create_attrs %{
    archived_at: "2024-03-07T08:58:00Z",
    closed_at: "2024-03-07T08:58:00Z",
    created_at: "2024-03-07T08:58:00Z",
    deleted_at: "2024-03-07T08:58:00Z",
    description: "some description",
    identifier: "some identifier",
    is_archived: true,
    opened_at: "2024-03-07T08:58:00Z",
    status: "some status",
    status_note: "some status_note",
    title: "some title",
    updated_at: "2024-03-07T08:58:00Z"
  }
  @update_attrs %{
    archived_at: "2024-03-08T08:58:00Z",
    closed_at: "2024-03-08T08:58:00Z",
    created_at: "2024-03-08T08:58:00Z",
    deleted_at: "2024-03-08T08:58:00Z",
    description: "some updated description",
    identifier: "some updated identifier",
    is_archived: false,
    opened_at: "2024-03-08T08:58:00Z",
    status: "some updated status",
    status_note: "some updated status_note",
    title: "some updated title",
    updated_at: "2024-03-08T08:58:00Z"
  }
  @invalid_attrs %{
    archived_at: nil,
    closed_at: nil,
    created_at: nil,
    deleted_at: nil,
    description: nil,
    identifier: nil,
    is_archived: false,
    opened_at: nil,
    status: nil,
    status_note: nil,
    title: nil,
    updated_at: nil
  }

  defp create_case(_) do
    case = case_fixture()
    %{case: case}
  end

  describe "Index" do
    setup [:create_case]

    test "lists all cases", %{conn: conn, case: case} do
      {:ok, _index_live, html} = live(conn, ~p"/cases")

      assert html =~ "Listing Cases"
      assert html =~ case.description
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
      assert html =~ "some description"
    end

    test "updates case in listing", %{conn: conn, case: case} do
      {:ok, index_live, _html} = live(conn, ~p"/cases")

      assert index_live |> element("#cases-#{case.id} a", "Edit") |> render_click() =~
               "Edit Case"

      assert_patch(index_live, ~p"/cases/#{case}/edit")

      assert index_live
             |> form("#case-form", case: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#case-form", case: @update_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/cases")

      html = render(index_live)
      assert html =~ "Case updated successfully"
      assert html =~ "some updated description"
    end

    test "deletes case in listing", %{conn: conn, case: case} do
      {:ok, index_live, _html} = live(conn, ~p"/cases")

      assert index_live |> element("#cases-#{case.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#cases-#{case.id}")
    end
  end

  describe "Show" do
    setup [:create_case]

    test "displays case", %{conn: conn, case: case} do
      {:ok, _show_live, html} = live(conn, ~p"/cases/#{case}")

      assert html =~ "Show Case"
      assert html =~ case.description
    end

    test "updates case within modal", %{conn: conn, case: case} do
      {:ok, show_live, _html} = live(conn, ~p"/cases/#{case}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Case"

      assert_patch(show_live, ~p"/cases/#{case}/show/edit")

      assert show_live
             |> form("#case-form", case: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#case-form", case: @update_attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/cases/#{case}")

      html = render(show_live)
      assert html =~ "Case updated successfully"
      assert html =~ "some updated description"
    end
  end
end
