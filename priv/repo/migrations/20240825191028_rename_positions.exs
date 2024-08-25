defmodule CaseManager.Repo.Migrations.RenamePositions do
  use Ecto.Migration

  def change do
    rename table(:positions), to: table(:case_positions)
  end
end
