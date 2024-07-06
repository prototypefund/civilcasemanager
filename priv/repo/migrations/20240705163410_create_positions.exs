defmodule Events.Repo.Migrations.CreatePositions do
  use Ecto.Migration


  def change do
  # The tables are created for us
  #   create table(:positions) do
  #     add :id, :text
  #     add :altitude, :decimal
  #     add :course, :decimal
  #     add :heading, :decimal
  #     add :lat, :decimal
  #     add :lon, :decimal
  #     add :source, :text
  #     add :speed, :decimal
  #     add :timestamp, :utc_datetime
  #     add :imported_from, :text
  #     add :soft_deleted, :boolean, default: false, null: false
  #     add :pos_geo, :geometry
  #     add :item_id, references(:cases, on_delete: :nothing)
  #     timestamps(type: :utc_datetime)
  #   end

     create index(:positions, [:item_id])
  end
end
