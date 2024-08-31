defmodule CaseManager.Repo.Migrations.AddAlertedFields do
  use Ecto.Migration

  def change do
    rename table(:cases), :authorities_alerted, to: :authorities_alerted_old

    alter table(:cases) do
      add :alerted_at, :timestamp
      add :alerted_by, :text
      add :authorities_alerted, :text
    end

    execute "UPDATE cases SET authorities_alerted = 'yes' WHERE authorities_alerted_old = true"

    alter table(:cases) do
      remove :authorities_alerted_old
    end
  end
end
