defmodule Events.IMAPFetcher do
  use GenServer
  @behaviour Events.FetchBehaviour


  ## TODO: Think about names....
  @impl true
  def start_link(opts) do
    case GenServer.start_link(__MODULE__, opts, name: Keyword.get(opts, :name, __MODULE__)) do
      {:ok, pid} ->
        IO.puts("Hello from IMAP")
        {:ok, pid}
      {:error, reason} ->
        {:error, reason}
    end
  end

  @impl true
  def init(opts) do
    # Take the options we need
    ## FIXME whole applications refuses to start if map not correct.
    ## FIXME yugo crashes if server is just a random string
    yugo_opts = Keyword.take(opts, [:server, :username, :password])

    ## FIXME: Give unique ids for each instance!!
    client_opts = Keyword.put(yugo_opts, :name, :EXAMPLE)
    ## try this: {:server, :username}

    # Start Yugo
    {:ok, yugo_pid} = Yugo.Client.start_link(client_opts)

    # Set up the email filter
    my_filter = Yugo.Filter.all()

    # Subscribe to emails
    Yugo.subscribe(:EXAMPLE, my_filter)

    # Store some PIDs in state for later reference
    # The state is passed to handle_info for later usage.
    {:ok, %{yugo_pid: yugo_pid, manager_pid: opts[:manager_pid]}}
  end

  @impl true
  def handle_info({:email, _client, message}, state) do
    publish_email(message, state)
    {:noreply, state}
  end

  @impl true
  def fetch_data(_opts) do
    ## TODO
  end

  defp publish_email(message, state) do
    IO.puts("Received an email with subject `#{message.subject}`:")
    IO.inspect(message)
    IO.inspect(state[:manager_pid])

    ## TODO: Add email headers!
    ## TODO Think about body types (what to do with html emails)
    event = %Events.FetchEvent{
      type: "imap",
      body: extract_body(message.body),
      from: extract_email_address(message.from),
      title: message.subject,
      received_at: DateTime.utc_now()
    }

    ## Cast messages dont expect a reply, call messages do.
    GenServer.cast(state[:manager_pid], {:new_event, event})
  end

  defp extract_body({"text/plain", _options, actual_body}), do: actual_body
  defp extract_body({"text/html", _options, actual_body}), do: actual_body
  defp extract_body(_), do: nil

  def extract_email_address(from) do
    from
    |> Enum.map(fn
      {nil, email} -> email
      {name, email} -> "#{name} <#{email}>"
    end)
    |> Enum.join(", ")
  end

end
