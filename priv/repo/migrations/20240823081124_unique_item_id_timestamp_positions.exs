defmodule CaseManager.Repo.Migrations.UniqueItemIdTimestampPositions do
  use Ecto.Migration

  def change do
    create unique_index(:positions, [:item_id, :timestamp])
  end
end
