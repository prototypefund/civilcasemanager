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

    # Generate the children spec
    children = Enum.map(opts, fn {worker_module, worker_opts} ->
      # Generate a child spec for each worker module
      worker_opts = Keyword.put(worker_opts, :manager_pid, manager_pid)
      Supervisor.child_spec({worker_module, worker_opts}, id: worker_opts[:name])
    end)

    # Create a map of types and icons. Example %{imap: "imap_icon.png", slack: "slack.png"}
    type_registry = Enum.reduce(opts, %{}, fn {worker_module, _}, acc ->
      Map.put(acc, worker_module.event_type(), worker_module.hero_icon())
    end)
    Application.put_env(:events, :type_registry, type_registry)

    Supervisor.init(children, strategy: :one_for_one)
  end

  def get_icon_for(event_type) do
    type_registry = Application.get_env(:events, :type_registry, %{})
    "hero-" <> (Map.get(type_registry, event_type) || "question-mark-circle")
  end

end
