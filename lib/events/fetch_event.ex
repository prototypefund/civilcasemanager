defmodule Events.FetchEvent do
  defstruct [
    type: "",
    body: "",
    from: "",
    title: "",
    received_at: DateTime.utc_now(),
    metadata: "",
    case_data: nil
  ]
end
