defmodule CaseManager.FetchManager do
  import CaseManager.Eventlog, only: [broadcast: 2]

  use GenServer
  alias CaseManager.Eventlog.Event
  alias CaseManager.Repo

  require Logger

  def start_link(opts) do
    GenServer.start_link(__MODULE__, opts, name: Keyword.get(opts, :name, __MODULE__))
  end

  @impl true
  def init(_opts) do
    {:ok, %{}}
  end

  @impl true
  def handle_cast({:new_event, event}, state) do
    Logger.info("Manager received a new event", event)

    # Convert the struct to a map before insertion
    event_map =
      event
      |> Map.from_struct()

    # Use Event.changeset/2 for insertion as before
    case %Event{} |> Event.changeset(event_map) |> Repo.insert() |> broadcast(:event_created) do
      {:ok, _event_inserted} ->
        Logger.info("Event successfully inserted into the database")

      {:error, changeset} ->
        Logger.error("Failed to insert event", changeset.errors)
    end

    {:noreply, state}
  end
end
