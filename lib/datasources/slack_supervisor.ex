defmodule CaseManager.Datasources.SlackSupervisor do
  def event_type, do: "slack"
  def icon_class, do: "hero-cube-transparent-solid"
  def color, do: "red"

  use Supervisor

  def start_link(args) do
    Supervisor.start_link(__MODULE__, args, name: __MODULE__)
  end

  @impl true
  def init(args) do
    children = [
      {Slack.Supervisor, Keyword.put(args, :bot, CaseManager.Datasources.SlackImporter)}
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end
end
