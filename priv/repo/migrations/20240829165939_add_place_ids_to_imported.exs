defmodule CaseManager.Repo.Migrations.AddPlaceIdsToImported do
  use Ecto.Migration

  def change do
    alter table(:imported_cases) do
      add :arrival_id, references(:places, column: :id, type: :id)
      add :departure_id, references(:places, column: :id, type: :id)
    end
  end
end
