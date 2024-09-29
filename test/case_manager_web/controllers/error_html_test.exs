defmodule CaseManagerWeb.ErrorHTMLTest do
  use CaseManagerWeb.ConnCase, async: true

  # Bring render_to_string/4 for testing custom views
  import Phoenix.Template

  describe "Error" do
    test "renders 404.html" do
      content = render_to_string(CaseManagerWeb.ErrorHTML, "404", "html", [])
      assert content =~ "Sorry, the page you are looking for does not exist."
    end

    test "renders 500.html" do
      content = render_to_string(CaseManagerWeb.ErrorHTML, "500", "html", [])
      assert content =~ "The application could not process your request."
      assert content =~ "Please let the administrators know"
    end

    test "renders 404.html for invalid path" do
      conn = build_conn()
      conn = get(conn, "/INVALID")
      assert html_response(conn, 404) =~ "Sorry, the page you are looking for does not exist."
    end
  end
end
