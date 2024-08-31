defmodule CaseManager.Repo.Migrations.AddImportedAlertedFields do
  use Ecto.Migration

  def change do
    alter table(:imported_cases) do
      remove :authorities_alerted
      add :alerted_at, :timestamp
      add :alerted_by, :text
      add :authorities_alerted, :text
    end
  end
end
