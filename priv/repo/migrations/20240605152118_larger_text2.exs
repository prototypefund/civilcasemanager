defmodule CaseManager.Repo.Migrations.LargerText2 do
  use Ecto.Migration

  def change do
    rename table(:case_manager), :origin, to: :from

    alter table(:case_manager) do
      modify :body, :text
      modify :metadata, :text
    end
  end
end
