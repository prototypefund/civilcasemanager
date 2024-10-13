defmodule SlackImporterTest do
  use ExUnit.Case
  import CaseManager.Datasources.SlackImporter

  test "normalize_identifier/2 returns correct identifier" do
    assert normalize_identifier("AP123", ~U[2023-01-01 00:00:00Z]) == "AP123-2023"
    assert normalize_identifier("AP 123", ~U[2023-01-01 00:00:00Z]) == "AP 123-2023"
    assert normalize_identifier("123-2024", ~U[2023-01-01 00:00:00Z]) == "123-2024"

    assert normalize_identifier("123-2024-extra", ~U[2023-01-01 00:00:00Z]) ==
             "123-2024-extra"
  end
end
