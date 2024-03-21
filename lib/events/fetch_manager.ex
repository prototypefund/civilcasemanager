defmodule Events.FetchManager do
  use GenServer
  alias Events.Eventlog.Event
  alias Events.Repo

  def start_link(opts) do
    GenServer.start_link(__MODULE__, opts, name: Keyword.get(opts, :name, __MODULE__))
  end

  @impl true
  def init(_opts) do
    {:ok, %{}}
  end

  @impl true
  def handle_cast({:new_event, event}, state) do
    IO.puts("Manager received a new event with title: #{event.from}")
    IO.inspect(event)

    # Convert the struct to a map before insertion
    event_map = event
      |> Map.from_struct()
      |> Map.put(:manual, false)

    # Use Event.changeset/2 for insertion as before
    case %Event{} |> Event.changeset(event_map) |> Repo.insert() |> broadcast(:event_created) do
      {:ok, _event_inserted} ->
        IO.puts("Event successfully inserted into the database")
      {:error, changeset} ->
        IO.inspect(changeset.errors, label: "Failed to insert event")
    end

    {:noreply, state}
  end

  ## TODO: Duplicated function from eventlog.ex
  defp broadcast({:error, changeset}, _change_type), do: {:error, changeset}
  defp broadcast({:ok, event}, change_type) do
    Phoenix.PubSub.broadcast(Events.PubSub, "events", {change_type, event})
    {:ok, event}
  end
end
