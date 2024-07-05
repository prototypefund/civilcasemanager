defmodule EventsWeb.Router do
  use EventsWeb, :router

  import EventsWeb.UserLive.Auth

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {EventsWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :fetch_current_user
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  ## Routes that require logged-in
    scope "/", EventsWeb do
    pipe_through [:browser, :require_authenticated_user]

    live_session :require_authenticated_user,
      on_mount: [{EventsWeb.UserLive.Auth, :ensure_authenticated}] do

      live "/events", EventLive.Index, :index
      live "/events/new", EventLive.Index, :new
      live "/events/:id/edit", EventLive.Index, :edit

      live "/events/:id", EventLive.Show, :show
      live "/events/:id/show/edit", EventLive.Show, :edit

      live "/", CaseLive.Index, :index
      live "/cases", CaseLive.Index, :index
      live "/cases/new", CaseLive.Index, :new
      live "/cases/:id/edit", CaseLive.Index, :edit

      live "/cases/:id", CaseLive.Show, :show
      live "/cases/:id/show/edit", CaseLive.Show, :edit

      ## FIXME Make permission to create new accounts more granular
      live "/users", UserLive.Index, :index
      live "/users/settings", UserLive.Settings, :edit
      live "/users/settings/confirm_email/:token", UserLive.Settings, :confirm_email
    end
  end

  ## Routes that require logged-out
  scope "/", EventsWeb do
    pipe_through [:browser, :redirect_if_user_is_authenticated]

    live_session :redirect_if_user_is_authenticated,
      on_mount: [{EventsWeb.UserLive.Auth, :redirect_if_user_is_authenticated}] do
      live "/users/register", UserLive.Registration, :new

      live "/users/log_in", UserLive.Login, :new
      live "/users/reset_password", UserLive.ForgotPassword, :new
      live "/users/reset_password/:token", UserLive.ResetPassword, :edit
    end

    post "/users/log_in", UserLive.SessionController, :create
  end



  scope "/", EventsWeb do
    pipe_through [:browser]

    delete "/users/log_out", UserSessionController, :delete

    live_session :current_user,
      on_mount: [{EventsWeb.UserLive.Auth, :mount_current_user}] do
      live "/users/confirm/:token", UserConfirmationLive, :edit
      live "/users/confirm", UserConfirmationInstructionsLive, :new
    end
  end


  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:events, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: EventsWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
