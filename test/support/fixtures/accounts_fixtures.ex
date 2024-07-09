defmodule CaseManager.AccountsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `CaseManager.Accounts` context.
  """

  def unique_user_email, do: "user#{System.unique_integer()}@example.com"

  def unique_user_name, do: "user#{System.unique_integer()}"
  def valid_user_password, do: "hello world! 11"

  def valid_user_attributes(attrs \\ %{}) do
    Enum.into(attrs, %{
      email: unique_user_email(),
      password: valid_user_password(),
      name: unique_user_name(),
      role: :admin
    })
  end

  def user_fixture(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> valid_user_attributes()
      |> CaseManager.Accounts.register_user()

    user
  end

  def extract_user_token(fun) do
    {:ok, captured_email} = fun.(&"[TOKEN]#{&1}[TOKEN]")
    [_, token | _] = String.split(captured_email.text_body, "[TOKEN]")
    token
  end
end
