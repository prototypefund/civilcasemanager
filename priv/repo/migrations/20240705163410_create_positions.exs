defmodule CaseManager.Repo.Migrations.CreatePositions do
  use Ecto.Migration

  def up do
    execute "CREATE EXTENSION IF NOT EXISTS postgis"

    create table(:case_positions, primary_key: false) do
      add :id, :text, primary_key: true
      add :item_id, :string, null: true
      add :altitude, :decimal
      add :course, :decimal
      add :heading, :decimal
      add :lat, :decimal
      add :lon, :decimal
      add :source, :text
      add :speed, :decimal
      add :timestamp, :utc_datetime_usec
      add :imported_from, :text
      add :soft_deleted, :boolean, default: false, null: false
      add :pos_geo, :geometry
    end

    create index(:case_positions, [:item_id])
    create unique_index(:case_positions, [:item_id, :timestamp])
  end

  def down do
    drop table(:case_positions)
    execute "DROP EXTENSION IF EXISTS postgis"
  end
end
