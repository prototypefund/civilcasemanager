defmodule CaseManager.Repo.Migrations.EditedAt do
  use Ecto.Migration

  def change do
    alter table(:case_manager) do
      add :edited_at, :utc_datetime, from: :datetime
    end
  end
end
