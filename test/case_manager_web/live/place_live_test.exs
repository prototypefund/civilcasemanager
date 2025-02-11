defmodule CaseManagerWeb.PlaceLiveTest do
  use CaseManagerWeb.ConnCase

  import Phoenix.LiveViewTest
  import CaseManager.PlacesFixtures
  import CaseManagerWeb.LoginUtils

  @create_attrs %{
    name: "some name",
    type: :departure,
    country: "some country",
    lat: "120.5",
    lon: "120.5"
  }
  @update_attrs %{
    name: "some updated name",
    type: :arrival,
    country: "some updated country",
    lat: "56.7",
    lon: "56.7"
  }
  @invalid_attrs %{type: nil, country: nil, lat: nil, lon: nil}

  defp create_place(_) do
    place = place_fixture()
    %{place: place}
  end

  describe "Index" do
    setup [:create_place, :login]

    test "lists all places", %{conn: conn, place: place} do
      {:ok, _index_live, html} = live(conn, ~p"/places")

      assert html =~ "Listing Places"
      assert html =~ place.name
    end

    test "saves new place", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/places")

      assert index_live |> element("a", "New Place") |> render_click() =~
               "New Place"

      assert_patch(index_live, ~p"/places/new")

      assert index_live
             |> form("#place-form", place: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#place-form", place: @create_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/places")

      html = render(index_live)
      assert html =~ "Place created successfully"
      assert html =~ "some name"
    end

    test "updates place in listing", %{conn: conn, place: place} do
      {:ok, index_live, _html} = live(conn, ~p"/places")

      assert index_live |> element("#places-#{place.id} a", "Edit") |> render_click() =~
               "Edit Place"

      assert_patch(index_live, ~p"/places/#{place}/edit")

      assert index_live
             |> form("#place-form", place: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#place-form", place: @update_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/places")

      html = render(index_live)
      assert html =~ "Place updated successfully"
    end

    test "deletes place in listing", %{conn: conn, place: place} do
      {:ok, index_live, _html} = live(conn, ~p"/places")

      assert index_live |> element("#places-#{place.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#places-#{place.id}")
    end
  end

  describe "Readonly" do
    setup [:create_place, :login_readonly]

    test "cannot create a new place", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/places")
      refute has_element?(index_live, "a", "New Place")
    end

    test "cannot edit an existing place", %{conn: conn, place: place} do
      {:ok, index_live, _html} = live(conn, ~p"/places")
      refute has_element?(index_live, "#places-#{place.id} a", "Edit")
    end

    test "cannot delete an existing place", %{conn: conn, place: place} do
      {:ok, index_live, _html} = live(conn, ~p"/places")
      refute has_element?(index_live, "#places-#{place.id} a", "Delete")
    end

    test "cannot access new place form", %{conn: conn} do
      assert {:error, {:redirect, _}} = live(conn, ~p"/places/new")
    end

    test "cannot access edit place form", %{conn: conn, place: place} do
      assert {:error, {:redirect, _}} = live(conn, ~p"/places/#{place}/edit")
    end
  end

  describe "Show" do
    setup [:create_place, :login]

    test "displays place", %{conn: conn, place: place} do
      {:ok, _show_live, html} = live(conn, ~p"/places/#{place}")

      assert html =~ "Show Place"
      assert html =~ place.name
    end

    test "updates place within modal", %{conn: conn, place: place} do
      {:ok, show_live, _html} = live(conn, ~p"/places/#{place}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Place"

      assert_patch(show_live, ~p"/places/#{place}/show/edit")

      assert show_live
             |> form("#place-form", place: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#place-form", place: @update_attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/places/#{place}")

      html = render(show_live)
      assert html =~ "Place updated successfully"
      assert html =~ "some updated name"
    end
  end
end
