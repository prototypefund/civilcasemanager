defmodule CaseManagerWeb.ImportedCaseLive.Upload do
  use CaseManagerWeb, :live_view

  @impl Phoenix.LiveView
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:uploaded_files, [])
     |> allow_upload(:avatar, accept: [".csv"], max_entries: 1)}
  end

  @impl Phoenix.LiveView
  def handle_event("validate", _params, socket) do
    {:noreply, socket}
  end

  @impl Phoenix.LiveView
  def handle_event("cancel-upload", %{"ref" => ref}, socket) do
    {:noreply, cancel_upload(socket, :avatar, ref)}
  end

  @impl Phoenix.LiveView
  def handle_event("save", _params, socket) do
    uploaded_files =
      consume_uploaded_entries(socket, :avatar, fn %{path: path}, _entry ->
        File.stream!(path)
        ## AP Template contains additional header in the first row
        |> Stream.drop(1)
        |> CSV.decode(headers: true)
        |> batch_import()
      end)
      |> hd()

    {result_code, result_string} =
      analyse_import_result(uploaded_files) |> get_string_from_counts()

    {
      :noreply,
      socket
      |> update(:uploaded_files, &(&1 ++ uploaded_files))
      |> put_flash(result_code, result_string)
      # |> push_patch(to: socket.assigns.patch)
    }
  end

  ## Walk throught the enumerable and create a list of ImportedCase structs
  defp batch_import(stream) do
    case_list =
      Enum.map(stream, fn {:ok, row} ->
        CaseManager.ImportedCases.Template.map_input_to_template(row)
      end)

    CaseManager.ImportedCases.create_imported_cases_from_list(case_list)
  end

  ## Loop through the results and count the numer of :ok and :error tuples. If
  ## error, then take not of the row.
  defp analyse_import_result(uploaded_files) do
    with_index = Enum.with_index(uploaded_files, fn element, index -> {index, element} end)

    failed_rows =
      Enum.filter(with_index, fn {_, {status, _}} -> status == :error end)
      |> IO.inspect()
      |> Enum.map(fn {index, _} -> index end)

    failed_count = Enum.count(failed_rows)
    success_count = Enum.count(uploaded_files) - failed_count

    result_code = if failed_count > 0, do: :error, else: :info

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
        0 -> ""
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
end
