defmodule CaseManager.Repo.Migrations.NationalitiesData do
  use Ecto.Migration

  use Ecto.Migration
  import Ecto.Query
  import CaseManager.CaseNationalities

  def up do
    # Query all cases
    cases = CaseManager.Repo.all(CaseManager.Cases.Case)

    for case <- cases do
      if case.pob_per_nationality do
        # Parse the pob_per_nationality string
        result = split_nationalities(case.pob_per_nationality)

        # Insert entries into case_nationalities table
        case result do
          {:ok, nationalities} ->
            Enum.each(nationalities, fn nationality ->
              CaseManager.Repo.insert(Map.put(nationality, :case_id, case.id))
            end)

            # Set the pob_per_nationality field to null if parsing was successful
            CaseManager.Repo.update_all(
              from(c in CaseManager.Cases.Case, where: c.id == ^case.id),
              set: [pob_per_nationality: nil]
            )

          {:error, _} ->
            nil
        end
      end
    end
  end

  def down do
    # If needed, you can implement a down migration to reverse this process
  end
end
