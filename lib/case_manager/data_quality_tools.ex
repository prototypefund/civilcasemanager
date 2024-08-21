defmodule CaseManager.DataQualityTools do
  import CaseManager.CaseNationalities
  alias CaseManager.Cases

  use Ecto.Migration
  import Ecto.Query, warn: false
  require Logger

  def fixup_nationality_strings do
    cases =
      CaseManager.Cases.Case
      |> where([c], not is_nil(c.pob_per_nationality))
      |> CaseManager.Repo.all()

    Enum.each(cases, fn case ->
      case split_nationalities(case.pob_per_nationality) do
        {:ok, nationalities} ->
          ## TODO Use ecto multi or similar to rollback if one of the inserts fails
          Enum.each(nationalities, fn nationality ->
            create_case_nationality(%{
              country: nationality.country,
              count: nationality.count,
              case_id: case.id
            })
          end)

          Cases.update_case(case, %{pob_per_nationality: nil})

        {:error, _} ->
          nil
      end
    end)
  end

  def fixup_departure_regions do
    departure_regions =
      CaseManager.Places.valid_departure_regions() |> Enum.reject(&(&1 == :unknown))

    cases =
      CaseManager.Cases.Case
      |> where([c], not is_nil(c.place_of_departure) and is_nil(c.departure_region))
      |> CaseManager.Repo.all()

    Enum.each(cases, fn case ->
      departure_region =
        Enum.find(departure_regions, fn region ->
          String.trim(String.upcase(case.place_of_departure)) == String.upcase(to_string(region))
        end)

      if departure_region do
        Cases.update_case(case, %{
          departure_region: departure_region,
          place_of_departure: nil
        })
      end
    end)
  end

  def clear_unknown_places() do
    unknown_values = ["unknown", "", "permanently unknown"]

    from(c in CaseManager.Cases.Case,
      where: fragment("LOWER(TRIM(?))", c.place_of_disembarkation) in ^unknown_values
    )
    |> CaseManager.Repo.update_all(set: [place_of_disembarkation: nil])

    from(c in CaseManager.Cases.Case,
      where: fragment("LOWER(TRIM(?))", c.place_of_departure) in ^unknown_values
    )
    |> CaseManager.Repo.update_all(set: [place_of_departure: nil])
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
    Enum.each(cases, fn [case_id, place_name] ->
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

  def migrate_places() do
    departure_cases =
      CaseManager.Repo.all(
        from c in CaseManager.Cases.Case,
          where: not is_nil(c.place_of_departure),
          select: {c.id, c.place_of_departure}
      )

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
