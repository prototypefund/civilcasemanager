defmodule CaseManager.Repo.Migrations.ManualDefaultsToTrue do
  use Ecto.Migration

  def change do
    alter table(:events) do
      modify :manual, :boolean, default: true, null: false
    end
  end
end
