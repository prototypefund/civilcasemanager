defmodule CaseManager.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      CaseManagerWeb.Telemetry,
      CaseManager.Repo,
      {DNSCluster, query: Application.get_env(:case_manager, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: CaseManager.PubSub},
      {EctoWatch,
       repo: CaseManager.Repo,
       pub_sub: CaseManager.PubSub,
       watchers: [
         {CaseManager.Cases.Case, :inserted}
       ]},
      CaseManager.DataQualityService,
      # Start the Finch HTTP client for sending emails
      {Finch, name: CaseManager.Finch},
      # Start the FetchCoordinator
      {CaseManager.FetchManager, name: :fetch_manager},
      {CaseManager.FetchSupervisor, supervisor_opts()},
      # Start to serve requests, typically the last entry
      CaseManagerWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [
      strategy: :one_for_one,
      name: CaseManager.Supervisor,
      max_restarts: 5,
      max_seconds: 10
    ]

    Supervisor.start_link(children, opts)
  end

  def supervisor_opts do
    Application.get_env(:case_manager, :worker_configs, [])
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    CaseManagerWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
