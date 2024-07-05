defmodule Events.Repo.Migrations.EventTime do
  use Ecto.Migration

  def change do
    alter table(:events) do
      add :manual, :boolean, default: false
    end
  end
end
