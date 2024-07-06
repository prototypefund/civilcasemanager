defmodule CaseManager.FetchEvent do
  defstruct type: "",
            body: "",
            from: "",
            title: "",
            received_at: DateTime.utc_now(),
            metadata: "",
            case: nil,
            cases: []
end
