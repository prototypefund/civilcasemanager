defmodule CaseManager.Repo.Migrations.DropManual do
  use Ecto.Migration

  def change do
    # Drop the is_archived column from the cases table
    alter table(:events) do
      remove :manual
    end
  end
end
