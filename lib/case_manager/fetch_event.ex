defmodule CaseManager.FetchEvent do
  # Defines the structure for a generic FetchEvent, containing various fields related to event details
  defstruct type: "",
            body: "",
            from: "",
            title: "",
            received_at: DateTime.utc_now(),
            metadata: "",
            case: nil,
            cases: []
end
