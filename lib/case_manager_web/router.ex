defmodule CaseManagerWeb.Router do
  use CaseManagerWeb, :router

  import CaseManagerWeb.UserLive.Auth

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {CaseManagerWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :fetch_current_user
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  ## Routes that require admin users
  scope "/", CaseManagerWeb do
    pipe_through [:browser, :require_admin_user]

    live_session :require_admin_user,
      on_mount: [{CaseManagerWeb.UserLive.Auth, :ensure_admin}] do
      live "/users", UserLive.Index, :index
      live "/users/new", UserLive.Index, :new
      live "/users/:id/edit", UserLive.Index, :edit
      live "/maintenance", MaintenanceLive
    end
  end

  ## Routes that require logged-in
  scope "/", CaseManagerWeb do
    pipe_through [:browser, :require_authenticated_user]

    live_session :require_authenticated_user,
      on_mount: [{CaseManagerWeb.UserLive.Auth, :ensure_authenticated}] do
      live "/", CaseLive.Index, :index

      live "/cases", CaseLive.Index, :index
      live "/cases/new", CaseLive.Index, :new
      live "/cases/:id/edit", CaseLive.Index, :edit
      live "/cases/:id", CaseLive.Show, :show
      live "/cases/:id/show/edit", CaseLive.Edit, :edit

      live "/events", EventLive.Index, :index
      live "/events/new", EventLive.Index, :new
      live "/events/:id/edit", EventLive.Index, :edit
      live "/events/:id", EventLive.Show, :show
      live "/events/:id/show/edit", EventLive.Show, :edit

      live "/positions", PositionLive.Index, :index
      live "/positions/new", PositionLive.Index, :new
      live "/positions/:id/edit", PositionLive.Index, :edit
      live "/positions/:id", PositionLive.Show, :show
      live "/positions/:id/show/edit", PositionLive.Show, :edit

      live "/passengers", PassengerLive.Index, :index
      live "/passengers/new", PassengerLive.Index, :new
      live "/passengers/:id/edit", PassengerLive.Index, :edit

      live "/passengers/:id", PassengerLive.Show, :show
      live "/passengers/:id/show/edit", PassengerLive.Show, :edit

      live "/imported_cases", ImportedCaseLive.Index, :index
      live "/imported_cases/upload", ImportedCaseLive.Upload, :new
      live "/imported_cases/:id/validate", ImportedCaseLive.Validate, :import

      live "/places", PlaceLive.Index, :index
      live "/places/new", PlaceLive.Index, :new
      live "/places/:id/edit", PlaceLive.Index, :edit

      live "/places/:id", PlaceLive.Show, :show
      live "/places/:id/show/edit", PlaceLive.Show, :edit

      live "/users/settings", UserLive.Settings, :show
      live "/users/settings/confirm_email/:token", UserLive.Settings, :confirm_email
    end
  end

  ## Routes that require logged-out
  scope "/", CaseManagerWeb do
    pipe_through [:browser, :redirect_if_user_is_authenticated]

    live_session :redirect_if_user_is_authenticated,
      on_mount: [{CaseManagerWeb.UserLive.Auth, :redirect_if_user_is_authenticated}] do
      live "/users/log_in", UserLive.Login, :new
      live "/users/reset_password", UserLive.ForgotPassword, :new
    end

    post "/users/log_in", UserLive.SessionController, :create
  end

  ## Doesn't require logged-in
  scope "/", CaseManagerWeb do
    pipe_through [:browser]

    delete "/users/log_out", UserLive.SessionController, :delete
  end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:case_manager, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: CaseManagerWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
