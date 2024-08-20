defmodule CaseManager.Repo.Migrations.NationalitiesData do
  use Ecto.Migration

  use Ecto.Migration
  import Ecto.Query
  import CaseManager.CaseNationalities

  def up do
    # Query all cases using raw SQL
    {:ok, %{rows: cases}} =
      Ecto.Adapters.SQL.query(
        CaseManager.Repo,
        "SELECT id, pob_per_nationality FROM cases WHERE pob_per_nationality IS NOT NULL"
      )

    for [case_id, pob_per_nationality] <- cases do
      # Parse the pob_per_nationality string
      result = split_nationalities(pob_per_nationality)

      case result do
        {:ok, nationalities} ->
          Enum.each(nationalities, fn nationality ->
            # Insert entries into case_nationalities table using raw SQL
            Ecto.Adapters.SQL.query(
              CaseManager.Repo,
              "INSERT INTO case_nationalities (country, count, case_id) VALUES ($1, $2, $3)",
              [nationality.country, nationality.count, case_id]
            )
          end)

          # Set the pob_per_nationality field to null if parsing was successful
          Ecto.Adapters.SQL.query(
            CaseManager.Repo,
            "UPDATE cases SET pob_per_nationality = NULL WHERE id = $1",
            [case_id]
          )

        {:error, _} ->
          nil
      end
    end
  end

  def down do
    # If needed, you can implement a down migration to reverse this process
  end
end
