defmodule Events.Repo.Migrations.AddUpdatedAtToCases do
  use Ecto.Migration

  def change do
    alter table(:cases) do
      add :updated_at, :utc_datetime
    end
  end
end
