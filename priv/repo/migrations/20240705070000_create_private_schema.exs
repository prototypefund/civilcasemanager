defmodule CaseManager.Repo.Migrations.ImapToEmail do
  use Ecto.Migration

  def up do
    execute "CREATE SCHEMA IF NOT EXISTS private"
  end

  def down do
    execute "DROP SCHEMA private"
  end
end
