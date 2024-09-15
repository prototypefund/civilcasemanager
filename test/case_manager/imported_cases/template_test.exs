defmodule CaseManager.ImportedCases.TemplateTest do
  use ExUnit.Case, async: true
  alias CaseManager.ImportedCases.Template

  describe "map_input_to_template/2" do
    test "processes input map and returns expected output" do
      input = %{
        "AP NR" => "123",
        "BOAT COLOR" => "Blue",
        "DATE (rescued, arrived case closed)" => "2023-05-01T12:00:00Z",
        "Nationalities" => ["Italian", "French"],
        "outcome" => "LYCG interception",
        "1st position" => "35.123N, 12.456E @ 2023-05-01T10:00:00"
      }

      result = Template.map_input_to_template(input, 1)

      assert result.name == "AP123"
      assert result.boat_color == "blue"
      assert result.time_of_disembarkation == ~U[2023-05-01 12:00:00Z]
      assert result.pob_per_nationality == "Italian French"
      assert result.outcome == "interception_libya"
      assert result.first_position == "35.123, 12.456, 2023-05-01T10:00:00"
      assert result.row == 1
      assert result.occurred_at == ~U[2023-05-01 12:00:00Z]
    end

    test "handles missing values and applies defaults" do
      input = %{
        "BOAT TYPE" => "",
        "SAR" => ""
      }

      result = Template.map_input_to_template(input, 2)

      refute Map.has_key?(result, nil)
      assert result.boat_type == "unknown"
      assert result.sar_region == "unknown"
      assert result.row == 2
    end

    test "processes date formats correctly" do
      input = %{
        "Date. DEP" => "01.05.2023",
        "time. DEP" => "10:30:00"
      }

      result = Template.map_input_to_template(input, 3)

      assert result.time_of_departure == ~U[2023-05-01 10:30:00Z]
      assert result.occurred_at == ~U[2023-05-01 10:30:00Z]
    end

    test "processes date formats correctly 2" do
      input = %{
        "Date. DEP" => "01.05.2023",
        "time. DEP" => "10:30"
      }

      result = Template.map_input_to_template(input, 3)

      refute Map.has_key?(result, nil)

      assert result.time_of_departure == ~U[2023-05-01 10:30:00Z]
      assert result.occurred_at == ~U[2023-05-01 10:30:00Z]
    end

    test "fallsback to string when it cannot parse date correctly" do
      input = %{
        "Date. DEP" => "01.05.2023",
        "time. DEP" => "456546546"
      }

      result = Template.map_input_to_template(input, 3)

      assert is_nil(Map.get(result, :time_of_departure))
      assert result.time_of_departure_string == "01.05.2023 456546546"
    end
  end

  describe "fix_outcome/1" do
    test "replaces known outcomes" do
      assert Template.fix_outcome("LYCG interception") == "interception_libya"
      assert Template.fix_outcome("TNCG interception") == "interception_tn"
      assert Template.fix_outcome("NGO rescue") == "ngo_rescue"
      assert Template.fix_outcome("IT rescue") == "italy_rescue"
      assert Template.fix_outcome("Self return") == "returned"
    end

    test "converts to lowercase" do
      assert Template.fix_outcome("UNKNOWN OUTCOME") == "unknown outcome"
    end
  end

  describe "process/4" do
    test "handles regex parsing" do
      input = %{"1st position" => "35.123N, 12.456E @ 2023-05-01T10:00:00"}

      template = %{
        key: :first_position,
        type: :string,
        regex:
          ~r/([-+]?\d{1,2}\.\d+)[N]?,\s*([-+]?\d{1,3}\.\d+)[E]?\s*@\s*(\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2})/
      }

      result = Template.process(input, "1st position", template, %{})

      assert result == %{first_position: "35.123, 12.456, 2023-05-01T10:00:00"}
    end

    test "handles custom apply function" do
      input = %{"outcome" => "LYCG interception"}
      template = %{key: :outcome, type: :string, apply: &Template.fix_outcome/1}

      result = Template.process(input, "outcome", template, %{})

      assert result == %{outcome: "interception_libya"}
    end
  end
end
