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
  schema "positions" do
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
    ## TODO Make plan which field to use
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
      :soft_deleted,
      :short_code
    ])
    |> convert_short_code()
    |> validate_required([:lat, :lon])
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
    rescue
      _ ->
        add_error(changeset, :short_code, "Invalid short code: Use DEG MIN / DEG MIN")
    end
  end
end
