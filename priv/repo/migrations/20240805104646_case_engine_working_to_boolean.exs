defmodule CaseManager.Repo.Migrations.CaseEngineFailureToBoolean do
  use Ecto.Migration

  def change do
    execute "CREATE TYPE tristate AS ENUM ('yes', 'no', 'unknown')"

    alter table(:cases) do
      remove :boat_engine_working
      add :boat_engine_working, :tristate
    end

    alter table(:imported_cases) do
      remove :boat_engine_working
      add :boat_engine_working, :string
    end
  end
end
