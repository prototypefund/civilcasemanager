defmodule CaseManager.Repo.Migrations.RenameTimes do
  use Ecto.Migration

  def change do
    rename table(:case_manager), :time_received, to: :received_at

    alter table(:case_manager) do
      add :deleted_at, :utc_datetime, from: :datetime
      add :metadata, :string
    end
  end
end
