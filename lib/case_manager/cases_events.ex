defmodule CaseManager.CasesEvents do
  import Ecto.Query, warn: false
  alias CaseManager.Repo

  alias CaseManager.CasesEvents.CaseEvent

  @doc """
  Returns the list of cases_events.

  ## Examples

      iex> list_cases_events()
      [%CaseEvent{}, ...]

  """
  def list_cases_events do
    Repo.all(CaseEvent)
  end

  @doc """
  Gets a single case_event.

  Raises `Ecto.NoResultsError` if the Case event does not exist.

  ## Examples

      iex> get_case_event!(123, 456)
      %CaseEvent{}

      iex> get_case_event!(789, 101)
      ** (Ecto.NoResultsError)

  """
  def get_case_event!(case_id, event_id) do
    Repo.get_by!(CaseEvent, case_id: case_id, event_id: event_id)
  end

  @doc """
  Creates a case_event.

  ## Examples

      iex> create_case_event(%{field: value})
      {:ok, %CaseEvent{}}

      iex> create_case_event(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_case_event(attrs \\ %{}) do
    %CaseEvent{}
    |> CaseEvent.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a case_event.

  ## Examples

      iex> update_case_event(case_event, %{field: new_value})
      {:ok, %CaseEvent{}}

      iex> update_case_event(case_event, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_case_event(%CaseEvent{} = case_event, attrs) do
    case_event
    |> CaseEvent.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a case_event.

  ## Examples

      iex> delete_case_event(case_event)
      {:ok, %CaseEvent{}}

      iex> delete_case_event(case_event)
      {:error, %Ecto.Changeset{}}

  """
  def delete_case_event(%CaseEvent{} = case_event) do
    Repo.delete(case_event)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking case_event changes.

  ## Examples

      iex> change_case_event(case_event)
      %Ecto.Changeset{data: %CaseEvent{}}

  """
  def change_case_event(%CaseEvent{} = case_event, attrs \\ %{}) do
    CaseEvent.changeset(case_event, attrs)
  end
end
