defmodule CaseManagerWeb.UserLive.ResetPasswordTest do
  use CaseManagerWeb.ConnCase

  import Phoenix.LiveViewTest

  describe "ResetPassword" do
    test "renders reset password page", %{conn: conn} do
      {:ok, _view, html} = live(conn, ~p"/users/reset_password")

      assert html =~ "Forgot your password?"
      assert html =~ "Please contact the adminstration"
      assert html =~ "Log in"
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
  end
end
