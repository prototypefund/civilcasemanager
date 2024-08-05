defmodule CaseManager.Repo.Migrations.CaseEngineFailureToBoolean do
  use Ecto.Migration

  def change do
    alter table(:cases) do
      remove :boat_engine_working
      add :boat_engine_working, :boolean
    end

    alter table(:imported_cases) do
      remove :boat_engine_working
      add :boat_engine_working, :boolean
    end
  end
end
