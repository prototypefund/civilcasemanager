defmodule Events.Cases.Case do
  use Ecto.Schema
  import Ecto.Changeset
  import Events.ChangesetValidators

  schema "cases" do
    field :archived_at, :utc_datetime
    field :closed_at, :utc_datetime
    field :created_at, :utc_datetime
    field :deleted_at, :utc_datetime
    field :description, :string
    field :identifier, :string
    field :opened_at, :utc_datetime
    field :status, Ecto.Enum, values: [draft: 0, open: 1, closed: 2, archived: 3], default: :open
    field :status_note, :string
    field :title, :string
    field :freetext, :string

    many_to_many :events, Events.Eventlog.Event, join_through: Events.CasesEvents

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(case, attrs) do
    case
    |> cast(attrs, [:identifier, :title, :description, :created_at, :deleted_at, :opened_at, :closed_at, :archived_at, :status, :status_note])
    |> validate_required([:identifier, :status])
    |> put_timestamp_if_nil(:created_at)
    |> put_timestamp_if_nil(:opened_at)
    |> truncate_field(:freetext, 65_535)
    |> IO.inspect()
  end

end
