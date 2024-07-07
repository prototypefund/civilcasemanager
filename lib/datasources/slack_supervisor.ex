defmodule Events.Datasources.SlackSupervisor do

  use Supervisor


  def start_link(args) do
      Supervisor.start_link(__MODULE__, args, name: __MODULE__)
  end

  @impl true
  def init(args) do

    children = [
      {Slack.Supervisor, Keyword.put(args, :bot, Events.Datasources.SlackImporter)}
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end
end
