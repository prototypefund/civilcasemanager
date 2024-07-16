defmodule CaseManager.GeoTools do
  @doc """
  Parses a degree/minute/second coordinate string into a Geo.Point.

  ## Examples

  iex> CaseManager.Geo.dms_to_point("34° 14‘ 00 N, 12° 58’ 00 E")
    %Geo.Point{coordinates: {12.94722222222222, 34.27777777777778}, properties: %{}}
  """

  def dms_to_point(dms_str) do
    [lat, lon] = String.split(dms_str, ",")
    {lat_deg, lat_min, lat_sec, lat_dir} = parse_dms(String.trim(lat))
    {lon_deg, lon_min, lon_sec, lon_dir} = parse_dms(String.trim(lon))

    lat_decimal = dms_to_float(lat_deg, lat_min, lat_sec, lat_dir)
    lon_decimal = dms_to_float(lon_deg, lon_min, lon_sec, lon_dir)

    %Geo.Point{coordinates: {lon_decimal, lat_decimal}, properties: %{}}
  end

  @doc """
  Converts a Geo.Point to a degree/minute/second coordinate string.

  ## Examples

  iex> point = %Geo.Point{coordinates: {12.94722222222222, 34.27777777777778}, properties: %{}}
  iex> CaseManager.Geo.point_to_dms_string(point)
  "34° 14' 00\" N, 12° 58' 00\" E"
  """
  def point_to_dms_string(%Geo.Point{coordinates: {lon, lat}}) do
    lat_dms = number_to_dms_string(lat, :lat)
    lon_dms = number_to_dms_string(lon, :lon)
    "#{lat_dms}, #{lon_dms}"
  end

  @doc """
  Converts a decimal coordinate to a degree/minute/second string.

  ## Examples

  iex> CaseManager.Geo.float_to_dms_string(34.27777777777778, :lat)
  "34° 14' 00\" N"

  iex> CaseManager.Geo.float_to_dms_string(-12.94722222222222, :lon)
  "12° 58' 00\" W"
  """
  def number_to_dms_string(decimal, directions) do
    {deg, min, sec, dir} = number_to_dms_with_direction(decimal, directions)

    "#{String.pad_leading(Integer.to_string(deg), 2, "0")}° #{String.pad_leading(Integer.to_string(min), 2, "0")}' #{String.pad_leading(Integer.to_string(sec), 2, "0")}\" #{dir}"
  end

  @doc """
  Converts a tuple of decimal coordinates {lat, lon} to a short string format (DEG MIN / DEG MIN).

  ## Examples

  iex> CaseManager.Geo.number_to_short_string({34.27777777777778, 12.94722222222222})
  "34 17 / 12 57"

  iex> CaseManager.Geo.number_to_short_string(34.27777777777778)
  "34 17"

  iex> CaseManager.Geo.number_to_short_string(-12.94722222222222)
  "12 57"
  """
  def number_to_short_string({lat, lon}) do
    lat_short = number_to_short_string(lat)
    lon_short = number_to_short_string(lon)
    "#{lat_short} / #{lon_short}"
  end

  def number_to_short_string(decimal) do
    {deg, min, sec} = number_to_dms(decimal)
    rounded_min = min + round(sec / 60)
    "#{deg} #{String.pad_leading(Integer.to_string(rounded_min), 2, "0")}"
  end

  @doc """
  Converts a Geo.Point to a short string format (DEG MIN / DEG MIN).

  ## Examples

  iex> point = %Geo.Point{coordinates: {12.94722222222222, 34.27777777777778}, properties: %{}}
  iex> CaseManager.Geo.point_to_short_string(point)
  "34 17 / 12 57"
  """
  def point_to_short_string(%Geo.Point{coordinates: {lon, lat}}) do
    lat_short = number_to_short_string(lat)
    lon_short = number_to_short_string(lon)
    "#{lat_short} / #{lon_short}"
  end

  @doc """
  Converts a short string format (DEG MIN) to a decimal coordinate.
  The minute part can be either an integer or a float.

  ## Examples

  iex> CaseManager.Geo.short_string_to_float("34 17")
  34.28333333333333

  iex> CaseManager.Geo.short_string_to_float("12 57")
  12.95

  iex> CaseManager.Geo.short_string_to_float("34 17.5")
  34.29166666666667
  """
  def short_string_to_float(short_string) do
    [deg, min] = short_string |> String.trim() |> String.split()
    {deg, _} = Integer.parse(deg)
    {min, _} = Float.parse(min)

    # Don't accept negative minutes
    if min < 0 do
      raise ArgumentError, message: "Minutes must be positive"
    end

    # Don't accept minutes greater than 60
    if min > 60 do
      raise ArgumentError, message: "Minutes must be less than 60"
    end

    # Depending on the negative sign of the degree, the minutes need to be added or subtracted
    if deg >= 0 do
      deg + min / 60
    else
      deg - min / 60
    end
  end

  @doc """
  Converts a combined short string format (DEG MIN / DEG MIN) to a tuple of decimal coordinates.

  ## Examples

  iex> CaseManager.Geo.combined_short_string_to_float("34 17 / 12 57")
  {34.28333333333333, 12.95}
  """
  def combined_short_string_to_float(combined_short_string) do
    [lat_string, lon_string] = String.split(combined_short_string, "/")
    lat = lat_string |> short_string_to_float()
    lon = lon_string |> short_string_to_float()
    {lat, lon}
  end

  @doc """
  Converts a short string format (DEG MIN / DEG MIN) to a Geo.Point.

  ## Examples

  iex> CaseManager.Geo.short_string_to_point("34 17 / 12 57")
  %Geo.Point{coordinates: {12.95, 34.28333333333333}, properties: %{}}
  """
  def short_string_to_point(short_string) do
    [lat_string, lon_string] = String.split(short_string, " / ")
    lat = short_string_to_float(lat_string)
    lon = short_string_to_float(lon_string)
    %Geo.Point{coordinates: {lon, lat}, properties: %{}}
  end

  defp number_to_dms(%Decimal{} = decimal) do
    ## Convert to float and continue normally
    float = Decimal.to_float(decimal)
    number_to_dms(float)
  end

  defp number_to_dms(float) when is_float(float) do
    abs_float = abs(float)
    deg = trunc(float)
    abs_deg = abs(deg)
    min = trunc((abs_float - abs_deg) * 60)
    sec = round(((abs_float - abs_deg) * 60 - min) * 60)

    {deg, min, sec}
  end

  defp number_to_dms_with_direction(%Decimal{} = decimal, direction) do
    ## Convert to float and continue normally
    float = Decimal.to_float(decimal)

    number_to_dms_with_direction(float, direction)
  end

  defp number_to_dms_with_direction(float, direction) when is_float(float) do
    abs_float = abs(float)
    deg = trunc(abs_float)
    min = trunc((abs_float - deg) * 60)
    sec = trunc(((abs_float - deg) * 60 - min) * 60)

    dir = get_dms_direction(direction, float >= 0)

    {deg, min, sec, dir}
  end

  defp parse_dms(dms) do
    case Regex.run(~r/(\d+)°\s*(\d+)['\‘]\s*(\d*)?\s*([NSEW])/, dms, capture: :all_but_first) do
      [deg, min, sec, dir] ->
        {String.to_integer(deg), String.to_integer(min), parse_seconds(sec), dir}
    end
  end

  defp get_dms_direction(key, positive) do
    cond do
      key == :lat && positive -> "N"
      key == :lat && !positive -> "S"
      key == :lon && positive -> "E"
      key == :lon && !positive -> "W"
    end
  end

  ## Handle missing seconds
  defp parse_seconds(""), do: 0
  defp parse_seconds(sec), do: String.to_integer(sec)

  defp dms_to_float(deg, min, sec, dir) do
    decimal = deg + min / 60 + sec / 3600

    case dir do
      dir when dir in ["S", "W"] -> -decimal
      _ -> decimal
    end
  end
end
