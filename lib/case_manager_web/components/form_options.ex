defmodule CaseManagerWeb.FormOptions do
  def options_for_select_with_invalid([], []) do
    Phoenix.HTML.Form.options_for_select([], [])
  end

  def options_for_select_with_invalid(allowed_options, []) do
    Phoenix.HTML.Form.options_for_select(allowed_options, [])
  end

  def options_for_select_with_invalid(allowed_options, current_value) do
    processed = to_atom_if_exists(current_value)
    new_options = preprocess_options(allowed_options, processed)

    Phoenix.HTML.Form.options_for_select(new_options, current_value)
  end

  def preprocess_options([], []), do: []

  @doc """
  Preprocesses options for select input.

  This function handles the preprocessing of options for a select input, considering
  both allowed options and the current value. It manages cases where the current value
  might not be in the list of allowed options.

  ## Parameters

    - allowed_options: List of allowed options for the select input
    - current_value: The current value of the select input

  ## Returns

    A list of preprocessed options. If the current value is not in the allowed options,
    it will be added under an "Invalid" group.

  ## Examples

      iex> preprocess_options(["option1", "option2"], "option1")
      ["option1", "option2"]

      iex> preprocess_options(["option1", "option2"], "invalid_option")
      [Valid: ["option1", "option2"], Invalid: [:invalid_option]]

  """

  def preprocess_options(allowed_options, current_value) do
    string = to_string(current_value)
    atom_or_string = to_atom_if_exists(current_value)

    if atom_or_string do
      valid =
        value_in_list?(atom_or_string, allowed_options) || value_in_list?(string, allowed_options)

      if valid do
        allowed_options
      else
        [
          Valid: allowed_options,
          Invalid: [
            atom_or_string
          ]
        ]
      end
    else
      allowed_options
    end
  end

  @doc """
  Recursively checks if the given value is in the list of allowed options.
  """
  def value_in_list?(value, list) when is_list(list) do
    check_value(value, list)
  end

  defp check_value(value, [{_group, items} | tail]) when is_list(items) do
    check_value(value, items) or check_value(value, tail)
  end

  defp check_value(value, [{_name, item} | tail]) do
    value == item or check_value(value, tail)
  end

  defp check_value(value, [head | tail]) do
    value == head or check_value(value, tail)
  end

  defp check_value(_value, []) do
    false
  end

  defp to_atom_if_exists(nil), do: nil

  defp to_atom_if_exists([]), do: nil

  defp to_atom_if_exists(value) when is_binary(value) do
    try do
      String.to_existing_atom(value)
    rescue
      _ -> value
    end
  end

  defp to_atom_if_exists(value), do: value
end
