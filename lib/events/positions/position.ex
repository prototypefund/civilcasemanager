defmodule Events.Positions.Position do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :string, autogenerate: false}
  schema "positions" do
    field :timestamp, :utc_datetime
    field :speed, :decimal
    field :source, :string
    field :altitude, :decimal
    field :course, :decimal
    field :heading, :decimal
    field :lat, :decimal
    field :lon, :decimal
    field :imported_from, :string
    field :pos_geo, Geo.PostGIS.Geometry
    field :soft_deleted, :boolean, default: false
    field :item_id, :string
  end

  @doc false
  def changeset(position, attrs) do
    position
    |> cast(attrs, [
      :altitude,
      :course,
      :heading,
      :lat,
      :lon,
      :source,
      :speed,
      :timestamp,
      :imported_from,
      :soft_deleted
    ])
    |> validate_required([:id, :lat, :lon, :timestamp])
  end
end
