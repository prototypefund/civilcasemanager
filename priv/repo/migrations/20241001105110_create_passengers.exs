defmodule CaseManager.Repo.Migrations.CreatePassengers do
  use Ecto.Migration

  def change do
    create table(:passengers) do
      add :name, :string
      add :description, :text
      add :case_id, references(:cases, on_delete: :delete_all, type: :string), null: false

      timestamps(type: :utc_datetime)
    end

    create index(:passengers, [:case_id])
  end
end
