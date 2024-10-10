defmodule CaseManager.CasesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `CaseManager.Cases` context.
  """

  @doc """
  Generate a case.
  """
  def case_fixture(attrs \\ %{}) do
    {:ok, case} =
      attrs
      |> Enum.into(%{
        id: "CASE_DC0010",
        archived_at: ~U[2024-03-07 08:58:00Z],
        closed_at: ~U[2024-03-07 08:58:00Z],
        created_at: ~U[2024-03-07 08:58:00Z],
        deleted_at: ~U[2024-03-07 08:58:00Z],
        description: "some description",
        name: "DC0011-2020",
        notes: "Received call from PoB",
        is_archived: true,
        opened_at: ~U[2024-03-07 08:58:00Z],
        status: "open",
        title: "some title",
        updated_at: ~U[2024-03-07 08:58:00Z]
      })
      |> CaseManager.Cases.create_case()

    case
  end
end
