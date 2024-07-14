defmodule CaseManager.Positions.Position do
  use Ecto.Schema
  import Ecto.Changeset

  @derive {
    Flop.Schema,
    filterable: [:id],
    sortable: [:timestamp],
    default_order: %{
      order_by: [:timestamp],
      order_directions: [:desc, :asc]
    }
  }

  @primary_key {:id, CaseManager.StringId, autogenerate: true}
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
    ## FIXME
    # field :pos_geo, Geo.PostGIS.Geometry
    field :soft_deleted, :boolean, default: false
    belongs_to :case, CaseManager.Cases.Case, foreign_key: :item_id, type: CaseManager.StringId
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
    |> validate_required([:lat, :lon, :timestamp])
  end
end
