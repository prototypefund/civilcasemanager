defmodule CaseManager.Repo.Migrations.DeleteCaseNationalitiesWithCase do
  use Ecto.Migration

  def change do
    alter table(:case_nationalities) do
      modify :case_id, references(:cases, on_delete: :delete_all, type: :string),
        null: false,
        from: references(:cases, on_delete: :nothing, type: :string)
    end
  end
end
