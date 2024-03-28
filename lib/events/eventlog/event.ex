defmodule Events.Eventlog.Event do
  use Ecto.Schema
  import Ecto.Changeset
  import Events.ChangesetValidators


  @derive {
    Flop.Schema,
    filterable: [:type, :title],
    sortable: [:received_at]
  }

  schema "events" do
    field :body, :string
    field :from, :string
    field :received_at, :utc_datetime
    field :title, :string
    field :type, :string
    field :metadata, :string
    field :deleted_at, :utc_datetime
    field :edited_at, :utc_datetime

    many_to_many :cases, Events.Cases.Case, join_through: Events.CasesEvents, on_replace: :delete

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(event, attrs) do
    new = event
    ## Here are the fields than be updated through user interaction
    ## Check if complete
    |> cast(attrs, [:type, :received_at, :body, :title, :from, :metadata])
    |> validate_required([:type, :body])
    |> truncate_field(:body, 65_535)
    |> truncate_field(:metadata, 65_535)
    |> put_timestamp_if_nil(:received_at)
    |> assign_cases_by_id(attrs["cases"])
    |> assign_cases_by_identifier(attrs[:case_data])
    IO.inspect(new, label: "New Event Changeset")
    new
  end

  defp assign_cases_by_id(changeset, []), do: changeset
  defp assign_cases_by_id(changeset, nil), do: changeset
  defp assign_cases_by_id(changeset, cases) when is_binary(cases) do
    { id, _ } = Integer.parse(cases)
    IO.inspect(id, label: "Cases")
    Ecto.Changeset.put_assoc(changeset, :cases,
      Events.Cases.get_cases([id])
    )
  end
  defp assign_cases_by_id(changeset, cases) do
    IO.inspect(cases, label: "Cases")
    Ecto.Changeset.put_assoc(changeset, :cases, Events.Cases.get_cases(cases))
  end

  ## TODO: Is this the best place for this function?
  defp assign_cases_by_identifier(changeset, []), do: changeset
  defp assign_cases_by_identifier(changeset, nil), do: changeset
  defp assign_cases_by_identifier(changeset, case_data) do
    IO.inspect(case_data, label: "Cases Identifier")
    Ecto.Changeset.put_assoc(changeset, :cases, [get_or_create_case(case_data)])
  end

  defp get_or_create_case(case_data) do
    case = Events.Cases.get_case_by_identifier(case_data[:identifier])

    # Return the case if it exists, otherwise create a new one,
    # using the case_data map to populate the fields
    case = case || %Events.Cases.Case{
      identifier: case_data[:identifier],
      created_at: case_data[:created_at],
      title: case_data[:additional]
    }

    IO.inspect(case, label: "Case")
    case
  end


end
