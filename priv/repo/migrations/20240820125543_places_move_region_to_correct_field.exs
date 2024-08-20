defmodule CaseManager.Repo.Migrations.PlacesMoveRegionToCorrectField do
  use Ecto.Migration

  def change do
    departure_regions =
      CaseManager.Places.valid_departure_regions() |> Enum.reject(&(&1 == :unknown))

    execute """
    WITH subquery AS (
      SELECT id, place_of_departure
      FROM cases
      WHERE place_of_departure IS NOT NULL
        AND departure_region IS NULL
    )
    UPDATE cases
    SET departure_region = (
        SELECT dr.region
        FROM unnest(ARRAY[#{Enum.map_join(departure_regions, ", ", fn region -> "'#{region}'" end)}]) AS dr(region)
        WHERE TRIM(UPPER(subquery.place_of_departure)) = UPPER(dr.region)
        LIMIT 1
      ),
      place_of_departure = NULL
    FROM subquery
    WHERE cases.id = subquery.id
      AND EXISTS (
        SELECT 1
        FROM unnest(ARRAY[#{Enum.map_join(departure_regions, ", ", fn region -> "'#{region}'" end)}]) AS dr(region)
        WHERE TRIM(UPPER(subquery.place_of_departure)) = UPPER(dr.region)
      )
    """
  end
end
