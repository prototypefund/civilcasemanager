defmodule CaseManager.Repo.Migrations.CreatePositions do
  use Ecto.Migration

  def up do
    execute """
    CREATE EXTENSION IF NOT EXISTS postgis;
    """

    execute """
    CREATE TABLE IF NOT EXISTS public.positions (
      id text PRIMARY KEY,
      item_id text NULL,
      altitude decimal NULL,
      course decimal NULL,
      heading decimal NULL,
      lat decimal NULL,
      lon decimal NULL,
      source text NULL,
      speed decimal NULL,
      timestamp timestamptz NULL,
      imported_from text NULL,
      soft_deleted boolean DEFAULT false NOT NULL,
      pos_geo geometry(Point,4326) NULL
    );
    """

    execute """
     CREATE INDEX IF NOT EXISTS item_id_idx ON positions (item_id);
    """
  end

  def down do
  end
end
