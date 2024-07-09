defmodule CaseManagerWeb.PageControllerTest do
  use CaseManagerWeb.ConnCase

  test "Unauthorized GET / redirects to login", %{conn: conn} do
    conn = get(conn, ~p"/")
    assert html_response(conn, 302) =~ "redirected"
  end
end
