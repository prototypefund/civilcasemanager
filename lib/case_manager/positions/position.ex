defmodule CaseManager.Positions.Position do
  use Ecto.Schema
  import Ecto.Changeset
  import CaseManager.GeoTools

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
  schema "case_positions" do
    field :timestamp, :utc_datetime
    field :speed, :decimal
    field :source, :string
    field :altitude, :decimal
    field :course, :decimal
    field :heading, :decimal
    field :lat, :decimal
    field :lon, :decimal
    field :short_code, :string, virtual: true
    field :imported_from, :string
    field :pos_geo, Geo.PostGIS.Geometry
    field :soft_deleted, :boolean, default: false
    belongs_to :case, CaseManager.Cases.Case, foreign_key: :item_id, type: CaseManager.StringId

    timestamps(type: :utc_datetime)
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
      :pos_geo,
      :source,
      :speed,
      :timestamp,
      :imported_from,
      :soft_deleted,
      :short_code,
      :item_id
    ])
    |> convert_short_code()
    |> validate_required([:lat, :lon, :timestamp])
    |> fill_geo_if_missing()
    |> validate_required([:pos_geo])
    |> unique_constraint([:timestamp, :item_id])
  end

  def convert_short_code(changeset) do
    case get_change(changeset, :short_code) do
      nil ->
        changeset

      short_code ->
        safe_parse_short_code(changeset, short_code)
    end
  end

  defp safe_parse_short_code(changeset, short_code) do
    try do
      {lat, lon} = combined_short_string_to_float(short_code)

      changeset
      |> put_change(:lat, lat)
      |> put_change(:lon, lon)
      |> put_change(:pos_geo, %Geo.Point{coordinates: {lon, lat}, srid: 4326})
    rescue
      _ ->
        add_error(changeset, :short_code, "Invalid short code: Use DEG MIN / DEG MIN")
    end
  end

  def fill_geo_if_missing(changeset) do
    if !get_field(changeset, :geo_pos) && get_field(changeset, :lon) do
      put_change(
        changeset,
        :pos_geo,
        geo_point_from_lat_lon(
          get_field(changeset, :lon),
          get_field(changeset, :lat)
        )
      )
    else
      changeset
    end
  end

  defp geo_point_from_lat_lon(lat, lon) when is_float(lat) and is_float(lon) do
    %Geo.Point{
      coordinates: {lon, lat},
      srid: 4326
    }
  end

  defp geo_point_from_lat_lon(lat, lon) do
    %Geo.Point{
      coordinates: {Decimal.to_float(lon), Decimal.to_float(lat)},
      srid: 4326
    }
  end
end
