defmodule Events.FetchCoordinator do

  use GenServer

  def start_link(worker_configs) do
    GenServer.start_link(__MODULE__, worker_configs, name: __MODULE__)
  end

  @impl true
  def init(worker_configs) do
    start_workers(worker_configs)
    {:ok, worker_configs}
  end


  @moduledoc """
  This module coordinates the starting and supervision of worker modules
  responsible for fetching data from external services.
  """


  # Public API
  ## TODO if one of the workers fails everything crashes?
  @doc """
  Starts the worker modules based on the provided configuration.
  """
  def start_workers(worker_configs) do
    Enum.each(worker_configs, fn {worker_module, opts} ->
      case worker_module.start_link(opts) do
        {:ok, pid} ->
          # Handle successful start
          IO.puts("Started #{inspect(worker_module)}")
        {:error, reason} ->
          # Handle error
          IO.puts("Failed to start #{inspect(worker_module)}: #{reason}")
      end
    end)
  end
end
