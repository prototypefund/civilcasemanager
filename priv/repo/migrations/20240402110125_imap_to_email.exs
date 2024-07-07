defmodule Events.Repo.Migrations.ImapToEmail do
  use Ecto.Migration

  def up do
    # Updates 'type' from 'imap' to 'email' for all records in the 'cases' table
    execute "UPDATE events SET type = 'email' WHERE type = 'imap'"
  end

  def down do
    execute "UPDATE events SET type = 'imap' WHERE type = 'email'"
  end
end
