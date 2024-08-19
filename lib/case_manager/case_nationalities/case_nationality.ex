defmodule CaseManager.CaseNationalities.CaseNationality do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key false
  schema "case_nationalities" do
    field :count, :integer
    field :country, :string, primary_key: true

    belongs_to :case, CaseManager.Cases.Case,
      foreign_key: :case_id,
      type: CaseManager.StringId,
      primary_key: true
  end

  @doc false
  def changeset(case_nationality, attrs) do
    case_nationality
    |> cast(attrs, [:country, :count, :case_id])
    |> validate_required([:country])
    |> validate_exclusion(:country, ["unknown", :unknown], message: "Country cannot be 'unknown'")
  end
end
