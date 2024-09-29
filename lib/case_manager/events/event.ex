defmodule CaseManager.Events.Event do
  use Ecto.Schema
  import Ecto.Changeset
  alias CaseManager.Cases
  alias CaseManager.Cases.Case
  alias CaseManager.CasesEvents.CaseEvent
  import CaseManager.ChangesetValidators

  @derive {
    Flop.Schema,
    filterable: [:type, :title], sortable: [:received_at]
  }

  schema "events" do
    field :body, :string
    field :from, :string
    field :received_at, :utc_datetime
    field :title, :string
    field :type, :string, default: "manual"
    field :metadata, :string
    field :deleted_at, :utc_datetime
    field :edited_at, :utc_datetime

    many_to_many :cases, Case,
      join_through: CaseEvent,
      on_replace: :delete

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(event, attrs) do
    event
    |> cast(attrs, [:type, :received_at, :body, :title, :from, :metadata])
    |> assign_cases(attrs[:cases] || attrs["cases"])
    |> validate_required([:type, :body])
    |> truncate_field(:body, 65_535)
    |> truncate_field(:metadata, 65_535)
    |> put_timestamp_if_nil(:received_at)
  end

  defp assign_cases(changeset, nil), do: changeset

  defp assign_cases(changeset, []), do: put_assoc(changeset, :cases, [])

  defp assign_cases(changeset, cases) when is_binary(cases) do
    assign_cases(changeset, [cases])
  end

  defp assign_cases(changeset, cases) when is_list(cases) and is_binary(hd(cases)) do
    put_assoc(changeset, :cases, Cases.get_cases(cases))
  end

  defp assign_cases(changeset, cases) when is_list(cases) and is_struct(hd(cases), Case) do
    put_assoc(changeset, :cases, cases)
  end
end
