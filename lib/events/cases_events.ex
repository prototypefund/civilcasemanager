defmodule Events.CasesEvents do
  use Ecto.Schema

  @primary_key false
  schema "cases_events" do
    belongs_to :case, Events.Cases.Case
    belongs_to :event, Events.Events.Event
    timestamps()
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> Ecto.Changeset.cast(params, [:case_id, :event_id])
    |> Ecto.Changeset.validate_required([:case_id, :event_id])
  end
end
