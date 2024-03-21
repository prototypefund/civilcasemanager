defmodule Events.Eventlog.Event do
  use Ecto.Schema
  import Ecto.Changeset

  schema "events" do
    field :body, :string
    field :case_id, :string
    field :origin, :string
    field :received_at, :utc_datetime
    field :title, :string
    field :type, :string
    field :manual, :boolean, default: true
    field :metadata, :string
    field :deleted_at, :utc_datetime

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(event, attrs) do
    event
    ## Here are the fields than be updated through user interaction
    ## Check if complete
    |> cast(attrs, [:type, :received_at, :body, :case_id, :title])
    |> validate_required([:type, :body])
    |> put_received_at_if_nil()
  end

  defp put_received_at_if_nil(changeset) do
    case get_field(changeset, :received_at) do
      nil -> put_change(changeset, :received_at, DateTime.utc_now())
      _ -> changeset
    end
  end
end
