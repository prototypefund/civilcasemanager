defmodule Events.IMAPWorker do
  use GenServer

  def start_link(opts) do
    GenServer.start_link(__MODULE__, opts, name: Keyword.get(opts, :name, __MODULE__))
  end

  @impl true
  def init(opts) do
    IO.puts("Hello from IMAP")

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

  @impl true
  def handle_call({:fetch_data}, _from, _state) do
    ## Just an example
  end

  defp publish_email(message, state) do
    IO.puts("Received an email with subject `#{message.subject}`:")
    IO.inspect(message)
    IO.inspect(state[:manager_pid])

    ## TODO: Add email headers?
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

  ## Sometimes we get both
  ## TODO: More concise?
  defp extract_body(body) when is_list(body) do
    body
    |> Enum.find(fn {content_type, _, _} -> content_type == "text/plain" end)
    |> case do
      nil ->
        # Fallback to "text/html" if "text/plain" is not found, or nil if neither are present
        Enum.find(body, fn {content_type, _, _} -> content_type == "text/html" end)
        |> extract_body_from_tuple()
      {_content_type, _options, actual_body} ->
        actual_body
    end
  end

  defp extract_body_from_tuple(nil), do: nil
  defp extract_body_from_tuple({_, _, actual_body}), do: actual_body

  def extract_email_address(from) do
    from
    |> Enum.map(fn
      {nil, email} -> email
      {name, email} -> "#{name} <#{email}>"
    end)
    |> Enum.join(", ")
  end

end
