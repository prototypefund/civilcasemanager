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
    processed = to_atom_if_exists(current_value)

    if processed do
      valid = valid_option?(allowed_options, current_value, processed)

      if valid do
        allowed_options
      else
        [
          Valid: allowed_options,
          Invalid: [
            processed
          ]
        ]
      end
    else
      allowed_options
    end
  end

  @doc """
  Checks if the given option is valid in the list of allowed options.
  The function checks for validity both as a string and as an atom.

  ## Parameters

    - allowed_options: List of allowed options
    - current_value: The value to check for validity
    - processed: The atom representation of current_value (if it exists)

  ## Returns

    - true if the option is valid, false otherwise
  """

  def valid_option?(allowed_options, current_value, processed) do
    Enum.any?(allowed_options, fn
      {_key, values} when is_list(values) -> processed in values || current_value in values
      value -> processed == value || current_value == value
    end)
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
