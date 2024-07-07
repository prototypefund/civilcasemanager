defmodule CaseManager.Eventlog.Event do
  use Ecto.Schema
  import Ecto.Changeset
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

    many_to_many :cases, CaseManager.Cases.Case,
      join_through: CaseManager.CasesEvents,
      on_replace: :delete

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(event, attrs) do
    # IO.inspect(event, label: "Event before Validation")
    # IO.inspect(attrs, label: "Event Attrs before Validation")
    event
    ## Here are the fields than be updated through user interaction
    ## Check if complete
    |> cast(attrs, [:type, :received_at, :body, :title, :from, :metadata])
    |> assign_case(attrs[:case])
    |> assign_cases(attrs["cases"])
    |> validate_required([:type, :body])
    |> truncate_field(:body, 65_535)
    |> truncate_field(:metadata, 65_535)
    |> put_timestamp_if_nil(:received_at)
  end

  defp assign_case(changeset, nil) do
    changeset
  end

  defp assign_case(changeset, case = %CaseManager.Cases.Case{}) do
    Ecto.Changeset.put_assoc(changeset, :cases, [case])
  end

  defp assign_case(changeset, case) when is_binary(case) do
    Ecto.Changeset.put_assoc(changeset, :cases, CaseManager.Cases.get_cases([case]))
  end

  defp assign_cases(changeset, []), do: changeset
  defp assign_cases(changeset, nil), do: changeset

  defp assign_cases(changeset, cases) when is_binary(cases) do
    Ecto.Changeset.put_assoc(changeset, :cases, CaseManager.Cases.get_cases([cases]))
  end

  defp assign_cases(changeset, cases) when is_list(cases) do
    Ecto.Changeset.put_assoc(changeset, :cases, CaseManager.Cases.get_cases(cases))
  end
end
