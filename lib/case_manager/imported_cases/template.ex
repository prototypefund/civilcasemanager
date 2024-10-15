defmodule CaseManager.ImportedCases.Template do
  require Logger

  @template %{
    "Add info/summary/notes" => %{key: :notes, type: :string},
    "AP NR" => %{key: :name, type: :string},
    "BOAT COLOR" => %{key: :boat_color, type: :string, default: "unknown", lowercase: true},
    "BOAT TYPE" => %{key: :boat_type, type: :string, default: "unknown", lowercase: true},
    "Country. DEP" => %{key: :departure_region, type: :string},
    "DATE (rescued, arrived case closed)" => %{key: :time_of_disembarkation, type: :utc_datetime},
    "Date. DEP" => %{key: :time_of_departure, type: :utc_datetime, append_key: "time. DEP"},
    "DEAD max" => %{key: :people_dead, type: :integer},
    "DEAD Min" => %{key: :people_dead, type: :integer},
    "DEAD" => %{key: :people_dead, type: :integer},
    "DEAD CONFIRMED" => %{key: :people_dead, type: :integer},
    "Links " => %{key: :url, type: :string},
    "missing ppl MAX" => %{key: :people_missing, type: :integer},
    "missing ppl" => %{key: :people_missing, type: :integer},
    "missing ppl CONFIRMED" => %{key: :people_missing, type: :integer},
    "outcome" => %{
      key: :outcome,
      type: :string,
      default: "unknown",
      apply: &CaseManager.ImportedCases.Template.fix_outcome/1
    },
    "Place . DEP" => %{key: :place_of_departure, type: :string},
    "Place of disembarkation" => %{key: :place_of_disembarkation, type: :string},
    "POB Number MAX" => %{key: :pob_total, type: :integer},
    "POB Number MIN" => %{key: :pob_total, type: :integer},
    "number ppl" => %{key: :pob_total, type: :integer},
    "Nationalities" => %{key: :pob_per_nationality, type: :string, join: true},
    "nationalities" => %{key: :pob_per_nationality, type: :string, join: true},
    "POB Number CONFIRMED" => %{key: :pob_total, type: :integer},
    "SAR" => %{
      key: :sar_region,
      type: :string,
      default: "unknown",
      lowercase: true,
      prepend: "sar"
    },
    "Source" => %{key: :source, type: :string, regex: ~r/\bhttps?:\/\/\S+\b/},
    "THURAYA" => %{key: :phonenumber, type: :string},
    "1st position" => %{
      key: :first_position,
      type: :string,
      regex:
        ~r/([-+]?\d{1,2}\.\d+)[N]?,\s*([-+]?\d{1,3}\.\d+)[E]?\s*@\s*(\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2})/
    },
    "Last position" => %{
      key: :last_position,
      type: :string,
      regex:
        ~r/([-+]?\d{1,2}\.\d+)[N]?,\s*([-+]?\d{1,3}\.\d+)[E]?\s*@\s*(\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2})/
    }
  }

  @doc """
  Maps one input row onto the template structure.

  This function takes an input map, an index, and a year, and processes the input
  according to the defined template. It returns a map that can be used to create a new case.
  """
  def map_input_to_template(input_map, index, year \\ nil) do
    Enum.reduce(@template, %{}, fn {key, template}, acc ->
      process(input_map, key, template, acc)
    end)
    |> Map.put(:row, index)
    |> populate_occurred_at()
    |> put_formatted_name(year)
    |> CaseManager.DataQualityTools.update_imported_case(:place_of_departure, :departure_id)
    |> CaseManager.DataQualityTools.update_imported_case(:place_of_disembarkation, :arrival_id)
  end

  defp populate_occurred_at(acc) do
    cond do
      Map.has_key?(acc, :time_of_departure) ->
        Map.put(acc, :occurred_at, acc[:time_of_departure])

      Map.has_key?(acc, :time_of_disembarkation) ->
        Map.put(acc, :occurred_at, acc[:time_of_disembarkation])

      true ->
        acc
    end
  end

  def put_formatted_name(map, nil), do: map

  def put_formatted_name(%{name: name} = map, year) do
    Map.put(map, :name, format_name(name, year))
  end

  def put_formatted_name(map, _year), do: map

  def format_name(name, year) do
    number = if String.starts_with?(name, "AP"), do: String.slice(name, 2..-1//1), else: name
    "AP" <> String.pad_leading(number, 4, "0") <> "-" <> year
  end

  def process(input_map, key, template, acc) do
    with {:ok, input_value} <- Map.fetch(input_map, key),
         {new_value, key} <- process_value(input_value, template, input_map) do
      update_acc(acc, key, new_value, template)
    else
      :error -> insert_default_values_if_available(acc, template)
    end
  end

  defp process_value(input_value, template, input_map) do
    input_value
    |> lowercase_conditionally(template)
    |> append_conditionally(template, input_map)
    |> prepend_conditionally(template)
    |> trim_conditionally()
    |> parse_values(template)
  end

  defp update_acc(acc, key, new_value, template) do
    cond do
      empty?(new_value) && Map.has_key?(template, :default) ->
        Map.put(acc, key, template[:default])

      empty?(new_value) ->
        acc

      true ->
        Map.put(acc, key, new_value)
    end
  end

  defp empty?(value), do: value == "" || value == nil

  defp insert_default_values_if_available(acc, template) do
    if Map.has_key?(template, :default) do
      Map.put(acc, template[:key], template[:default])
    else
      acc
    end
  end

  defp lowercase_conditionally(input_value, template) do
    if Map.has_key?(template, :lowercase) && template[:lowercase] do
      String.downcase(input_value)
    else
      input_value
    end
  end

  def append_conditionally(input_value, template, input_map) do
    cond do
      Map.has_key?(template, :append) && Map.has_key?(input_map, template[:append]) ->
        input_value <> " " <> Map.get(input_map, template[:append])

      Map.has_key?(template, :append_key) && Map.has_key?(input_map, template[:append_key]) ->
        input_value <> " " <> to_string(Map.get(input_map, template[:append_key]))

      true ->
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

          Map.has_key?(template, :join) ->
            Enum.join(value, " ")

          true ->
            parse_value(value, template[:type])
        end

      {new_value, template[:key]}
    rescue
      error ->
        Logger.info("When processing #{value} as #{template[:type]}: Caught #{inspect(error)}")
        {value, String.to_atom(Atom.to_string(template[:key]) <> "_string")}
    end
  end

  defp apply_regex(regex, value) do
    case Regex.run(regex, value, capture: :all_but_first) do
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
        case Regex.match?(~r/^\d{2}\.\d{2}\.\d{4}(\s\d{2}:\d{2}(:\d{2})?)?$/, value) do
          true ->
            parse_complex_date(value)

          false ->
            raise(ArgumentError, "Could not parse #{value} as a DateTime")
        end
    end
  end

  defp parse_value(value, _type), do: value

  defp parse_complex_date(value) do
    [date_part | time_part] = String.split(value, " ")
    [day, month, year] = String.split(date_part, ".")

    time =
      case time_part do
        [] ->
          ~T[00:00:00]

        [time] ->
          case String.split(time, ":") do
            [hour, minute] ->
              Time.new!(String.to_integer(hour), String.to_integer(minute), 0)

            [hour, minute, second] ->
              Time.new!(
                String.to_integer(hour),
                String.to_integer(minute),
                String.to_integer(second)
              )
          end
      end

    {:ok, date} =
      Date.new(
        String.to_integer(year),
        String.to_integer(month),
        String.to_integer(day)
      )

    DateTime.new!(date, time)
  end
end
