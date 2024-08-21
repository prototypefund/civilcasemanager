defmodule CaseManager.Repo.Migrations.AddPlaceId do
  use Ecto.Migration

  def up do
    # Add id column to places
    alter table(:places) do
      add :id, :bigserial
    end

    create unique_index(:places, [:id])

    # Update foreign keys in cases table
    execute "ALTER TABLE cases ADD COLUMN departure_id bigint"

    execute "UPDATE cases SET departure_id = places.id FROM places WHERE cases.departure_key = places.name"

    execute "ALTER TABLE cases DROP COLUMN departure_key"

    execute "ALTER TABLE cases ADD COLUMN arrival_id bigint"

    execute "UPDATE cases SET arrival_id = places.id FROM places WHERE cases.arrival_key = places.name"

    execute "ALTER TABLE cases DROP COLUMN arrival_key"

    execute "ALTER TABLE cases ADD CONSTRAINT fk_arrival_place FOREIGN KEY (arrival_id) REFERENCES places(id)"

    execute "ALTER TABLE cases ADD CONSTRAINT fk_departure_place FOREIGN KEY (departure_id) REFERENCES places(id)"

    # Drop the old primary key and set the new id column as primary key
    execute "ALTER TABLE places DROP CONSTRAINT places_pkey"
    execute "ALTER TABLE places ADD PRIMARY KEY (id)"

    # Replace unique constraint on name with a combined constraint on name and country
    drop unique_index(:places, [:name])
    create unique_index(:places, [:name, :country])
  end
end
