defmodule CaseManagerWeb.UserLive.ForgotPasswordTest do
  use CaseManagerWeb.ConnCase

  import Phoenix.LiveViewTest
  import CaseManager.AccountsFixtures

  describe "Forgot password page" do
    test "renders email page", %{conn: conn} do
      {:ok, lv, html} = live(conn, ~p"/users/reset_password")

      assert html =~ "Forgot your password?"
      assert html =~ "Please contact the adminstration"
      assert has_element?(lv, ~s|a[href="#{~p"/users/log_in"}"]|, "Log in")
    end

    test "does not contain a form", %{conn: conn} do
      {:ok, _view, html} = live(conn, ~p"/users/reset_password")

      refute html =~ "<form"
    end

    test "contains link to log in page", %{conn: conn} do
      {:ok, view, _html} = live(conn, ~p"/users/reset_password")

      view |> element("a", "Log in") |> render_click()

      assert_redirect(view, ~p"/users/log_in")
    end

    test "redirects if already logged in", %{conn: conn} do
      result =
        conn
        |> log_in_user(user_fixture())
        |> live(~p"/users/reset_password")
        |> follow_redirect(conn, ~p"/")

      assert {:ok, _conn} = result
    end
  end
end
