defmodule CaseManager.Repo do
  Postgrex.Types.define(
    CaseManager.PostgresTypes,
    [Geo.PostGIS.Extension] ++ Ecto.Adapters.Postgres.extensions()
  )

  use Ecto.Repo,
    otp_app: :case_manager,
    adapter: Ecto.Adapters.Postgres,
    types: CaseManager.PostgresTypes
end
