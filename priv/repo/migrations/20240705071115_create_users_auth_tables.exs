defmodule Events.Repo.Migrations.CreateUsersAuthTables do
  use Ecto.Migration

  def change do
    create table(:users, prefix: "private") do
      add :email, :string, null: false, size: 160
      add :hashed_password, :string, null: false
      add :confirmed_at, :naive_datetime
      add :name, :string, size: 160
      timestamps(type: :utc_datetime)
    end

    create unique_index(:users, [:email], prefix: "private")

    create table(:users_tokens, prefix: "private") do
      add :user_id, references(:users, on_delete: :delete_all), null: false
      add :token, :binary, null: false
      add :context, :string, null: false
      add :sent_to, :string
      timestamps(updated_at: false)
    end

    create index(:users_tokens, [:user_id], prefix: "private")
    create unique_index(:users_tokens, [:context, :token], prefix: "private")
  end
end
