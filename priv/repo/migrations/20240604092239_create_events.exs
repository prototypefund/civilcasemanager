defmodule CaseManager.Repo.Migrations.CreateEvents do
  use Ecto.Migration

  def change do
    create table(:events) do
      add :type, :string
      add :received_at, :utc_datetime
      add :title, :string
      add :body, :text
      add :from, :string
      add :deleted_at, :utc_datetime, from: :datetime
      add :edited_at, :utc_datetime, from: :datetime
      add :metadata, :text

      timestamps(type: :utc_datetime)
    end
  end
end
