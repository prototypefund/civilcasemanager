defmodule CaseManager.DeletedCasesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `CaseManager.DeletedCases` context.
  """

  @doc """
  Generate a deleted_case.
  """
  def deleted_case_fixture(attrs \\ %{}) do
    {:ok, deleted_case} =
      attrs
      |> Enum.into(%{
        id: "A0000"
      })
      |> CaseManager.DeletedCases.create_deleted_case()

    deleted_case
  end
end
