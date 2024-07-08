defmodule CaseManagerWeb.UserLive.RegistrationTest do
  use CaseManagerWeb.ConnCase

  import Phoenix.LiveViewTest

  describe "Registration page" do
    test "is not activated", %{conn: conn} do
      assert_raise FunctionClauseError, fn ->
        live(conn, "/users/register")
      end
    end
  end
end
