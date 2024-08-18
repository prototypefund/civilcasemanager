defmodule CaseManager.CaseNationalitiesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `CaseManager.CaseNationalities` context.
  """

  @doc """
  Generate a case_nationality.
  """
  def case_nationality_fixture(attrs \\ %{}) do
    case = CaseManager.CasesFixtures.case_fixture()

    {:ok, case_nationality} =
      attrs
      |> Enum.into(%{
        count: 42,
        country: "IT",
        case_id: case.id
      })
      |> CaseManager.CaseNationalities.create_case_nationality()

    case_nationality
  end
end
