defmodule CaseManager.Repo.Migrations.CreateCaseNationalities do
  use Ecto.Migration

  def change do
    create table(:case_nationalities, primary_key: false) do
      add :country, :string, size: 2, null: false, primary_key: true
      add :count, :integer

      add :case_id, references(:cases, on_delete: :nothing, type: :string),
        null: false,
        primary_key: true
    end

    create unique_index(:case_nationalities, [:country, :case_id])
  end
end
