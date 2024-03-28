defmodule Events.FetchManager do
  import Events.Eventlog, only: [broadcast: 2]
  import Events.Cases, only: [
    create_case: 1,
    get_case_by_identifier: 1,
    get_combined_identifier: 1
  ]

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

    # Convert the struct to a map before insertion
    event_map = event
      |> Map.from_struct()


    # If we have a case_data field, create the necessary case
    event_map = event_map
      |> Map.put(:case_data, normalize_case_data(event_map[:case_data]))
      |> create_case_on_the_fly()


    # Use Event.changeset/2 for insertion as before
    case %Event{} |> Event.changeset(event_map) |> Repo.insert() |> broadcast(:event_created) do
      {:ok, _event_inserted} ->
        IO.puts("Event successfully inserted into the database")
      {:error, changeset} ->
        IO.inspect(changeset.errors, label: "Failed to insert event")
    end

    {:noreply, state}
  end

  defp create_case_on_the_fly(event_map) do
    case_data = event_map[:case_data]
    existing_case = get_case_by_identifier(case_data[:identifier])

    case existing_case do
      nil ->
        Map.put(event_map, :case_id, create_case_from_case_data(case_data).id)
      _ ->
        event_map
    end
  end

  def normalize_case_data(nil) do
    nil
  end

  def normalize_case_data(case_data) do
    case String.split(case_data[:identifier],"-") do
      [_, _] -> case_data
      _ -> Map.put(case_data, :identifier, get_combined_identifier(case_data))
    end
  end


  defp create_case_from_case_data(case_data) do
    # TODO: Potential race condition
    {:ok, case} = create_case(
      %{
        identifier: case_data[:identifier],
        created_at: case_data[:created_at],
        title: case_data[:additional]
      }
    )
    case
  end

end
