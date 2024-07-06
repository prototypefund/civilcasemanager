defmodule CaseManager.Repo.Migrations.DropCaseId do
  use Ecto.Migration

  def change do
    alter table(:events) do
      remove :case_id
    end
  end
end
