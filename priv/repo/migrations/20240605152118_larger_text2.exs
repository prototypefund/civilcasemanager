defmodule Events.Repo.Migrations.LargerText2 do
  use Ecto.Migration

  def change do
    rename table(:events), :origin, to: :from

    alter table(:events) do
      modify :body, :text
      modify :metadata, :text
    end
  end
end
