defmodule Events.Cases.Case do
  use Ecto.Schema
  import Ecto.Changeset

  schema "cases" do
    field :archived_at, :utc_datetime
    field :closed_at, :utc_datetime
    field :created_at, :utc_datetime
    field :deleted_at, :utc_datetime
    field :description, :string
    field :identifier, :string
    field :is_archived, :boolean, default: false
    field :opened_at, :utc_datetime
    field :status, Ecto.Enum, values: [draft: 0, open: 1, closed: 2], default: :open
    field :status_note, :string
    field :title, :string
    field :freetext, :string

    many_to_many :events, Events.Eventlog.Event, join_through: Events.CasesEvents

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(case, attrs) do
    case
    |> cast(attrs, [:identifier, :title, :description, :created_at, :deleted_at, :opened_at, :closed_at, :archived_at, :is_archived, :status, :status_note])
    |> validate_required([:identifier, :status])
    |> truncate_field(:freetext, 65_535)
  end

  ## TODO: Quickly copied from event, put into helper functions
  defp truncate_field(changeset, field, max_length) do
    current_value = get_field(changeset, field)

    # Ensure current_value is not nil before slicing
    truncated_value = if !is_nil(current_value) and String.length(current_value) > max_length do
      String.slice(current_value, 0, max_length)
    else
      current_value
    end

    put_change(changeset, field, truncated_value)
  end
end
