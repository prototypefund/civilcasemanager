defmodule CaseManager.Repo.Migrations.CreatePlaces do
  use Ecto.Migration

  def change do
    create table(:places) do
      add :name, :string
      add :country, :string
      add :sar_zone, :string
      add :lat, :decimal
      add :lon, :decimal
      add :type, :integer
    end

    alter table(:cases) do
      add :departure_id, references(:places, column: :id)
      add :arrival_id, references(:places, column: :id)
    end

    create unique_index(:places, [:name, :country])
  end
end
