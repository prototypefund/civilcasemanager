# credo:disable-for-this-file Credo.Check.Warning.IoInspect
defmodule CaseManager.DataQualityTools do
  import CaseManager.CaseNationalities
  alias CaseManager.Cases

  use Ecto.Migration
  import Ecto.Query, warn: false
  require Logger

  def available_functions do
    [
      {:fixup_nationality_strings, "Fix Nationality Strings"},
      {:fixup_departure_regions, "Fix Departure Regions"},
      {:clear_unknown_places, "Clear Unknown Places"},
      {:migrate_places, "Migrate places to references"}
    ]
  end

  def fixup_nationality_strings do
    IO.inspect("Fixing Nationality Strings")

    cases =
      CaseManager.Cases.Case
      |> where([c], not is_nil(c.pob_per_nationality))
      |> CaseManager.Repo.all()

    IO.puts("Found #{length(cases)} cases")

    Enum.each(cases, fn case ->
      case split_nationalities(case.pob_per_nationality) do
        {:ok, nationalities} ->
          insert_nationalities(case.id, nationalities)

        {:error, msg} ->
          IO.inspect(msg, label: "Error on case #{case.id}")
      end
    end)
  end

  def insert_nationalities(case, nationalities) do
    ## TODO Use ecto multi or similar to rollback if one of the inserts fails
    Enum.each(nationalities, fn nationality ->
      create_case_nationality(%{
        country: nationality.country,
        count: nationality.count,
        case_id: case.id
      })
    end)

    Cases.update_case(case, %{pob_per_nationality: nil})
  end

  @correction_regions %{
    "Tunesia" => "Tunisia",
    "TUN" => "Tunisia"
  }

  defp fix_spelling_region(misspelled_name) do
    Map.get(@correction_regions, misspelled_name, misspelled_name)
  end

  def fixup_departure_regions do
    IO.inspect("Fixing Departure Regions")

    departure_regions =
      CaseManager.Places.valid_departure_regions() |> Enum.reject(&(&1 == :unknown))

    IO.inspect(departure_regions, label: "Known departure regions")

    cases =
      CaseManager.Cases.Case
      |> where([c], not is_nil(c.place_of_departure) and is_nil(c.departure_region))
      |> CaseManager.Repo.all()

    IO.inspect("Found #{length(cases)} potential cases")

    Enum.each(cases, fn case ->
      departure_region =
        Enum.find(departure_regions, fn region ->
          String.trim(String.upcase(fix_spelling_region(case.place_of_departure))) ==
            String.upcase(to_string(region))
        end)

      if departure_region do
        Cases.update_case(case, %{
          departure_region: departure_region,
          place_of_departure: nil
        })

        IO.puts("Matched #{case.id} to #{departure_region}")
      else
        IO.inspect(case.place_of_departure, label: "No region could be matched for #{case.id}")
      end
    end)
  end

  def clear_unknown_places() do
    IO.inspect("Clearing Unknown Places")
    unknown_values = ["unknown", "", "permanently unknown"]

    disembarkation_count =
      from(c in CaseManager.Cases.Case,
        where: fragment("LOWER(TRIM(?))", c.place_of_disembarkation) in ^unknown_values
      )
      |> CaseManager.Repo.update_all(set: [place_of_disembarkation: nil])

    IO.puts("Found #{elem(disembarkation_count, 0)} unknown places of disembarkation")

    departure_count =
      from(c in CaseManager.Cases.Case,
        where: fragment("LOWER(TRIM(?))", c.place_of_departure) in ^unknown_values
      )
      |> CaseManager.Repo.update_all(set: [place_of_departure: nil])

    IO.puts("Found #{elem(departure_count, 0)} unknown places of departure")
  end

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

  defp fix_spellings(misspelled_name) do
    Map.get(@correction_map, misspelled_name, misspelled_name)
  end

  defp update_place_reference(cases, old_field, new_field) do
    Enum.each(cases, fn {case_id, place_name} ->
      update_one_case(place_name, case_id, old_field, new_field)
    end)
  end

  defp update_one_case(place_name, case_id, old_field, new_field) do
    corrected_name = String.trim(place_name) |> fix_spellings()

    found_place =
      CaseManager.Repo.one(from p in CaseManager.Places.Place, where: p.name == ^corrected_name)

    if found_place do
      case = CaseManager.Repo.get!(CaseManager.Cases.Case, case_id)

      case
      |> Ecto.Changeset.change(%{old_field => nil, new_field => found_place.id})
      |> CaseManager.Repo.update()
    else
      IO.inspect("Place not found: #{place_name}")
    end
  end

  def migrate_places() do
    IO.inspect("Migrating places to references")

    departure_cases =
      CaseManager.Repo.all(
        from c in CaseManager.Cases.Case,
          where: not is_nil(c.place_of_departure),
          select: {c.id, c.place_of_departure}
      )

    IO.inspect("Found #{length(departure_cases)} departure cases")
    update_place_reference(departure_cases, :place_of_departure, :departure_id)

    disembarkation_cases =
      CaseManager.Repo.all(
        from c in CaseManager.Cases.Case,
          where: not is_nil(c.place_of_disembarkation),
          select: {c.id, c.place_of_disembarkation}
      )

    update_place_reference(disembarkation_cases, :place_of_disembarkation, :arrival_id)
  end
end
