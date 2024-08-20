defmodule CaseManager.Places.Place do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key false
  @derive {Phoenix.Param, key: :name}
  schema "places" do
    field :name, :string, primary_key: true
    field :country, :string

    field :sar_zone, Ecto.Enum,
      values: [
        :sar1,
        :sar2,
        :sar3
      ]

    field :type, Ecto.Enum, values: [departure: 0, arrival: 1, both: 2]
    field :lat, :decimal
    field :lon, :decimal
  end

  @doc false
  def changeset(place, attrs) do
    place
    |> cast(attrs, [:name, :country, :lat, :lon, :type])
    |> validate_required([:name, :country, :lat, :lon, :type])
    |> unique_constraint(:name)
  end
end
