defmodule CaseManager.Repo.Migrations.LargerText do
  use Ecto.Migration

  def change do
    alter table(:case_manager) do
      modify :body, :text
    end
  end
end
