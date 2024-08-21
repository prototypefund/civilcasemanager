defmodule CaseManager.DeletedCases.DeletedCase do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, CaseManager.StringId, autogenerate: false}
  schema "deleted_cases" do
    timestamps(type: :utc_datetime, inserted_at: :deleted_at, updated_at: false)
  end

  @doc false
  def changeset(deleted_case, attrs) do
    deleted_case
    |> cast(attrs, [:id])
    |> validate_required([:id])
  end
end
