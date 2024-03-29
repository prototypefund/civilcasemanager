defmodule Events.Datasources.IMAPWorker do
  import Phoenix.HTML

  use GenServer

  def start_link(opts) do
    GenServer.start_link(__MODULE__, opts)
  end

  @impl true
  def init(opts) do
    # Set up the email filter
    my_filter = Yugo.Filter.all()

    # Subscribe to emails
    Yugo.subscribe(opts[:name], my_filter)

    # Store sthe manager PIDs in state for later reference
    # The state is passed to handle_info for later usage.
    {:ok, %{manager_pid: opts[:manager_pid]}}
  end


  @impl true
  def handle_info({:email, _client, message}, state) do
    publish_email(message, state)
    {:noreply, state}
  end

  defp publish_email(message, _state) do
    IO.inspect(message.subject, label: "Received an email with subject:")

    event = %Events.FetchEvent{
      type: "imap",
      body: extract_body(message.body),
      from: extract_email_address(message.from),
      title: message.subject,
      received_at: DateTime.utc_now(),
      metadata: String.replace(message.rfc822_header, "\r\n", "\n")
    }

    # TODO: Store the PID in context instead of looking it up every time
    manager_pid = Process.whereis(:fetch_manager)

    ## Cast messages don't expect a reply, call messages do.
    GenServer.cast(manager_pid, {:new_event, event})
  end

  defp extract_body({"text/plain", _opts, actual_body}), do: actual_body
  defp extract_body({"text/html", _opts, actual_body}), do: actual_body |> html_escape() |> safe_to_string()

  ## A message can contain both
  defp extract_body(body) when is_list(body) do
    extract_body_from_list(body, "text/plain") || extract_body_from_list(body, "text/html")
  end

  defp extract_body_from_list(body, content_type) do
    case Enum.find(body, fn {type, _, _} -> type == content_type end) do
      nil -> nil
      body -> extract_body(body)
    end
  end

  def extract_email_address(from) do
    from
    |> Enum.map(fn
      {nil, email} -> email
      {name, email} -> "#{name} <#{email}>"
    end)
    |> Enum.join(", ")
  end

end
