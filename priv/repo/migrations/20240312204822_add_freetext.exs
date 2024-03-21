defmodule Events.Repo.Migrations.AddFreetext do
  use Ecto.Migration

  def change do
    alter table(:cases) do
      add :freetext, :text
    end
  end
end
