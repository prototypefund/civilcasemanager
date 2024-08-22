defmodule CaseManager.DataQualityToolsTest do
  use CaseManager.DataCase

  import CaseManager.DataQualityTools
  alias CaseManager.CaseNationalities.CaseNationality

  describe "split_nationalities/1" do
    test "returns empty list for nil input" do
      assert {:ok, []} = split_nationalities(nil)
    end

    test "returns empty list for empty string input" do
      assert {:ok, []} = split_nationalities("")
    end

    test "parses single nationality correctly" do
      assert {:ok, [%CaseNationality{country: "US", count: 5}]} =
               split_nationalities("US:5")
    end

    test "parses multiple nationalities correctly" do
      input = "US:5;GB:3;FR:2"

      expected = [
        %CaseNationality{country: "US", count: 5},
        %CaseNationality{country: "GB", count: 3},
        %CaseNationality{country: "FR", count: 2}
      ]

      assert {:ok, ^expected} = split_nationalities(input)
    end

    test "handles unknown count correctly" do
      assert {:ok, [%CaseNationality{country: "US", count: nil}]} =
               split_nationalities("US:unknown")
    end

    test "handles null count correctly" do
      assert {:ok, [%CaseNationality{country: "US", count: nil}]} =
               split_nationalities("US:-")
    end

    test "returns error for invalid country code" do
      assert {:error, "Invalid format: USA:5"} = split_nationalities("USA:5")
    end

    test "returns error for invalid count" do
      assert {:error, "Cannot parse abc into a number."} =
               split_nationalities("US:abc")
    end

    test "returns error for first invalid entry in multiple nationalities" do
      assert {:error, "Invalid format: USA:5"} =
               split_nationalities("USA:5;GB:3,FR:2")
    end

    test "returns error for non-first invalid entry in multiple nationalities" do
      assert {:error, "Invalid format: USA:5"} =
               split_nationalities("GB:3;USA:5;FR:2")
    end

    test "handles missing count correctly" do
      input = "GB:;US:"

      expected = [
        %CaseNationality{country: "GB", count: nil},
        %CaseNationality{country: "US", count: nil}
      ]

      assert {:ok, ^expected} = split_nationalities(input)
    end
  end
end
