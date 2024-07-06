defmodule CaseManager.Repo.Migrations.ImapToEmail do
  use Ecto.Migration

  def up do
    execute "UPDATE events SET type = 'email' WHERE type = 'imap'"
  end

  def down do
    execute "UPDATE events SET type = 'imap' WHERE type = 'email'"
  end
end
