defmodule Events.Eventlog.Event do
  use Ecto.Schema
  import Ecto.Changeset
  alias Events.Repo
  import Ecto.Query, only: [from: 2]

  schema "events" do
    field :body, :string
    field :from, :string
    field :received_at, :utc_datetime
    field :title, :string
    field :type, :string
    field :manual, :boolean, default: true
    field :metadata, :string
    field :deleted_at, :utc_datetime
    field :edited_at, :utc_datetime

    many_to_many :cases, Events.Cases.Case, join_through: Events.CasesEvents, on_replace: :delete

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(event, attrs) do
    event
    ## Here are the fields than be updated through user interaction
    ## Check if complete
    |> cast(attrs, [:type, :received_at, :body, :title, :manual, :from, :metadata])
    |> validate_required([:type, :body])
    |> truncate_field(:body, 65_535)
    |> truncate_field(:metadata, 65_535)
    |> put_received_at_if_nil()
    |> assign_cases_by_id(attrs["cases"])
    |> assign_cases_by_identifier(attrs[:case_identifier])
  end

  defp assign_cases_by_id(changeset, []), do: changeset
  defp assign_cases_by_id(changeset, nil), do: changeset
  defp assign_cases_by_id(changeset, cases) do
    IO.inspect(cases, label: "Cases")
    Ecto.Changeset.put_assoc(changeset, :cases, Events.Cases.get_cases(cases))
  end

  ## TODO: Create case if not existing
  defp assign_cases_by_identifier(changeset, []), do: changeset
  defp assign_cases_by_identifier(changeset, nil), do: changeset
  defp assign_cases_by_identifier(changeset, case_identifier) do
    IO.inspect(case_identifier, label: "Cases Identifier")
    Ecto.Changeset.put_assoc(changeset, :cases, [Events.Cases.get_case_by_identifier(case_identifier)])
  end

  defp put_received_at_if_nil(changeset) do
    case get_field(changeset, :received_at) do
      nil -> put_change(changeset, :received_at, DateTime.utc_now())
      _ -> changeset
    end
  end

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
