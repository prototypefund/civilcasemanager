defmodule CaseManager.Repo.Migrations.CreateCasesEvents do
  use Ecto.Migration

  def change do
    create table(:cases_events, primary_key: false) do
      add :case_id, references(:cases, on_delete: :delete_all, type: :string), null: false
      add :event_id, references(:events, on_delete: :delete_all), null: false

      timestamps()
    end

    create unique_index(:cases_events, [:case_id, :event_id])
  end
end
