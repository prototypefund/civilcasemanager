defmodule CaseManager.Repo.Migrations.EditedAt do
  use Ecto.Migration

  def change do
    alter table(:events) do
      add :edited_at, :utc_datetime, from: :datetime
    end
  end
end
