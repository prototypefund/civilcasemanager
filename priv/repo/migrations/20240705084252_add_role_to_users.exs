defmodule Events.Repo.Migrations.AddRoleToUsers do
  use Ecto.Migration

  def change do
    alter table("users", prefix: "private") do
      add :role, :string, default: "user"
    end
  end
end
