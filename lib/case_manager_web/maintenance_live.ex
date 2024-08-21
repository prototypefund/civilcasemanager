defmodule CaseManagerWeb.MaintenanceLive do
  use CaseManagerWeb, :live_view
  alias CaseManager.DataQualityTools

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, output: "", functions: DataQualityTools.available_functions())}
  end

  @impl true
  def handle_event("run_maintenance", %{"function" => function}, socket) do
    if socket.assigns.current_user.role == :admin do
      output = run_maintenance(String.to_existing_atom(function))
      {:noreply, assign(socket, output: output)}
    end
  end

  defp run_maintenance(function) do
    apply(DataQualityTools, function, [])
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div class="container mx-auto">
      <h1 class="text-2xl font-bold mb-4">Maintenance Scripts</h1>
      <div class="grid grid-cols-3 gap-4 mb-4">
        <%= for {function, label} <- @functions do %>
          <.button
            phx-click="run_maintenance"
            phx-value-function={function}
            class="font-bold py-2 px-4 rounded"
          >
            <%= label %>
          </.button>
        <% end %>
      </div>
      <div class="mt-4">
        <h2 class="text-xl font-semibold mb-2">Output:</h2>
        <pre class="bg-gray-100 p-4 rounded"><%= @output %></pre>
      </div>
    </div>
    """
  end
end
