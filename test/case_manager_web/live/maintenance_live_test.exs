defmodule CaseManagerWeb.MaintenanceLiveTest do
  use CaseManagerWeb.ConnCase

  import Phoenix.LiveViewTest
  import CaseManagerWeb.LoginUtils

  describe "MaintenanceLive" do
    setup [:login_admin]

    test "renders maintenance page", %{conn: conn} do
      {:ok, _view, html} = live(conn, "/maintenance")
      assert html =~ "Maintenance Scripts"
    end

    test "renders without error for various query params", %{conn: conn} do
      {:ok, _view, html} = live(conn, "/maintenance?param1=value1¶m2=value2")
      assert html =~ "Maintenance Scripts"
    end
  end

  describe "MaintenanceLive without login" do
    test "redirects to login page when not logged in", %{conn: conn} do
      conn = get(conn, "/maintenance")
      assert redirected_to(conn) =~ "/users/log_in"
    end

    test "returns error for live connection when not logged in", %{conn: conn} do
      assert {:error, {:redirect, %{to: "/users/log_in"}}} = live(conn, "/maintenance")
    end
  end
end
