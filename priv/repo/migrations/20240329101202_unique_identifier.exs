defmodule Events.Repo.Migrations.UniqueIdentifier do
  use Ecto.Migration

  # def change do
  #   create unique_index(:cases, [:identifier])
  # end

  def up do
    # Assuming `created_at` is available to determine the "first" record
    execute """
    DELETE FROM cases
    WHERE id NOT IN (
      SELECT min(id)
      FROM cases
      GROUP BY identifier
      HAVING count(*) > 1
    )
    AND identifier IN (
      SELECT identifier
      FROM cases
      GROUP BY identifier
      HAVING count(*) > 1
    )
    """

    # Now it's safe to add the unique index
    create unique_index(:cases, [:identifier])
  end

  def down do
    drop index(:cases, [:identifier])
    # No need to restore duplicates on rollback, but handle as needed
  end
end
