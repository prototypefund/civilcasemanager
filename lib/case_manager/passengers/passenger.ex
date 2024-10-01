defmodule CaseManager.Passengers.Passenger do
  use Ecto.Schema
  import Ecto.Changeset

  schema "passengers" do
    field :name, :string
    field :description, :string
    belongs_to :case, CaseManager.Cases.Case, type: CaseManager.StringId

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(passenger, attrs) do
    passenger
    |> cast(attrs, [:name, :description, :case_id])
    |> validate_required([:name])
  end
end
