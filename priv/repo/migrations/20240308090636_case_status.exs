defmodule Events.Repo.Migrations.CaseStatus do
  use Ecto.Migration

  def change do
    alter table(:cases) do
      modify :status, :integer
    end
  end
end
