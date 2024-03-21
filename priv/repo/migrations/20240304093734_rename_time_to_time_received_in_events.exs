defmodule Events.Repo.Migrations.RenameTimeToTimeReceivedInEvents do
  use Ecto.Migration

  def change do
    rename table(:events), :time, to: :time_received
    alter table(:events) do
      modify :time_received, :utc_datetime, from: :datetime
    end
  end
end
