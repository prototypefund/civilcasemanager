defmodule CaseManager.Repo.Migrations.RenameTimeToTimeReceivedInEvents do
  use Ecto.Migration

  def change do
    alter table(:events) do
      remove :time
      add :time_received, :utc_datetime
    end
  end
end
