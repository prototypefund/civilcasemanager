defmodule CaseManager.Repo.Migrations.AddRowToImported do
  use Ecto.Migration

  def change do
    alter table(:imported_cases) do
      add :row, :integer
    end
  end
end
