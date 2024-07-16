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

    lat_decimal = dms_to_decimal(lat_deg, lat_min, lat_sec, lat_dir)
    lon_decimal = dms_to_decimal(lon_deg, lon_min, lon_sec, lon_dir)

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
    lat_dms = decimal_to_dms_string(lat, "NS")
    lon_dms = decimal_to_dms_string(lon, "EW")
    "#{lat_dms}, #{lon_dms}"
  end

  @doc """
  Converts a decimal coordinate to a degree/minute/second string.

  ## Examples

  iex> CaseManager.Geo.decimal_to_dms_string(34.27777777777778, "NS")
  "34° 14' 00\" N"

  iex> CaseManager.Geo.decimal_to_dms_string(-12.94722222222222, "EW")
  "12° 58' 00\" W"
  """
  def decimal_to_dms_string(decimal, directions) do
    {deg, min, sec, dir} = decimal_to_dms(decimal, directions)

    "#{String.pad_leading(Integer.to_string(deg), 2, "0")}° #{String.pad_leading(Integer.to_string(min), 2, "0")}' #{String.pad_leading(Integer.to_string(sec), 2, "0")}\" #{dir}"
  end

  @doc """
  Converts a decimal coordinate to a short string format (DEG MIN).

  ## Examples

  iex> CaseManager.Geo.decimal_to_short_string(34.27777777777778)
  "34 17"

  iex> CaseManager.Geo.decimal_to_short_string(-12.94722222222222)
  "12 57"
  """
  def decimal_to_short_string(decimal, directions \\ "NE") do
    {deg, min, sec, _dir} = decimal_to_dms(decimal, directions)
    rounded_min = min + round(sec)
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
    lat_short = decimal_to_short_string(lat)
    lon_short = decimal_to_short_string(lon)
    "#{lat_short} / #{lon_short}"
  end

  @doc """
  Converts a short string format (DEG MIN) to a decimal coordinate.
  The minute part can be either an integer or a float.

  ## Examples

  iex> CaseManager.Geo.short_string_to_decimal("34 17")
  34.28333333333333

  iex> CaseManager.Geo.short_string_to_decimal("12 57")
  12.95

  iex> CaseManager.Geo.short_string_to_decimal("34 17.5")
  34.29166666666667
  """
  def short_string_to_decimal(short_string) do
    [deg, min] = short_string |> String.trim() |> String.split()
    {deg, _} = Integer.parse(deg)
    {min, _} = Float.parse(min)
    deg + min / 60
  end

  @doc """
  Converts a combined short string format (DEG MIN / DEG MIN) to a tuple of decimal coordinates.

  ## Examples

  iex> CaseManager.Geo.combined_short_string_to_decimal("34 17 / 12 57")
  {34.28333333333333, 12.95}
  """
  def combined_short_string_to_decimal(combined_short_string) do
    [lat_string, lon_string] = String.split(combined_short_string, "/")
    lat = lat_string |> short_string_to_decimal()
    lon = lon_string |> short_string_to_decimal()
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
    lat = short_string_to_decimal(lat_string)
    lon = short_string_to_decimal(lon_string)
    %Geo.Point{coordinates: {lon, lat}, properties: %{}}
  end

  defp decimal_to_dms(decimal, directions) do
    abs_decimal = abs(decimal)
    deg = trunc(abs_decimal)
    min = trunc((abs_decimal - deg) * 60)
    sec = trunc(((abs_decimal - deg) * 60 - min) * 60)

    dir = if decimal >= 0, do: String.first(directions), else: String.last(directions)

    {deg, min, sec, dir}
  end

  defp parse_dms(dms) do
    case Regex.run(~r/(\d+)°\s*(\d+)['\‘]\s*(\d*)?\s*([NSEW])/, dms, capture: :all_but_first) do
      [deg, min, sec, dir] ->
        {String.to_integer(deg), String.to_integer(min), parse_seconds(sec), dir}
    end
  end

  ## Handle missing seconds
  defp parse_seconds(""), do: 0
  defp parse_seconds(sec), do: String.to_integer(sec)

  defp dms_to_decimal(deg, min, sec, dir) do
    decimal = deg + min / 60 + sec / 3600

    case dir do
      dir when dir in ["S", "W"] -> -decimal
      _ -> decimal
    end
  end
end
