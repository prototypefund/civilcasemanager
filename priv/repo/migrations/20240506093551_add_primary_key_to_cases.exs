defmodule CaseManager.Repo.Migrations.AddPrimaryKeyToCases do
  use Ecto.Migration

  def change do
    alter table(:cases) do
      modify :id, :string, primary_key: true
    end
  end
end
