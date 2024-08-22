# credo:disable-for-this-file Credo.Check.Warning.IoInspect
defmodule CaseManager.DataQualityTools do
  import CaseManager.CaseNationalities
  alias CaseManager.Cases
  alias CaseManager.CaseNationalities.CaseNationality

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

  @doc """
  Splits a string in the format Countrycode:count,Countrycode:count into a list of CaseNationalities.

  ## Examples

      iex> split_nationalities("US:10,UK:5")
      {:ok, [%CaseNationality{country_code: "US", count: 10}, %CaseNationality{country_code: "UK", count: 5}]}

      iex> split_nationalities("US:-,UK:unknown")
      {:ok, [%CaseNationality{country_code: "US", count: nil}, %CaseNationality{country_code: "UK", count: nil}]}

      iex> split_nationalities("US:invalid")
      {:error, "Invalid count for country code US"}

      iex> split_nationalities("")
      {:ok, []}

  """
  def split_nationalities(nil), do: {:ok, []}
  def split_nationalities(""), do: {:ok, []}

  def split_nationalities(string) when is_binary(string) do
    result =
      string
      |> String.split(";")
      |> Enum.map(&parse_individual_nationality/1)
      |> Enum.reduce_while({:ok, []}, fn
        {:ok, nationality}, {:ok, acc} -> {:cont, {:ok, [nationality | acc]}}
        {:error, reason}, _ -> {:halt, {:error, reason}}
      end)

    case result do
      {:ok, nationalities} -> {:ok, Enum.reverse(nationalities)}
      error -> error
    end
  end

  defp parse_individual_nationality(string) do
    case String.split(string, ":") do
      [country_code, count] when byte_size(country_code) == 2 ->
        create_nationality_struct(country_code, count)

      _ ->
        {:error, "Invalid format: #{string}"}
    end
  end

  defp parse_int_with_null(count) do
    case count do
      "x" ->
        nil

      "" ->
        nil

      "-" ->
        nil

      "unknown" ->
        nil

      _ ->
        case Integer.parse(count) do
          {int_count, ""} -> int_count
          _ -> {:error, "Cannot parse #{count} into a number."}
        end
    end
  end

  defp create_nationality_struct(country_code, count) do
    parsed_int = parse_int_with_null(count)

    case parsed_int do
      {:error, _} = error -> error
      parsed_int -> {:ok, %CaseNationality{country: country_code, count: parsed_int}}
    end
  end

  def fixup_nationality_strings(case_id \\ nil) do
    Logger.info("Fixing Nationality Strings")

    query =
      CaseManager.Cases.Case
      |> where([c], not is_nil(c.pob_per_nationality))

    query = if case_id, do: query |> where([c], c.id == ^case_id), else: query

    cases = CaseManager.Repo.all(query)

    Logger.info("Found #{length(cases)} cases")

    Enum.each(cases, fn case ->
      case split_nationalities(case.pob_per_nationality) do
        {:ok, nationalities} ->
          insert_nationalities(case.id, nationalities)

        {:error, msg} ->
          Logger.error("Error on case #{case.id}: #{inspect(msg)}")
      end
    end)
  end

  def insert_nationalities(case, nationalities) do
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

  def fixup_departure_regions(case_id \\ nil) do
    Logger.info("Fixing Departure Regions")

    departure_regions =
      CaseManager.Places.valid_departure_regions() |> Enum.reject(&(&1 == :unknown))

    Logger.info("Known departure regions: #{inspect(departure_regions)}")

    query =
      CaseManager.Cases.Case
      |> where([c], not is_nil(c.place_of_departure) and is_nil(c.departure_region))

    query = if case_id, do: query |> where([c], c.id == ^case_id), else: query

    cases = CaseManager.Repo.all(query)

    Logger.info("Found #{length(cases)} potential cases")

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

        Logger.info("Matched #{case.id} to #{departure_region}")
      else
        Logger.warning("No region could be matched for #{case.id}: #{case.place_of_departure}")
      end
    end)
  end

  def clear_unknown_places(case_id \\ nil) do
    Logger.info("Clearing Unknown Places")
    unknown_values = ["unknown", "", "permanently unknown"]

    query =
      from(c in CaseManager.Cases.Case,
        where: fragment("LOWER(TRIM(?))", c.place_of_disembarkation) in ^unknown_values
      )

    query = if case_id, do: query |> where([c], c.id == ^case_id), else: query

    disembarkation_count =
      query |> CaseManager.Repo.update_all(set: [place_of_disembarkation: nil])

    Logger.info("Found #{elem(disembarkation_count, 0)} unknown places of disembarkation")

    query =
      from(c in CaseManager.Cases.Case,
        where: fragment("LOWER(TRIM(?))", c.place_of_departure) in ^unknown_values
      )

    query = if case_id, do: query |> where([c], c.id == ^case_id), else: query

    departure_count = query |> CaseManager.Repo.update_all(set: [place_of_departure: nil])

    Logger.info("Found #{elem(departure_count, 0)} unknown places of departure")
  end

  @correction_map %{
    "Abu Kammashsh" => "Abu Kammash",
    "Al Khoms" => "al-Khums",
    "Al Khums" => "al-Khums",
    "Al-Khums" => "al-Khums",
    "Al-Maya" => "al-Maya",
    "Al-Zawiya" => "Zawiyah",
    "Alalus" => "Alaluas",
    "Calabria" => "Reggio Calabria",
    "Beghazi" => "Benghazi",
    "Bengazi" => "Benghazi",
    "Darnah" => "Darna",
    "Garabouli" => "Garabulli",
    "Garabulli/Castelverde" => "Garabulli",
    "Garibuli" => "Garabulli",
    "Izmir Turkey" => "Izmir",
    "Izmir, Turkey" => "Izmir",
    "Khoms" => "al-Khums",
    "Lamepdusa" => "Lampedusa",
    "Lampeudsa" => "Lampedusa",
    "LMP" => "Lampedusa",
    "Misrata" => "Misratah",
    "MALTA" => "Malta",
    "Rocella" => "Roccella Ionica",
    "Sabratah" => "Sabratah",
    "SABRATAH" => "Sabratah",
    "Sabratah/Zuwarah" => "Sabratah",
    "Sabratha" => "Sabratah",
    "Sabrathah" => "Sabratah",
    "Sfax, Tunisia" => "Sfax",
    "Skikda Algeria" => "Skikda",
    "Skikda" => "Skikda",
    "Smirne TURKY" => "Izmir",
    "Tajoura" => "Tajura",
    "Tipoli" => "Tripoli",
    "Tripolis" => "Tripoli",
    "Zarsis, Tunisia" => "Zarsis",
    "Zarzis" => "Zarsis",
    "Zawiya" => "Zawiyah",
    "Zuwara" => "Zuwarah",
    "ZUWARAH" => "Zuwarah"
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
      Logger.warning("Place not found: #{place_name}")
    end
  end

  def migrate_places(case_id \\ nil) do
    Logger.info("Migrating places to references")

    query =
      from c in CaseManager.Cases.Case,
        where: not is_nil(c.place_of_departure),
        select: {c.id, c.place_of_departure}

    query = if case_id, do: query |> where([c], c.id == ^case_id), else: query

    departure_cases = CaseManager.Repo.all(query)

    Logger.info("Found #{length(departure_cases)} departure cases")
    update_place_reference(departure_cases, :place_of_departure, :departure_id)

    query =
      from c in CaseManager.Cases.Case,
        where: not is_nil(c.place_of_disembarkation),
        select: {c.id, c.place_of_disembarkation}

    query = if case_id, do: query |> where([c], c.id == ^case_id), else: query

    disembarkation_cases = CaseManager.Repo.all(query)

    update_place_reference(disembarkation_cases, :place_of_disembarkation, :arrival_id)
  end
end
