defmodule Events.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      EventsWeb.Telemetry,
      Events.Repo,
      {DNSCluster, query: Application.get_env(:events, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Events.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: Events.Finch},
      # Start the FetchCoordinator
      {Events.FetchManager, name: :fetch_manager},
      {Events.FetchSupervisor, supervisor_opts()},
      # Start to serve requests, typically the last entry
      EventsWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Events.Supervisor]
    Supervisor.start_link(children, opts)
  end

  def supervisor_opts do
    ## TODO: Remove pid from her (is nil!!)
    manager_pid = Process.whereis(:fetch_manager)
    worker_configs = Application.get_env(:events, :worker_configs, [])
    [manager_pid: Process.whereis(:fetch_manager), worker_configs: worker_configs]
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    EventsWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
