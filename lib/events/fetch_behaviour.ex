defmodule Events.FetchBehaviour do
  @callback start_link(opts :: Keyword.t()) :: {:ok, pid} | {:error, reason :: term}
  @callback fetch_data(opts :: Keyword.t()) :: {:ok, data :: any} | {:error, reason :: term}
end
