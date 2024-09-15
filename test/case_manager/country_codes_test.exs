defmodule CaseManager.CountryCodesTest do
  use ExUnit.Case, async: true
  alias CaseManager.CountryCodes

  describe "find_key_for_value/2" do
    test "returns key for matching value" do
      assert CountryCodes.find_key_for_value(:value, key: :value) == :key
    end

    test "returns nil when value not found" do
      assert CountryCodes.find_key_for_value(:not_found, key: :value) == nil
    end

    test "handles nested lists" do
      data = [a: [b: :target], c: :other]
      assert CountryCodes.find_key_for_value(:target, data) == :b
    end

    test "returns nil for empty list" do
      assert CountryCodes.find_key_for_value(:any, []) == nil
    end
  end

  describe "get_full_name/1" do
    test "returns 'Unknown' for nil input" do
      assert CountryCodes.get_full_name(nil) == "Unknown"
    end

    test "returns full name for valid country code" do
      # Assuming US is a valid country code in the list
      assert CountryCodes.get_full_name("US") == :"United States"
    end

    test "returns Stateless for XX country code" do
      assert CountryCodes.get_full_name("XX") == :Stateless
    end
  end
end
