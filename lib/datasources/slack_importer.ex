defmodule Events.Datasources.SlackImporter do
  use Slack.Bot

  require Logger

  @impl true


  def handle_event(type, payload) do
    IO.inspect(payload)
  end

  ## Handles replys in threads (thread_ts is set)
  def handle_event("message", %{"channel" => channel, "text" => text, "user" => user, "ts" => ts, "thread_ts" => thread_ts}) do

    # Use Slack API to fetch the parent thread using thread_ts
    {:ok, %{"messages" => thread_parent}} = get_thread(channel, thread_ts)

    # Take the text field from the first message
    [%{"text" => thread_title} | _] = thread_parent

    # Extract the ID from the Title
    {status, case_title} = check_valid_case_string(thread_title)

    if status == :ok do
      case_data = extract_data_from_title(case_title)
      publish_event(case_data, text, user)
      send_message(channel, "New REPLY for #{case_data[:case_identifier]}")
    else
      send_message(channel, "Error parsing the title: #{case_title}")
    end
  end


  ## Handles new threads (thread_ts is not set)
  def handle_event("message", %{"channel" => channel, "text" => text, "user" => user, "ts" => ts}) do

    # Extract the ID from the Title
    {status, case_title} = check_valid_case_string(text)

    if status == :ok do
      case_data = extract_data_from_title(case_title)
      publish_event(case_data, text, user)
      send_message(channel, "New THREAD for #{case_data[:case_identifier]}")
    else
      send_message(channel, "Error parsing the title: #{case_title}")
    end
  end


  defp publish_event(case_data, text, user) do
     # TODO: Store the PID in context instead of looking it up every time
     manager_pid = Process.whereis(:fetch_manager)

     event = %Events.FetchEvent{
       type: "slack",
       body: text,
       from: user,
       title: case_data[:case_identifier],
       received_at: DateTime.utc_now(),
       metadata: case_data[:additional] || "",
       cases: [%{:id => 1}],
       case_identifier: case_data[:case_identifier]
     }

     GenServer.cast(manager_pid, {:new_event, event})
  end




  defp extract_data_from_title(title) do
    # Split title by " - "
    components_to_map(String.split(title, " - "))
  end

  defp components_to_map([case_id, case_date, additional]) do
    %{case_identifier: case_id, case_date: case_date, additional: additional}
  end

  defp components_to_map([case_id, case_date]) do
    %{case_identifier: case_id, case_date: case_date}
  end






  ## Define allowed prefixes here. Modularize later
  defp check_valid_case_string("EB " <> suffix) do
    {:ok, "EB" <> suffix}
  end

  defp check_valid_case_string("EB" <> suffix) do
    {:ok, "EB" <> suffix}
  end

  defp check_valid_case_string("DC " <> suffix) do
    {:ok, "DC" <> suffix}
  end

  defp check_valid_case_string("DC" <> suffix) do
    {:ok, "DC" <> suffix}
  end

  defp check_valid_case_string("3SC " <> suffix) do
    {:ok, "3SC" <> suffix}
  end

  defp check_valid_case_string("3SC" <> suffix) do
    {:ok, "3SC" <> suffix}
  end

  defp check_valid_case_string(any_string) do
    {:error, any_string}
  end


  # Use Slack API to fetch the parent thread using thread_ts
  defp get_thread(channel, ts) do
    Slack.API.get("conversations.history",
      "TOKEN",
      %{channel: channel,
      latest: ts,
      limit: 1,
      inclusive: true}
    )
  end

  def handle_event(type, payload) do
    Logger.debug("Unhandled #{type} event: #{inspect(payload)}")
    :ok
  end
end
