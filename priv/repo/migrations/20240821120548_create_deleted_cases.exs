defmodule CaseManager.Repo.Migrations.CreateDeletedCases do
  use Ecto.Migration

  def change do
    create table(:deleted_cases, primary_key: false) do
      add :id, :string, primary_key: true

      timestamps(type: :utc_datetime, inserted_at: :deleted_at, updated_at: false)
    end
  end
end
