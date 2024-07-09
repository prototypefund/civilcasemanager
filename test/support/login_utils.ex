defmodule(CaseManagerWeb.LoginUtils) do
  use CaseManagerWeb.ConnCase

  alias CaseManagerWeb.UserLive.Auth
  import CaseManager.AccountsFixtures

  @remember_me_cookie "_events_web_user_remember_me"

  def login(%{conn: conn}) do
    do_login(:user, conn)
  end

  def login_readonly(%{conn: conn}) do
    do_login(:readonly, conn)
  end

  def login_admin(%{conn: conn}) do
    do_login(:admin, conn)
  end

  defp do_login(role, conn) do
    user = user_fixture(%{role: role})

    conn =
      conn
      |> Map.replace!(:secret_key_base, CaseManagerWeb.Endpoint.config(:secret_key_base))
      |> init_test_session(%{})

    logged_in_conn =
      conn |> fetch_cookies() |> Auth.log_in_user(user, %{"remember_me" => "true"})

    %{value: signed_token} = logged_in_conn.resp_cookies[@remember_me_cookie]
    conn = conn |> put_req_cookie(@remember_me_cookie, signed_token)

    %{user: user, conn: conn}
  end
end
