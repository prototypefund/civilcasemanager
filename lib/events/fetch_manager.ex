defmodule Events.FetchManager do
  import Events.Eventlog, only: [broadcast: 2]

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
    IO.inspect(event, label: "Manager received a new event")

    # Convert the struct to a map before insertion
    event_map =
      event
      |> Map.from_struct()

    # Use Event.changeset/2 for insertion as before
    case %Event{} |> Event.changeset(event_map) |> Repo.insert() |> broadcast(:event_created) do
      {:ok, _event_inserted} ->
        IO.puts("Event successfully inserted into the database")

      {:error, changeset} ->
        IO.inspect(changeset.errors, label: "Failed to insert event")
    end

    {:noreply, state}
  end
end
