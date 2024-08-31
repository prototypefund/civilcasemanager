defmodule CaseManager.Repo.Migrations.DeleteAllPositions do
  use Ecto.Migration

  def change do
    alter table(:case_positions) do
      modify :item_id, references(:cases, on_delete: :delete_all, type: :string)
      add :updated_at, :utc_datetime
      add :inserted_at, :utc_datetime
    end
  end
end
