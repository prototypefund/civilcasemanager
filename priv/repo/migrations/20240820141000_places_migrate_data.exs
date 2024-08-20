defmodule CaseManager.Repo.Migrations.PlacesMigrateData do
  use Ecto.Migration
  require Logger

  @correction_map %{
    "LMP" => "Lampedusa",
    "Al-Maya" => "al-Maya",
    "Abu Kammashsh" => "Abu Kammash",
    "Al Khoms" => "al-Khums",
    "Al Khums" => "al-Khums",
    "Al-Khums" => "al-Khums",
    "Alalus" => "Alaluas",
    "Beghazi" => "Benghazi",
    "Bengazi" => "Benghazi",
    "Darnah" => "Darna",
    "Garabulli/Castelverde" => "Garabulli",
    "Garibuli" => "Garabulli",
    "Garabouli" => "Garabulli",
    "Izmir Turkey" => "Izmir",
    "Izmir, Turkey" => "Izmir",
    "Smirne TURKY" => "Izmir",
    "Khoms" => "al-Khums",
    "Sabratha" => "Sabratah",
    "Sabrathah" => "Sabratah",
    "SABRATAH" => "Sabratah",
    "Sfax, Tunisia" => "Sfax",
    "Tajoura" => "Tajura",
    "Tipoli" => "Tripoli",
    "Tripolis" => "Tripoli",
    "Zarsis, Tunisia" => "Zarsis",
    "Zarzis" => "Zarsis",
    "Zawiya" => "Zawiyah",
    "Zuwara" => "Zuwarah",
    "ZUWARAH" => "Zuwarah",
    "Al-Zawiya" => "Zawiyah",
    "Skikda Algeria" => "Skikda",
    "Skikda" => "Skikda",
    "Sabratah/Zuwarah" => "Sabratah",
    "Sabratah" => "Sabratah"
  }

  def fix_spellings(misspelled_name) do
    Map.get(@correction_map, misspelled_name, misspelled_name)
  end

  def update_place_reference(cases, old_field, new_field) do
    Enum.each(cases, fn [case_id, place_name] ->
      update_one_case(place_name, case_id, old_field, new_field)
    end)
  end

  def update_one_case(place_name, case_id, old_field, new_field) do
    corrected_name = String.trim(place_name) |> fix_spellings()

    {:ok, %{rows: [[place_count]]}} =
      Ecto.Adapters.SQL.query(CaseManager.Repo, "SELECT COUNT(*) FROM places WHERE name = $1", [
        corrected_name
      ])

    if place_count > 0 do
      Ecto.Adapters.SQL.query(
        CaseManager.Repo,
        "UPDATE cases SET #{old_field} = NULL, #{new_field} = $1 WHERE id = $2",
        [corrected_name, case_id]
      )
    else
      Logger.warning("Place not found: #{place_name}")
    end
  end

  def up do
    {:ok, %{rows: cases}} =
      Ecto.Adapters.SQL.query(
        CaseManager.Repo,
        "SELECT id, place_of_departure FROM cases WHERE place_of_departure IS NOT NULL"
      )

    update_place_reference(cases, "place_of_departure", "departure_key")

    {:ok, %{rows: cases}} =
      Ecto.Adapters.SQL.query(
        CaseManager.Repo,
        "SELECT id, place_of_disembarkation FROM cases WHERE place_of_disembarkation IS NOT NULL"
      )

    update_place_reference(cases, "place_of_disembarkation", "arrival_key")
  end
end
