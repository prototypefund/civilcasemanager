defmodule CaseManager.Repo.Migrations.ManualDefaultsToTrue do
  use Ecto.Migration

  def change do
    alter table(:case_manager) do
      modify :manual, :boolean, default: true, null: false
    end
  end
end
