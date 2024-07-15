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

  describe "decimal_to_dms_string/2" do
    test "converts positive decimal to DMS string" do
      assert GeoTools.decimal_to_dms_string(34.233333333333334, "NS") == "34° 14' 00\" N"
    end

    test "converts negative decimal to DMS string" do
      assert GeoTools.decimal_to_dms_string(-12.966666666666667, "EW") == "12° 58' 00\" W"
    end
  end

  describe "decimal_to_short_string/2" do
    test "converts positive decimal to short string" do
      assert GeoTools.decimal_to_short_string(34.233333333333334) == "34 14"
    end

    test "converts negative decimal to short string" do
      assert GeoTools.decimal_to_short_string(-12.966666666666667) == "12 58"
    end
  end

  describe "point_to_short_string/1" do
    test "converts Geo.Point to short string" do
      point = %Geo.Point{coordinates: {12.966666666666667, 34.233333333333334}, properties: %{}}
      assert GeoTools.point_to_short_string(point) == "34 14 / 12 58"
    end
  end

  describe "short_string_to_decimal/1" do
    test "converts short string to decimal" do
      assert GeoTools.short_string_to_decimal("34 14") == 34.233333333333334
    end

    test "handles leading zeros" do
      assert GeoTools.short_string_to_decimal("05 08") == 5.133333333333334
    end
  end

  describe "combined_short_string_to_decimal/1" do
    test "converts combined short string to decimal tuple" do
      assert GeoTools.combined_short_string_to_decimal("34 14 / 12 58") ==
               {34.233333333333334, 12.966666666666667}
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
