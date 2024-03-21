defmodule Events.Datasources.IMAPSupervisor do

  use Supervisor


  def start_link(args) do
      Supervisor.start_link(__MODULE__, args, name: __MODULE__)
  end

  @impl true
  def init(args) do
    children = [
      %{
        id: :YUGOCLIENT,
        start: {Yugo.Client, :start_link, [args]},
        restart: :temporary,
        type: :worker
      },
      %{
        id: :IMAPWORKER,
        start: {Events.Datasources.IMAPWorker, :start_link, [args]},
        restart: :permanent,
        type: :worker
      }
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end
end
