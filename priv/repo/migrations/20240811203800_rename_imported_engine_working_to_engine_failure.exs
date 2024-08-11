defmodule CaseManager.Repo.Migrations.RenamImportedEngineWorkingToEngineFailure do
  use Ecto.Migration

  def change do
    execute "ALTER TABLE imported_cases RENAME COLUMN boat_engine_working TO boat_engine_failure"
  end
end
