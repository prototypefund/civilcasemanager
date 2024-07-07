defmodule Events.Datasources.SlackImporter do
  use Slack.Bot

  require Logger

  @impl true

  # Define allowed prefixes
  @allowed_prefixes ["EB", "DC", "3SC", "AP"]

  # Use this to debug messages
  # def handle_event(type, payload) do
  #   IO.inspect(payload)
  # end

  ## Handles replys in threads (thread_ts is set)
  def handle_event("message", %{"channel" => channel, "text" => text, "user" => user, "thread_ts" => thread_ts}, bot) do

    # Use Slack API to fetch the parent thread using thread_ts
    {:ok, %{"messages" => thread_parent}} = get_thread(bot, channel, thread_ts)

    # Take the text field from the first message
    [%{"text" => thread_title} | _] = thread_parent

    # Extract the ID from the Title
    {status, result} = extract_data_from_title(thread_title)

    if status == :ok do
      publish_event(result, text, user)
      send_message(channel, "New REPLY for #{result[:identifier]}")
    else
      send_message(channel, "Error parsing the title: #{result}")
    end
  end


  ## Handles new threads (thread_ts is not set)
  def handle_event("message", %{"channel" => channel, "text" => text, "user" => user}, bot) do

    # Extract the ID from the Title
    {status, result} = extract_data_from_title(text)

    if status == :ok do
      publish_event(result, "Case created through Slack: " <> text, user)
      send_message(channel, "New THREAD for #{result[:identifier]}")
    else
      send_message(channel, "Error parsing the title: #{result}")
    end
  end

  def handle_event(type, payload) do
    Logger.debug("Unhandled #{type} event: #{inspect(payload)}")
    :ok
  end

  defp publish_event(case_data, text, user) do
     # TODO: Store the PID in context instead of looking it up every time
     manager_pid = Process.whereis(:fetch_manager)

     event = %Events.FetchEvent{
       type: "slack",
       body: text,
       from: user,
       title: case_data[:identifier],
       received_at: DateTime.utc_now(),
       metadata: case_data[:additional] || "",
       case_data: case_data
     }

     GenServer.cast(manager_pid, {:new_event, event})
  end

  defp extract_data_from_title(string) do
    # First strip any markdown bold formatting (*)
    string = String.replace(string, "*", "")

    # Check if the string starts with any of the legal prefixes
    found_prefix = Enum.find(@allowed_prefixes, fn prefix -> String.starts_with?(string, prefix) end)

    case found_prefix do
      nil -> {:error, string}
      prefix -> {:ok, String.replace(string, prefix <> " ", prefix) |> case_data_to_map() }
    end
  end


  defp case_data_to_map(title) when (is_binary(title)) do
    # Split title by " - "
    case_data_to_map(String.split(title, " - "))
  end

  defp case_data_to_map([case_id, created_at, additional]) do
    %{identifier: case_id, created_at: created_at |> split_date() |> fix_date(), additional: additional}
  end

  defp case_data_to_map([case_id, created_at]) do
    %{identifier: case_id, created_at: created_at |> split_date() |> fix_date()}
  end

  defp case_data_to_map([case_id]) do
    %{identifier: case_id}
  end

  defp split_date(date_string) do
    String.split(date_string, ".")
  end

  # Parse the given date string. If it is todays date,
  # replace it by a current UTC Timestamp
  defp fix_date([day, month, year]) do

    # Rearrange parts to ISO 8601 format
    date_string = "#{year}-#{month}-#{day}"

    case Date.from_iso8601(date_string) do
      {:ok, date} ->
        if Date.utc_today() == date do
          DateTime.utc_now() |> DateTime.truncate(:second)
        else
          case DateTime.new(date, ~T[00:00:00]) do
            {:ok, datetime} -> datetime
            _ -> date_string
          end
        end
      _ -> date_string
    end
  end

  # Fallback when Split doesnt return three parts
  defp fix_date(date_string) do
    date_string
  end


  # Use Slack API to fetch the parent thread using thread_ts
  defp get_thread(bot, channel, ts) do

    Slack.API.get("conversations.history",
      bot.token,
      %{channel: channel,
      latest: ts,
      limit: 1,
      inclusive: true}
    )
  end
end
