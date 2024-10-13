defmodule CaseManagerWeb.UserLive.IndexTest do
  use CaseManagerWeb.ConnCase

  import Phoenix.LiveViewTest
  import CaseManagerWeb.LoginUtils
  alias CaseManager.Accounts

  @create_attrs %{
    name: "some name",
    email: "some@email.com",
    password: "somepassword324234",
    role: :user
  }
  @update_attrs %{
    name: "some updated name",
    email: "updated@email.com",
    password: "updatedpassword66245",
    role: :readonly
  }
  @invalid_attrs %{
    name: nil,
    email: nil,
    password: nil
  }

  defp create_user(_) do
    {:ok, user} = Accounts.create_user(%{@create_attrs | email: "first@email.com"})
    %{user: user}
  end

  describe "Index" do
    setup [:create_user, :login_admin]

    test "lists all users", %{conn: conn, user: user} do
      {:ok, _index_live, html} = live(conn, ~p"/users")

      assert html =~ "Listing Users"
      assert html =~ user.email
    end

    test "saves new user", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/users")

      assert index_live |> element("a", "New User") |> render_click() =~
               "New User"

      assert_patch(index_live, ~p"/users/new")

      assert index_live
             |> form("#user-form", user: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#user-form", user: @create_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/users")

      html = render(index_live)
      assert html =~ "User created successfully"
      assert html =~ "some@email.com"
    end

    test "updates user in listing", %{conn: conn, user: user} do
      {:ok, index_live, _html} = live(conn, ~p"/users")

      assert index_live |> element("#users-#{user.id} a", "Edit") |> render_click() =~
               "Edit User"

      assert_patch(index_live, ~p"/users/#{user}/edit")

      assert index_live
             |> form("#user-form", user: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#user-form", user: @update_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/users")

      html = render(index_live)
      assert html =~ "User updated successfully"
      assert html =~ "updated@email.com"
    end

    test "deletes user in listing", %{conn: conn, user: user} do
      {:ok, index_live, _html} = live(conn, ~p"/users")

      assert index_live |> element("#users-#{user.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#user-#{user.id}")
    end
  end

  describe "Index with readonly" do
    setup [:create_user, :login_readonly]

    test "redirects to login page when accessing users index", %{conn: conn} do
      {:error, {:redirect, %{to: redirect_path}}} = live(conn, ~p"/users")
      assert redirect_path == ~p"/users/log_in"
    end

    test "cannot access new user form", %{conn: conn} do
      {:error, {:redirect, %{to: redirect_path}}} = live(conn, ~p"/users/new")
      assert redirect_path == ~p"/users/log_in"
    end

    test "can access /users/settings", %{conn: conn} do
      {:ok, _live, html} = live(conn, ~p"/users/settings")
      assert html =~ "Settings"
    end

    test "cannot access edit user form", %{conn: conn, user: user} do
      {:error, {:redirect, %{to: redirect_path}}} = live(conn, ~p"/users/#{user}/edit")
      assert redirect_path == ~p"/users/log_in"
    end
  end

  describe "Index without login" do
    setup [:create_user]

    test "redirects to login page when accessing users index", %{conn: conn} do
      {:error, {:redirect, %{to: redirect_path}}} = live(conn, ~p"/users")
      assert redirect_path == ~p"/users/log_in"
    end

    test "cannot access new user form", %{conn: conn} do
      {:error, {:redirect, %{to: redirect_path}}} = live(conn, ~p"/users/new")
      assert redirect_path == ~p"/users/log_in"
    end

    test "cannot access edit user form", %{conn: conn, user: user} do
      {:error, {:redirect, %{to: redirect_path}}} = live(conn, ~p"/users/#{user}/edit")
      assert redirect_path == ~p"/users/log_in"
    end
  end

  describe "Index with normal user login" do
    setup [:create_user, :login]

    test "redirects to unauthorized page when accessing users index", %{conn: conn} do
      {:error, _} = live(conn, ~p"/users")
    end

    test "cannot access new user form", %{conn: conn} do
      {:error, _} = live(conn, ~p"/users/new")
    end

    test "cannot access edit user form", %{conn: conn, user: user} do
      {:error, _} = live(conn, ~p"/users/#{user}/edit")
    end
  end
end
