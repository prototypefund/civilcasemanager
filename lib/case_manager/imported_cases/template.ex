defmodule CaseManager.ImportedCases.Template do
  require Logger

  @template %{
    "Add info/summary/notes" => %{key: "notes", type: :string},
    "AP NR" => %{key: "name", type: :string, prepend: "AP"},
    "BOAT COLOR" => %{key: "boat_color", type: :string, default: "unknown", lowercase: true},
    "BOAT TYPE" => %{key: "boat_type", type: :string, default: "unknown", lowercase: true},
    "Country. DEP" => %{key: "departure_region", type: :string},
    "DATE (rescued, arrived case closed)" => %{key: "occurred_at", type: :utc_datetime},
    "Date. DEP" => %{key: "time_of_departure", type: :utc_datetime, append_key: "time. DEP"},
    "DEAD max" => %{key: "people_dead", type: :integer},
    "DEAD Min" => %{key: "people_dead", type: :integer},
    "DEAD" => %{key: "people_dead", type: :integer},
    "DEAD CONFIRMED" => %{key: "people_dead", type: :integer},
    "Links " => %{key: "cloud_file_links", type: :string},
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

  def map_input_to_template(input_map) do
    Enum.reduce(@template, %{}, fn {key, template}, acc ->
      case Map.fetch(input_map, key) do
        {:ok, input_value} ->
          input_value =
            if Map.has_key?(template, :append_key) && Map.has_key?(input_map, template[:append]) do
              input_value <> " " <> Map.get(input_map, template[:append_key])
            else
              input_value
            end

          input_value =
            if Map.has_key?(template, :prepend) && input_value != "" do
              template[:prepend] <> input_value
            else
              input_value
            end

          input_value = String.trim(input_value)

          {new_value, key} = transform(input_value, template)

          case new_value do
            nil ->
              acc

            "" ->
              acc

            _ ->
              Map.put(acc, key, new_value)
          end

        :error ->
          # Populate default values if specified (currently unused)
          if Map.has_key?(template, :default) do
            Map.put(acc, template[:field], template[:default])
          else
            acc
          end
      end
    end)
    |> IO.inspect()
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
  defp transform(value, template) do
    try do
      new_value =
        cond do
          Map.has_key?(template, :regex) ->
            apply_regex(template[:regex], value)

          Map.has_key?(template, :apply) ->
            apply(template[:apply], [value])

          Map.has_key?(template, :lowercase) ->
            String.downcase(value)

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
      {:ok, datetime, _} -> datetime
      {:error, _} -> raise(ArgumentError, "Could not parse #{value} as a DateTime")
    end
  end

  defp parse_value(value, _type), do: value
end
