defmodule CaseManager.CasesEvents.CaseEvent do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key false
  schema "cases_events" do
    belongs_to :case, CaseManager.Cases.Case, type: :string, primary_key: true
    belongs_to :event, CaseManager.Events.Event, type: :integer, primary_key: true

    timestamps(type: :utc_datetime)
  end

  def changeset(case_event, attrs) do
    case_event
    |> cast(attrs, [:case_id, :event_id])
    |> validate_required([:case_id, :event_id])
  end
end
