defmodule Events.Repo.Migrations.CaseStatus do
  use Ecto.Migration

  def change do
    alter table(:cases) do
      remove :status
      add :status, :integer
    end
  end
end
