defmodule CaseManager.Repo.Migrations.EventTime do
  use Ecto.Migration

  def change do
    alter table(:case_manager) do
      add :manual, :boolean, default: false
    end
  end
end
