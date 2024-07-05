defmodule Events.Repo.Migrations.LargerText do
  use Ecto.Migration

  def change do
    alter table(:events) do
      modify :body, :text
    end
  end
end
