defmodule CaseManager.Repo.Migrations.PlacesClearUnknowns do
  use Ecto.Migration

  def change do
    execute """
    UPDATE cases
    SET place_of_disembarkation = NULL
    WHERE LOWER(TRIM(place_of_disembarkation)) IN (LOWER('unknown'), LOWER(''), LOWER('permanently unknown'));
    """

    execute """
    UPDATE cases
    SET place_of_departure = NULL
    WHERE LOWER(TRIM(place_of_departure)) IN (LOWER('unknown'), LOWER(''), LOWER('permanently unknown'));;
    """
  end
end
