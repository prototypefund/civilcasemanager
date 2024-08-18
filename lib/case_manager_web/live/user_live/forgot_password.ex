defmodule CaseManagerWeb.UserLive.ForgotPassword do
  use CaseManagerWeb, :live_view

  def render(assigns) do
    ~H"""
    <div class="mx-auto max-w-sm">
      <.header class="text-center">
        Forgot your password?
        <:subtitle>Please contact the adminstration team to receive a new password.</:subtitle>
      </.header>

      <p class="text-center text-sm mt-4">
        <.link href={~p"/users/log_in"}>Return to Log in</.link>
      </p>
    </div>
    """
  end

  def mount(_params, _session, socket) do
    {:ok, socket}
  end
end
