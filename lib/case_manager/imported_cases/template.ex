defmodule CaseManager.ImportedCases.Template do
  require Logger

  @template %{
    "Add info/summary/notes" => %{key: "notes", type: :string},
    "AP NR" => %{key: "name", type: :string, prepend: "AP"},
    "BOAT COLOR" => %{key: "boat_color", type: :string, default: "unknown", lowercase: true},
    "BOAT TYPE" => %{key: "boat_type", type: :string, default: "unknown", lowercase: true},
    "Country. DEP" => %{key: "departure_region", type: :string},
    "DATE (rescued, arrived case closed)" => %{key: "time_of_disembarkation", type: :utc_datetime},
    "Date. DEP" => %{key: "time_of_departure", type: :utc_datetime, append_key: "time. DEP"},
    "DEAD max" => %{key: "people_dead", type: :integer},
    "DEAD Min" => %{key: "people_dead", type: :integer},
    "DEAD" => %{key: "people_dead", type: :integer},
    "DEAD CONFIRMED" => %{key: "people_dead", type: :integer},
    "Links " => %{key: "url", type: :string},
    "missing ppl MAX" => %{key: "people_missing", type: :integer},
    "missing ppl" => %{key: "people_missing", type: :integer},
    "missing ppl CONFIRMED" => %{key: "people_missing", type: :integer},
    "outcome" => %{
      key: "outcome",
      type: :string,
      default: "unknown",
      apply: &CaseManager.ImportedCases.Template.fix_outcome/1
    },
    "Place . DEP" => %{key: "place_of_departure", type: :string},
    "Place of disembarkation" => %{key: "place_of_disembarkation", type: :string},
    "POB Number MAX" => %{key: "pob_total", type: :integer},
    "POB Number MIN" => %{key: "pob_total", type: :integer},
    "number ppl" => %{key: "pob_total", type: :integer},
    "Nationalities" => %{key: "pob_per_nationality", type: :string, join: true},
    "nationalities" => %{key: "pob_per_nationality", type: :string, join: true},
    "POB Number CONFIRMED" => %{key: "pob_total", type: :integer},
    "SAR" => %{key: "sar_region", type: :string, default: "unknown", prepend: "sar"},
    "Source" => %{key: "source", type: :string, regex: ~r/\bhttps?:\/\/\S+\b/},
    "THURAYA" => %{key: "phonenumber", type: :string},
    "1st position" => %{
      key: "first_position",
      type: :string,
      regex:
        ~r/([-+]?\d{1,2}\.\d+)[N]?,\s*([-+]?\d{1,3}\.\d+)[E]?\s*@\s*(\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2})/
    },
    "Last position" => %{
      key: "last_position",
      type: :string,
      regex:
        ~r/([-+]?\d{1,2}\.\d+)[N]?,\s*([-+]?\d{1,3}\.\d+)[E]?\s*@\s*(\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2})/
    }
  }

  def map_input_to_template(input_map, index) do
    Enum.reduce(@template, %{}, fn {key, template}, acc ->
      process(input_map, key, template, acc)
    end)
    |> Map.put("row", index)
    |> populate_occurred_at()
  end

  defp populate_occurred_at(acc) do
    cond do
      Map.has_key?(acc, "time_of_departure") ->
        Map.put(acc, "occurred_at", acc["time_of_departure"])

      Map.has_key?(acc, "time_of_disembarkation") ->
        Map.put(acc, "occurred_at", acc["time_of_disembarkation"])

      true ->
        acc
    end
  end

  def process(input_map, key, template, acc) do
    case Map.fetch(input_map, key) do
      {:ok, input_value} ->
        {new_value, key} =
          input_value
          |> append_conditionally(template, input_map)
          |> prepend_conditionally(template)
          |> trim_conditionally()
          |> parse_values(template)

        cond do
          new_value == "" && Map.has_key?(template, :default) ->
            Map.put(acc, key, template[:default])

          new_value == "" ->
            acc

          new_value == nil ->
            acc

          true ->
            Map.put(acc, key, new_value)
        end

      :error ->
        # Populate default values if specified
        if Map.has_key?(template, :default) do
          Map.put(acc, template[:field], template[:default])
        else
          acc
        end
    end
  end

  def append_conditionally(input_value, template, input_map) do
    if Map.has_key?(template, :append) && Map.has_key?(input_map, template[:append]) do
      input_value <> " " <> Map.get(input_map, template[:append])
    else
      input_value
    end
  end

  def prepend_conditionally(input_value, template) do
    if Map.has_key?(template, :prepend) && input_value != "" &&
         !String.starts_with?(input_value, template[:prepend]) do
      template[:prepend] <> input_value
    else
      input_value
    end
  end

  def trim_conditionally(input_value) do
    if is_binary(input_value) do
      String.trim(input_value)
    else
      input_value
    end
  end

  def fix_outcome(string) do
    string
    |> String.replace("LYCG interception", "interception_libya")
    |> String.replace("TNCG interception", "interception_tn")
    |> String.replace("NGO rescue", "ngo_rescue")
    |> String.replace("IT rescue", "italy_rescue")
    |> String.replace("Self return", "returned")
    |> String.downcase()
  end

  # Trys to parse the value using the type specified in the template.
  # If it fails the original value is returned with the key appended
  # with "_string"
  defp parse_values(value, template) do
    try do
      new_value =
        cond do
          Map.has_key?(template, :regex) ->
            apply_regex(template[:regex], value)

          Map.has_key?(template, :apply) ->
            apply(template[:apply], [value])

          Map.has_key?(template, :lowercase) ->
            String.downcase(value)

          Map.has_key?(template, :join) ->
            Enum.join(value, " ")

          true ->
            parse_value(value, template[:type])
        end

      {new_value, template[:key]}
    rescue
      error ->
        Logger.info("When processing #{value} as #{template[:type]}: Caught #{inspect(error)}")
        {value, template[:key] <> "_string"}
    end
  end

  defp apply_regex(regex, value) do
    case Regex.run(regex, value) do
      nil -> value
      matches -> Enum.join(matches, ", ")
    end
  end

  defp parse_value("", _), do: nil
  defp parse_value(value, :integer), do: String.to_integer(value)

  defp parse_value(value, :utc_datetime) do
    case DateTime.from_iso8601(value) do
      {:ok, datetime, _} ->
        datetime

      {:error, _} ->
        case Regex.match?(~r/^\d{2}\.\d{2}\.\d{4}$/, value) do
          true ->
            [day, month, year] = String.split(value, ".")

            {:ok, date} =
              Date.new(
                String.to_integer(year),
                String.to_integer(month),
                String.to_integer(day)
              )

            DateTime.new!(date, ~T[00:00:00])

          false ->
            raise(ArgumentError, "Could not parse #{value} as a DateTime")
        end
    end
  end

  defp parse_value(value, _type), do: value
end
