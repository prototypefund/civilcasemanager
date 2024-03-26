defmodule Events.Datasources.IMAPSupervisor do
  def event_type, do: "imap"
  def icon_class, do: "hero-envelope-solid"
  def color, do: "blue"

  use Supervisor

  def start_link(args) do
      Supervisor.start_link(__MODULE__, args, name: args[:name])
  end

  @impl true
  def init(args) do
    children = [
      %{
        id: get_unique_id(args[:name], "_YUGO"),
        start: {Yugo.Client, :start_link, [args]},
        restart: :temporary,
        type: :worker
      },
      %{
        id: get_unique_id(args[:name], "_IMAPWORKER"),
        start: {Events.Datasources.IMAPWorker, :start_link, [args]},
        restart: :permanent,
        type: :worker
      }
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end

  defp get_unique_id(atom, suffix) do
    String.to_atom(Atom.to_string(atom) <> suffix)
  end
end
