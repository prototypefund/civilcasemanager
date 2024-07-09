defmodule CaseManager.Eventlog do
  @moduledoc """
  The Eventlog context.
  """

  import Ecto.Query, warn: false
  alias CaseManager.Repo

  alias CaseManager.Eventlog.Event

  @doc """
  Returns the list of events.

  ## Examples

      iex> list_events()
      [%Event{}, ...]

  """
  def list_events() do
    Repo.all(from e in Event, order_by: [desc: e.received_at])
  end

  @doc """
  Returns the list of events using Flop.

  ## Examples

      iex> list_events(params)
      [%Event{}, ...]

  """
  def list_events(params) do
    Flop.validate_and_run(Event, params, for: Event)
  end

  @doc """
  Gets a single event.

  Raises `Ecto.NoResultsError` if the Event does not exist.
  By default also preloads the cases relationship.

  ## Examples

      iex> get_event!(123)
      %Event{}

      iex> get_event!(456)
      ** (Ecto.NoResultsError)

  """
  def get_event!(id, preload \\ true) do
    Repo.one!(
      from c in Event,
        where: c.id == ^id,
        preload: ^if(preload, do: [:cases], else: [])
    )
  end

  @doc """
  Creates a event.

  ## Examples

      iex> create_event(%{field: value})
      {:ok, %Event{}}

      iex> create_event(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_event(attrs \\ %{}) do
    %Event{}
    |> Event.changeset(attrs)
    |> Repo.insert()
    |> broadcast(:event_created)
  end

  @doc """
  Updates a event.

  ## Examples

      iex> update_event(event, %{field: new_value})
      {:ok, %Event{}}

      iex> update_event(event, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_event(%Event{} = event, attrs) do
    event
    |> Event.changeset(attrs)
    |> Repo.update()
    |> broadcast(:event_updated)
  end

  @doc """
  Deletes a event.

  ## Examples

      iex> delete_event(event)
      {:ok, %Event{}}

      iex> delete_event(event)
      {:error, %Ecto.Changeset{}}

  """
  def delete_event(%Event{} = event) do
    Repo.delete(event)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking event changes.

  ## Examples

      iex> change_event(event)
      %Ecto.Changeset{data: %Event{}}

  """
  def change_event(%Event{} = event, attrs \\ %{}) do
    Event.changeset(event, attrs)
  end

  def subscribe do
    Phoenix.PubSub.subscribe(CaseManager.PubSub, "events")
  end

  def broadcast({:error, changeset}, _change_type), do: {:error, changeset}

  def broadcast({:ok, event}, change_type) do
    Phoenix.PubSub.broadcast(CaseManager.PubSub, "events", {change_type, event})
    {:ok, event}
  end
end
