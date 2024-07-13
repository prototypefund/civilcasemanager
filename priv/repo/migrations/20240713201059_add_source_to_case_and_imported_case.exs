defmodule CaseManager.Repo.Migrations.AddSourceToCaseAndImportedCase do
  use Ecto.Migration

  def change do
    alter table(:cases) do
      add :source, :string
    end

    alter table(:imported_cases) do
      add :source, :string
    end
  end
end
