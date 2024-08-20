defmodule CaseManager.Repo.Migrations.CreatePlaces do
  use Ecto.Migration

  def change do
    create table(:places, primary_key: false) do
      add :name, :string, primary_key: true
      add :country, :string
      add :sar_zone, :string
      add :lat, :decimal
      add :lon, :decimal
      add :type, :integer
    end

    alter table(:cases) do
      add :departure_key, references(:places, column: :name, type: :string)
      add :arrival_key, references(:places, column: :name, type: :string)
    end

    create unique_index(:places, [:name])
  end
end
