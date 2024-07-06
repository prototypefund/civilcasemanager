defmodule CaseManager.Repo.Migrations.CreateEvents do
  use Ecto.Migration

  def change do
    create table(:case_manager) do
      add :type, :string
      add :time, :string
      add :case_id, :string
      add :title, :string
      add :body, :string
      add :origin, :string

      timestamps(type: :utc_datetime)
    end
  end
end
