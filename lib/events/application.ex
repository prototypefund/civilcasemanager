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
      {Events.FetchCoordinator, worker_configs()},
      # Start to serve requests, typically the last entry
      EventsWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Events.Supervisor]
    Supervisor.start_link(children, opts)
  end

  ## TODO Hard coded
  def worker_configs() do
    [{Events.IMAPFetcher, [server: "imap.riseup.net", username: "xxy", password: "zzz", name: :EXAMPLE]}]
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    EventsWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
