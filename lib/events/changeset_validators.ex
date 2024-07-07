defmodule Events.ChangesetValidators do
  import Ecto.Changeset

  @doc """
  Add a timestamp to the received_at field if it is nil.
  """
  def put_timestamp_if_nil(changeset, field) do
    case get_field(changeset, field) do
      nil -> put_change(changeset, field, DateTime.utc_now() |> DateTime.truncate(:second))
      _ -> changeset
    end
  end

  @doc """
  Truncate a field to a maximum length.
  """
  def truncate_field(changeset, field, max_length) do
    current_value = get_field(changeset, field)

    # Ensure current_value is not nil before slicing
    truncated_value =
      if !is_nil(current_value) and String.length(current_value) > max_length do
        String.slice(current_value, 0, max_length) <> "…"
      else
        current_value
      end

    put_change(changeset, field, truncated_value)
  end
end
