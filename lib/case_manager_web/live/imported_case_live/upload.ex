defmodule CaseManagerWeb.ImportedCaseLive.Upload do
  use CaseManagerWeb, :live_view

  @impl Phoenix.LiveView
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:uploaded_files, [])
     |> assign(:years, get_possible_years())
     |> allow_upload(:csv, accept: [".csv"], max_entries: 1)}
  end

  @impl Phoenix.LiveView
  def handle_event("validate", _params, socket) do
    {:noreply, socket}
  end

  @impl Phoenix.LiveView
  def handle_event("cancel-upload", %{"ref" => ref}, socket) do
    {:noreply, cancel_upload(socket, :csv, ref)}
  end

  @impl Phoenix.LiveView
  def handle_event("save", params, socket) do
    CaseManagerWeb.UserLive.Auth.run_if_user_can_write(socket, Upload, fn ->
      uploaded_files =
        consume_uploaded_entries(socket, :csv, fn %{path: path}, _entry ->
          File.stream!(path)
          ## AP Template contains additional header in the first row
          |> Stream.drop(1)
          |> CSV.decode(headers: true)
          ## In total there are two headers so we offset the index so that
          ## the resulting row index is the same as in Excel.
          |> Stream.with_index(2)
          |> batch_import(params["year"])
        end)
        |> hd()

      {result_code, result_string} =
        analyse_import_result(uploaded_files) |> get_string_from_counts()

      {
        :noreply,
        socket
        |> update(:uploaded_files, &(&1 ++ uploaded_files))
        |> put_flash(result_code, result_string)
      }
    end)
  end

  ## Walk throught the enumerable and create a list of ImportedCase structs
  defp batch_import(stream, year) do
    case_list =
      Enum.map(stream, fn {{:ok, content}, index} ->
        CaseManager.ImportedCases.Template.map_input_to_template(content, index, year)
      end)

    CaseManager.ImportedCases.create_imported_cases_from_list(case_list)
  end

  ## Loop through the results and count the numer of :ok and :error tuples. If
  ## error, then take not of the row.
  defp analyse_import_result(uploaded_files) do
    with_index = Enum.with_index(uploaded_files, fn element, index -> {index, element} end)

    failed_rows =
      Enum.filter(with_index, fn {_, {status, _}} -> status == :error end)
      |> Enum.map(fn {index, _} -> index end)

    failed_count = Enum.count(failed_rows)
    success_count = Enum.count(uploaded_files) - failed_count

    result_code = if failed_count > 0 || success_count == 0, do: :warning, else: :info

    {result_code, success_count, failed_count, failed_rows}
  end

  defp get_string_from_counts({
         result_code,
         success_count,
         failed_count,
         failed_rows
       }) do
    success_string =
      case success_count do
        0 -> "No valid rows found"
        1 -> "1 row imported"
        _ -> "#{success_count} rows imported"
      end

    failed_string =
      case failed_count do
        0 -> ""
        1 -> "1 row failed"
        _ -> "#{failed_count} rows failed"
      end

    failed_rows = failed_rows |> Enum.map_join(", ", &"#{Integer.to_string(&1)}")
    failed_rows_string = if failed_rows == "", do: "", else: "Failed rows: #{failed_rows}"

    result_string = "#{success_string} #{failed_string} #{failed_rows_string}"
    {result_code, result_string}
  end

  @doc """
  Get the year in UTC now
  """
  def get_current_year(), do: Date.utc_today().year

  @doc """
  Returns a a list of the current year and four years before that.

  ## Examples

      iex> get_possible_years()
      2019..2024  # Assuming the current year is 2024

  """
  def get_possible_years() do
    current_year = get_current_year()
    (current_year - 5)..current_year
  end
end
