defmodule CaseManager.GeoToolsTest do
  use ExUnit.Case
  alias CaseManager.GeoTools

  describe "dms_to_point/1" do
    test "converts valid DMS string to Geo.Point" do
      assert GeoTools.dms_to_point("34° 14' 00 N, 12° 58' 00 E") == %Geo.Point{
               coordinates: {12.966666666666667, 34.233333333333334},
               properties: %{}
             }
    end

    test "handles negative coordinates" do
      assert GeoTools.dms_to_point("34° 14' 00 S, 12° 58' 00 W") == %Geo.Point{
               coordinates: {-12.966666666666667, -34.233333333333334},
               properties: %{}
             }
    end

    test "raises error for invalid DMS string" do
      assert_raise MatchError, fn ->
        GeoTools.dms_to_point("Invalid DMS string")
      end
    end

    test "handles unexpected whitespaces in the input string" do
      assert GeoTools.dms_to_point("  34°   14'   00   N  ,  12°   58'   00   E  ") == %Geo.Point{
               coordinates: {12.966666666666667, 34.233333333333334},
               properties: %{}
             }
    end

    test "handles missing seconds in the DMS string" do
      assert GeoTools.dms_to_point("34° 14' N, 12° 58' E") == %Geo.Point{
               coordinates: {12.966666666666667, 34.233333333333334},
               properties: %{}
             }
    end
  end

  describe "point_to_dms_string/1" do
    test "converts Geo.Point to DMS string" do
      point = %Geo.Point{coordinates: {12.966666666666667, 34.233333333333334}, properties: %{}}
      assert GeoTools.point_to_dms_string(point) == "34° 14' 00\" N, 12° 58' 00\" E"
    end

    test "handles negative coordinates" do
      point = %Geo.Point{coordinates: {-12.966666666666667, -34.233333333333334}, properties: %{}}
      assert GeoTools.point_to_dms_string(point) == "34° 14' 00\" S, 12° 58' 00\" W"
    end
  end

  describe "number_to_dms_string/2" do
    test "converts positive decimal to DMS string" do
      assert GeoTools.number_to_dms_string(34.233333333333334, :lat) == "34° 14' 00\" N"
    end

    test "converts negative decimal to DMS string" do
      assert GeoTools.number_to_dms_string(-12.966666666666667, :lon) == "12° 58' 00\" W"
    end

    test "handles Decimal input" do
      assert GeoTools.number_to_dms_string(Decimal.new("34.233333333333334"), :lat) ==
               "34° 14' 00\" N"

      assert GeoTools.number_to_dms_string(Decimal.new("-12.966666666666667"), :lon) ==
               "12° 58' 00\" W"
    end
  end

  describe "number_to_short_string/2" do
    test "converts positive decimal to short string" do
      assert GeoTools.number_to_short_string(34.233333333333334) == "34 14 00"
    end

    test "rounds seconds correctly" do
      assert GeoTools.number_to_short_string(12.7333333333333) == "12 44 00"
    end

    test "converts negative decimal to short string" do
      assert GeoTools.number_to_short_string(-12.966666666666667) == "-12 58 00"
    end

    test "converts tuple of decimals to short string" do
      assert GeoTools.number_to_short_string({34.233333333333334, 12.966666666666667}) ==
               "34 14 00 / 12 58 00"
    end

    test "handles negative coordinates in tuple" do
      assert GeoTools.number_to_short_string({-34.233333333333334, -12.966666666666667}) ==
               "-34 14 00 / -12 58 00"
    end

    test "handles tuple of Decimal.new numbers" do
      assert GeoTools.number_to_short_string(
               {Decimal.new("34.233333333333334"), Decimal.new("12.966666666666667")}
             ) == "34 14 00 / 12 58 00"
    end
  end

  describe "point_to_short_string/1" do
    test "converts Geo.Point to short string" do
      point = %Geo.Point{coordinates: {12.43725628, 34.233333333333334}, properties: %{}}
      assert GeoTools.point_to_short_string(point) == "34 14 00 / 12 26 14"
    end
  end

  describe "short_string_to_float/1" do
    test "converts short string to decimal" do
      assert GeoTools.short_string_to_float("34 14") == 34.233333333333334
    end

    test "handles leading zeros" do
      assert GeoTools.short_string_to_float("05 08") == 5.133333333333334
    end

    test "handles unexpected whitespaces" do
      assert GeoTools.short_string_to_float("  34  14  ") == 34.233333333333334
      assert GeoTools.short_string_to_float(" 05   08 ") == 5.133333333333334
    end

    test "handles negative degrees" do
      assert GeoTools.short_string_to_float("-34 14") == -34.233333333333334
    end

    test "refuses negative minutes" do
      assert_raise ArgumentError, fn ->
        GeoTools.short_string_to_float("34 -14")
      end
    end

    test "refuses minutes larger 60" do
      assert_raise ArgumentError, fn ->
        GeoTools.short_string_to_float("34 61")
      end
    end

    test "converts short string with seconds to decimal" do
      assert GeoTools.short_string_to_float("34 14 20") == 34.23888888888889
    end

    test "handles leading zeros in seconds" do
      assert GeoTools.short_string_to_float("05 08 05") == 5.134722222222223
    end

    test "handles unexpected whitespaces with seconds" do
      assert GeoTools.short_string_to_float("  34  14  20  ") == 34.23888888888889
    end

    test "handles negative degrees with seconds" do
      assert GeoTools.short_string_to_float("-34 14 20") == -34.23888888888889
    end

    test "refuses negative seconds" do
      assert_raise ArgumentError, fn ->
        GeoTools.short_string_to_float("34 14 -20")
      end
    end

    test "refuses seconds larger than 60" do
      assert_raise ArgumentError, fn ->
        GeoTools.short_string_to_float("34 14 61")
      end
    end

    test "handles short string with hour and decimal minutes" do
      assert GeoTools.short_string_to_float("34 32.11") == 34.53516666666667
    end
  end

  describe "combined_short_string_to_float/1" do
    test "converts combined short string to decimal tuple" do
      assert GeoTools.combined_short_string_to_float("34 14 / 12 58") ==
               {34.233333333333334, 12.966666666666667}
    end

    test "handles unexpected whitespaces" do
      assert GeoTools.combined_short_string_to_float("  34  14  /   12  58  ") ==
               {34.233333333333334, 12.966666666666667}
    end

    test "handles floating point minute" do
      assert GeoTools.combined_short_string_to_float("34 14.5 / 12 58.25") ==
               {34.24166666666667, 12.970833333333333}
    end

    test "converts combined short string with seconds to decimal tuple" do
      assert GeoTools.combined_short_string_to_float("34 14 20 / 12 58 30") ==
               {34.23888888888889, 12.975}
    end

    test "handles unexpected whitespaces with seconds" do
      assert GeoTools.combined_short_string_to_float("  34  14  20  /   12  58  30  ") ==
               {34.23888888888889, 12.975}
    end

    test "handles leading zeros in seconds" do
      assert GeoTools.combined_short_string_to_float("05 08 05 / 01 02 03") ==
               {5.134722222222223, 1.0341666666666667}
    end

    test "handles negative degrees with seconds" do
      assert GeoTools.combined_short_string_to_float("-34 14 20 / -12 58 30") ==
               {-34.23888888888889, -12.975}
    end

    test "refuses negative seconds" do
      assert_raise ArgumentError, fn ->
        GeoTools.combined_short_string_to_float("34 14 -20 / 12 58 30")
      end
    end

    test "refuses degrees > 180" do
      assert_raise ArgumentError, fn ->
        GeoTools.combined_short_string_to_float("181 00 00 / 0 00 00")
      end

      assert_raise ArgumentError, fn ->
        GeoTools.combined_short_string_to_float("0 00 00 / 190 00 00")
      end
    end

    test "handles short code with decimal degrees" do
      assert GeoTools.combined_short_string_to_float("23.33 / 11.57") ==
               {23.33, 11.57}
    end

    test "handles strings with degree symbols and ticks" do
      assert GeoTools.combined_short_string_to_float("34° 14' 20\" / 12° 58' 30\"") ==
               {34.23888888888889, 12.975}
    end

    test "handles strings with degree symbols, ticks, and whitespace variations" do
      assert GeoTools.combined_short_string_to_float("  34°  14'  20\"  /   12°  58'  30\"  ") ==
               {34.23888888888889, 12.975}
    end

    test "handles strings with degree symbols and ticks for decimal minutes" do
      assert GeoTools.combined_short_string_to_float("34° 14.5' / 12° 58.25'") ==
               {34.24166666666667, 12.970833333333333}
    end

    test "handles strings with degree symbols and N/E direction indicators" do
      assert GeoTools.combined_short_string_to_float("34° 14.5' N / 12° 58.25' E") ==
               {34.24166666666667, 12.970833333333333}
    end
  end

  describe "stability of short string conversion" do
    test "short string to decimal and back becomes stable after first round" do
      initial_short_string = "34 14 00"
      decimal = GeoTools.short_string_to_float(initial_short_string)
      first_round_short_string = GeoTools.number_to_short_string(decimal)
      assert first_round_short_string == initial_short_string

      second_round_decimal = GeoTools.short_string_to_float(first_round_short_string)
      second_round_short_string = GeoTools.number_to_short_string(second_round_decimal)
      assert second_round_short_string == first_round_short_string

      third_round_decimal = GeoTools.short_string_to_float(second_round_short_string)
      third_round_short_string = GeoTools.number_to_short_string(third_round_decimal)
      assert third_round_short_string == second_round_short_string
    end

    test "stability with negative values" do
      initial_short_string = "-12 58 00"
      decimal = GeoTools.short_string_to_float(initial_short_string)
      first_round_short_string = GeoTools.number_to_short_string(decimal)
      assert first_round_short_string == initial_short_string

      second_round_decimal = GeoTools.short_string_to_float(first_round_short_string)
      second_round_short_string = GeoTools.number_to_short_string(second_round_decimal)
      assert second_round_short_string == first_round_short_string
    end
  end

  describe "short_string_to_point/1" do
    test "converts short string to Geo.Point" do
      assert GeoTools.short_string_to_point("34 14 / 12 58") == %Geo.Point{
               coordinates: {12.966666666666667, 34.233333333333334},
               properties: %{}
             }
    end
  end
end
