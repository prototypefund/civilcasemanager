defmodule Events.Repo.Migrations.CreateCases do
  use Ecto.Migration

  def change do
    create table(:cases) do
      add :identifier, :string
      add :title, :string
      add :description, :string
      add :created_at, :utc_datetime
      add :deleted_at, :utc_datetime
      add :opened_at, :utc_datetime
      add :closed_at, :utc_datetime
      add :archived_at, :utc_datetime
      add :is_archived, :boolean, default: false, null: false
      add :status, :string
      add :status_note, :string

      timestamps(type: :utc_datetime)
    end
  end
end
