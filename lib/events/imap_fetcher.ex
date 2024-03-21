defmodule Events.IMAPFetcher do
  use GenServer
  @behaviour Events.FetcherBehaviour


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
    yugo_opts = Keyword.take(opts, [:server, :username, :password])

    ## FIXME: Give unique ids for each instance!!
    client_opts = Keyword.put(yugo_opts, :name, :EXAMPLE)
    ## try this: {:server, :username}

    # Start Yugo
    {:ok, yugo_pid} = Yugo.Client.start_link(client_opts)

    # Set up the email filter
    my_filter = Yugo.Filter.all()

    # Subscribe to emails
    # Yugo.subscribe(:EXAMPLE, my_filter)

    # receive do
    #   {:email, _client, message} ->
    #     publish_email(message)
    # end

    # Store Yugo client PID in state for later reference
    {:ok, %{yugo_pid: yugo_pid}}
  end

  def fetch_data(opts) do
    ## TODO
  end

  defp publish_email(message) do
    IO.puts("Received an email with subject `#{message.subject}`:")
    IO.inspect(message)
  end
end
