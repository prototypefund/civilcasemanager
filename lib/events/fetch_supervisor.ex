defmodule Events.FetchSupervisor do

  use Supervisor

  def start_link(opts) do
    Supervisor.start_link(__MODULE__, opts, name: __MODULE__)
  end

  @impl true
  def init(opts) do

    worker_configs = opts[:worker_configs]

    ## TODO: What to do if manager_pid is null???
    manager_pid = Process.whereis(:fetch_manager)

    children = Enum.map(worker_configs, fn {worker_module, worker_opts} ->
      # Generate a child spec for each worker module
      worker_opts = Keyword.put(worker_opts, :manager_pid, manager_pid)
      {worker_module, worker_opts}
    end)

    Supervisor.init(children, strategy: :one_for_one)
  end

end
