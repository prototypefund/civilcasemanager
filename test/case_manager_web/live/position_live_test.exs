defmodule CaseManagerWeb.PositionLiveTest do
  use CaseManagerWeb.ConnCase

  import Phoenix.LiveViewTest
  import CaseManager.PositionsFixtures

  import CaseManagerWeb.LoginUtils

  @create_attrs %{
    timestamp: "2024-07-04T16:34:00Z",
    speed: "120.5",
    source: "some source",
    altitude: "120.5",
    course: "120.5",
    heading: "120.5",
    short_code: "11.34 / 12",
    imported_from: "some imported_from",
    soft_deleted: true
  }
  @update_attrs %{
    timestamp: "2024-07-05T16:34:00Z",
    speed: "456.7",
    source: "some updated source",
    altitude: "456.7",
    course: "456.7",
    heading: "456.7",
    short_code: "11.56 / 12",
    imported_from: "some updated imported_from",
    soft_deleted: false
  }
  @invalid_attrs %{
    timestamp: nil,
    speed: nil,
    source: nil,
    altitude: nil,
    course: nil,
    heading: nil,
    imported_from: nil,
    soft_deleted: false
  }

  defp create_position(_) do
    position = position_fixture()
    %{position: position}
  end

  describe "Anonymous user" do
    test "cannot lists positions", %{conn: conn} do
      {:error, _} = live(conn, ~p"/positions")
    end
  end

  describe "Readonly user" do
    setup [:create_position, :login_readonly]

    test "can list all positions", %{conn: conn, position: position} do
      {:ok, _index_live, html} = live(conn, ~p"/positions")

      assert html =~ "Listing Positions"
      assert html =~ position.id
    end

    test "cannot saves new position", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/positions")

      refute has_element?(index_live, "a", "New Position")
    end

    test "cannot delete position in listing", %{conn: conn, position: position} do
      {:ok, index_live, _html} = live(conn, ~p"/positions")

      refute has_element?(index_live, "#positions-#{position.id} a", "Delete")
    end
  end

  describe "Index" do
    setup [:create_position, :login]

    test "lists all positions", %{conn: conn, position: position} do
      {:ok, _index_live, html} = live(conn, ~p"/positions")

      assert html =~ "Listing Positions"
      assert html =~ position.id
    end

    test "saves new position", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/positions")

      assert index_live |> element("a", "New Position") |> render_click() =~
               "New Position"

      assert_patch(index_live, ~p"/positions/new")

      assert index_live
             |> form("#position-form", position: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#position-form", position: @create_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/positions")

      html = render(index_live)
      assert html =~ "Position created successfully"
      assert html =~ "11.34"
    end

    test "updates position in listing", %{conn: conn, position: position} do
      {:ok, index_live, _html} = live(conn, ~p"/positions")

      assert index_live |> element("#positions-#{position.id} a", "Edit") |> render_click() =~
               "Edit Position"

      assert_patch(index_live, ~p"/positions/#{position}/edit")

      assert index_live
             |> form("#position-form", position: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#position-form", position: @update_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/positions")

      html = render(index_live)
      assert html =~ "Position updated successfully"
      assert html =~ "11.56"
    end

    test "deletes position in listing", %{conn: conn, position: position} do
      {:ok, index_live, _html} = live(conn, ~p"/positions")

      assert index_live |> element("#positions-#{position.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#positions-#{position.id}")
    end
  end

  describe "Show" do
    setup [:create_position, :login]

    test "displays position", %{conn: conn, position: position} do
      {:ok, _show_live, html} = live(conn, ~p"/positions/#{position}")

      assert html =~ "Show Position"
      assert html =~ position.id
    end

    test "updates position within modal", %{conn: conn, position: position} do
      {:ok, show_live, _html} = live(conn, ~p"/positions/#{position}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Position"

      assert_patch(show_live, ~p"/positions/#{position}/show/edit")

      assert show_live
             |> form("#position-form", position: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#position-form", position: @update_attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/positions/#{position}")

      html = render(show_live)
      assert html =~ "Position updated successfully"
      assert html =~ "11.56"
    end
  end
end
