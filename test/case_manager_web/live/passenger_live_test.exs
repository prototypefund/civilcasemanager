defmodule CaseManagerWeb.PassengerLiveTest do
  use CaseManagerWeb.ConnCase

  import Phoenix.LiveViewTest
  import CaseManager.PassengersFixtures
  import CaseManagerWeb.LoginUtils

  @create_attrs %{name: "some name", description: "some description"}
  @update_attrs %{name: "some updated name", description: "some updated description"}
  @invalid_attrs %{name: nil, description: nil}

  defp create_passenger(_) do
    passenger = passenger_fixture()
    %{passenger: passenger}
  end

  describe "Index" do
    setup [:create_passenger, :login]

    test "lists all passengers", %{conn: conn, passenger: passenger} do
      {:ok, _index_live, html} = live(conn, ~p"/passengers")

      assert html =~ "Listing Passengers"
      assert html =~ passenger.name
    end

    test "saves new passenger", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/passengers")

      assert index_live |> element("a", "New Passenger") |> render_click() =~
               "New Passenger"

      assert_patch(index_live, ~p"/passengers/new")

      assert index_live
             |> form("#passenger-form", passenger: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      case = CaseManager.CasesFixtures.case_fixture()
      attrs = Map.put(@create_attrs, :case_id, case.id)

      assert index_live
             |> form("#passenger-form", passenger: attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/passengers")

      html = render(index_live)
      assert html =~ "Passenger created successfully"
      assert html =~ "some name"
    end

    test "updates passenger in listing", %{conn: conn, passenger: passenger} do
      {:ok, index_live, _html} = live(conn, ~p"/passengers")

      assert index_live |> element("#passengers-#{passenger.id} a", "Edit") |> render_click() =~
               "Edit Passenger"

      assert_patch(index_live, ~p"/passengers/#{passenger}/edit")

      assert index_live
             |> form("#passenger-form", passenger: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#passenger-form", passenger: @update_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/passengers")

      html = render(index_live)
      assert html =~ "Passenger updated successfully"
      assert html =~ "some updated name"
    end

    test "deletes passenger in listing", %{conn: conn, passenger: passenger} do
      {:ok, index_live, _html} = live(conn, ~p"/passengers")

      assert index_live |> element("#passengers-#{passenger.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#passengers-#{passenger.id}")
    end
  end

  describe "Readonly" do
    setup [:create_passenger, :login_readonly]

    test "cannot create passenger", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/passengers")

      refute has_element?(index_live, "a", "New Passenger")

      {:error, {:redirect, _}} =
        live(conn, ~p"/passengers/new")
    end

    test "cannot edit passenger", %{conn: conn, passenger: passenger} do
      {:ok, index_live, _html} = live(conn, ~p"/passengers")

      refute has_element?(index_live, "#passengers-#{passenger.id} a", "Edit")

      {:error, {:redirect, _}} = live(conn, ~p"/passengers/#{passenger}/edit")
    end

    test "cannot delete passenger", %{conn: conn, passenger: passenger} do
      {:ok, index_live, _html} = live(conn, ~p"/passengers")

      refute has_element?(index_live, "#passengers-#{passenger.id} a", "Delete")
    end
  end

  describe "Show" do
    setup [:create_passenger, :login]

    test "displays passenger", %{conn: conn, passenger: passenger} do
      {:ok, _show_live, html} = live(conn, ~p"/passengers/#{passenger}")

      assert html =~ "Show Passenger"
      assert html =~ passenger.name
    end

    test "updates passenger within modal", %{conn: conn, passenger: passenger} do
      {:ok, show_live, _html} = live(conn, ~p"/passengers/#{passenger}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Passenger"

      assert_patch(show_live, ~p"/passengers/#{passenger}/show/edit")

      assert show_live
             |> form("#passenger-form", passenger: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#passenger-form", passenger: @update_attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/passengers/#{passenger}")

      html = render(show_live)
      assert html =~ "Passenger updated successfully"
      assert html =~ "some updated name"
    end
  end
end
