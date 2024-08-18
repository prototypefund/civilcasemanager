defmodule CaseManager.FormOptionsTest do
  use ExUnit.Case, async: true
  alias CaseManagerWeb.FormOptions

  describe "options_for_select_with_invalid/2" do
    test "returns empty options when both inputs are empty" do
      assert FormOptions.preprocess_options([], []) == []
    end

    test "returns allowed options when current value is empty" do
      allowed_options = ["Option1", "Option2"]
      result = FormOptions.preprocess_options(allowed_options, [])
      assert result == ["Option1", "Option2"]
    end

    test "returns allowed options when current value is in allowed options" do
      allowed_options = ["Option1", "Option2"]
      current_value = "Option1"
      result = FormOptions.preprocess_options(allowed_options, current_value)
      assert result == ["Option1", "Option2"]
    end

    test "handles nested allowed options correctly" do
      allowed_options = [
        colors: ["red", "green"],
        material: ["wood", "plastic"]
      ]

      current_value = "red"
      result = FormOptions.preprocess_options(allowed_options, current_value)
      assert result == [colors: ["red", "green"], material: ["wood", "plastic"]]
    end

    test "handles nested allowed options with invalid current value" do
      allowed_options = [
        colors: ["red", "green"],
        material: ["wood", "plastic"]
      ]

      current_value = "35345blue"
      result = FormOptions.preprocess_options(allowed_options, current_value)

      expected = [
        Valid: [colors: ["red", "green"], material: ["wood", "plastic"]],
        Invalid: ["35345blue"]
      ]

      assert result == expected
    end

    test "handles nested allowed options with valid current value from nested list" do
      allowed_options = [
        colors: ["red", "green"],
        material: ["wood", "plastic"]
      ]

      current_value = "plastic"
      result = FormOptions.preprocess_options(allowed_options, current_value)
      assert result == [colors: ["red", "green"], material: ["wood", "plastic"]]
    end

    test "returns grouped options with invalid when current value is not in allowed options" do
      allowed_options = ["Option1", "Option2"]
      current_value = "InvalidOption"
      result = FormOptions.preprocess_options(allowed_options, current_value)

      expected = [
        Valid: ["Option1", "Option2"],
        Invalid: ["InvalidOption"]
      ]

      assert result == expected
    end

    test "handles atom values correctly" do
      allowed_options = [:option1, :option2]
      current_value = :option1
      result = FormOptions.preprocess_options(allowed_options, current_value)
      assert result == [:option1, :option2]
    end

    test "converts string to existing atom" do
      allowed_options = [:option1, :option2]
      current_value = "option1"
      result = FormOptions.preprocess_options(allowed_options, current_value)
      assert result == [:option1, :option2]
    end

    test "keeps string as is when it's not an existing atom" do
      allowed_options = [:option1, :option2]
      current_value = "non_existing_atom"
      result = FormOptions.preprocess_options(allowed_options, current_value)

      expected = [
        Valid: [:option1, :option2],
        Invalid: ["non_existing_atom"]
      ]

      assert result == expected
    end

    test "value_in_list? returns true when option is in allowed options" do
      allowed_options = ["Option1", "Option2"]
      current_value = "Option1"
      assert FormOptions.value_in_list?(current_value, allowed_options) == true
    end

    test "value_in_list? returns false when option is not in allowed options" do
      allowed_options = ["Option1", "Option2"]
      current_value = "Option3"
      assert FormOptions.value_in_list?(current_value, allowed_options) == false
    end

    test "value_in_list? handles nested lists in allowed options" do
      allowed_options = [colors: ["red", "green"], material: ["wood", "plastic"]]
      current_value = "red"
      assert FormOptions.value_in_list?(current_value, allowed_options) == true
    end

    test "value_in_list? handles atom values" do
      allowed_options = [:option1, :option2]
      current_value = :option1
      assert FormOptions.value_in_list?(current_value, allowed_options) == true
    end

    test "value_in_list? works for options with keyword list" do
      allowed_options = [
        Afghanistan: :AF,
        "Åland Islands": :AX,
        Albania: :AL,
        Algeria: :DZ,
        "American Samoa": :AS
      ]

      assert FormOptions.value_in_list?(:AF, allowed_options)
      assert FormOptions.value_in_list?(:AX, allowed_options)
    end

    test "value_in_list? works for nested options with keyword list" do
      allowed_options = [
        countries: [
          Afghanistan: :AF,
          "Åland Islands": :AX,
          Albania: :AL,
          Algeria: :DZ,
          "American Samoa": :AS
        ],
        other_countries: [
          Antarctica: :AQ,
          Argentina: :AR,
          Armenia: :AM,
          Aruba: :AW
        ]
      ]

      assert FormOptions.value_in_list?(:AF, allowed_options)
      assert FormOptions.value_in_list?(:AX, allowed_options)
    end
  end
end
