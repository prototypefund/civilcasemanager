defmodule Events.Repo.Migrations.RenameTimes do
  use Ecto.Migration

  def change do
    rename table(:events), :time_received, to: :received_at

    alter table(:events) do
      add :deleted_at, :utc_datetime, from: :datetime
      add :metadata, :string
    end
  end
end
