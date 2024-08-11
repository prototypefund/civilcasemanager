defmodule CaseManager.Repo.Migrations.RenameEngineWorkingToEngineFailure do
  use Ecto.Migration

  def change do
    rename table(:cases), :boat_engine_working, to: :boat_engine_failure
  end
end
