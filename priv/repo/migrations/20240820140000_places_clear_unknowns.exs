defmodule CaseManager.Repo.Migrations.PlacesClearUnknowns do
  use Ecto.Migration

  def change do
    execute """
    UPDATE cases
    SET place_of_disembarkation = NULL
    WHERE LOWER(place_of_disembarkation) = 'unknown' OR place_of_disembarkation = '' OR place_of_disembarkation = 'permanently unknown';
    """

    execute """
    UPDATE cases
    SET place_of_departure = NULL
    WHERE LOWER(place_of_departure) = 'unknown' OR place_of_departure = '' OR place_of_departure = 'permanently unknown';
    """
  end
end
