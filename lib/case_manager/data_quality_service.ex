defmodule CaseManager.DataQualityService do
  use GenServer
  require Logger
  alias CaseManager.Cases
  alias CaseManager.Cases.Case
  import CaseManager.DataQualityTools

  def start_link(_) do
    GenServer.start_link(__MODULE__, %{})
  end

  def init(state) do
    Logger.info("DataQualityService started")
    EctoWatch.subscribe({Case, :inserted})
    {:ok, state}
  end

  def handle_info({{Case, :inserted}, %{id: id}}, state) do
    case = Cases.get_case!(id)

    if case.imported_from == "onefleet" do
      Logger.info("New case inserted: #{case.id}")
      fixup_nationality_strings(case.id)
      fixup_departure_regions(case.id)
      clear_unknown_places(case.id)
      migrate_places(case.id)
    end

    # Add your logic here to handle the newly inserted case
    {:noreply, state}
  end
end
