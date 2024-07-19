defmodule CaseManager.Repo.Migrations.CreateUsersAuthTables do
  use Ecto.Migration

  def change do
    create table(:users, prefix: "private") do
      add :email, :string, null: false, size: 160
      add :hashed_password, :string, null: false
      add :confirmed_at, :naive_datetime
      add :name, :string, size: 160
      timestamps(type: :utc_datetime)
    end

    create unique_index(:users, ["(lower(email))"], name: "users_email_index", prefix: "private")

    create table(:users_tokens, prefix: "private") do
      add :user_id, references(:users, on_delete: :delete_all), null: false
      add :token, :binary, null: false
      add :context, :string, null: false
      add :sent_to, :string
      timestamps(updated_at: false)
    end

    create index(:users_tokens, [:user_id], prefix: "private")
    create unique_index(:users_tokens, [:context, :token], prefix: "private")

    # Create admin account if environment variables are set
    first_account_email = System.get_env("FIRST_ACCOUNT_EMAIL")
    first_account_password = System.get_env("FIRST_ACCOUNT_PASSWORD")

    if first_account_email && first_account_password do
      execute """
      INSERT INTO private.users (email, hashed_password, confirmed_at, inserted_at, updated_at)
      VALUES ('#{first_account_email}', '#{Bcrypt.hash_pwd_salt(first_account_password)}', NOW(), NOW(), NOW());
      """
    end
  end
end
