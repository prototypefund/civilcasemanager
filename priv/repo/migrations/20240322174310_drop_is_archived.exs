defmodule Events.Repo.Migrations.DropIsArchived do
  use Ecto.Migration

  def change do
    # Drop the is_archived column from the cases table
    alter table(:cases) do
      remove :is_archived
    end
  end
end
