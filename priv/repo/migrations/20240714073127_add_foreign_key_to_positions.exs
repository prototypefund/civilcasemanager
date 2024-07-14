defmodule CaseManager.Repo.Migrations.AddForeignKeyToPositions do
  use Ecto.Migration

  def up do
    ## FIXME: Discuss best strategy
    execute """
    UPDATE positions
    SET item_id = NULL
    WHERE item_id IS NOT NULL
    AND item_id NOT IN (SELECT id FROM cases)
    """

    alter table(:positions) do
      modify :item_id, references(:cases, on_delete: :nothing, type: :string), null: true
    end

    execute """
     CREATE INDEX IF NOT EXISTS item_id_idx ON positions (item_id);
    """
  end

  def down do
    alter table(:positions) do
      modify :item_id, :string, null: true
    end
  end
end
