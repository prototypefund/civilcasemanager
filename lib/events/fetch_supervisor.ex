defmodule Events.FetchSupervisor do

  use Supervisor

  def start_link(opts) do
    Supervisor.start_link(__MODULE__, opts, name: __MODULE__, strategy: :one_for_one, restart: :transient)
  end

  @impl true
  def init(opts) do
    manager_pid = Process.whereis(:fetch_manager)

    # If there is no manager_pid, crash the supervisor
    if manager_pid == nil do
      raise "No manager process found. Ensure that :fetch_manager is started before the supervisor."
    end

    children = Enum.map(opts, fn {worker_module, worker_opts} ->
      # Generate a child spec for each worker module
      worker_opts = Keyword.put(worker_opts, :manager_pid, manager_pid)
      Supervisor.child_spec({worker_module, worker_opts}, id: worker_opts[:name])
    end)

    IO.inspect(children)

    Supervisor.init(children, strategy: :one_for_one)
  end

end
