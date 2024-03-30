defmodule Events.Repo.Migrations.MoreCaseFields do
  use Ecto.Migration

  def change do
    alter table(:cases) do
      add :additional_identifiers, :string
      add :pob_man, :integer
      add :pob_woman, :integer
      add :pob_child, :integer
      add :boat_type, :integer
      add :course_over_ground, :integer
      add :speed_over_ground, :integer
    end
  end
end
