%{
  configs: [
    %{
      name: "default",
      checks: %{
        disabled: [
          {Credo.Check.Readability.ModuleDoc, []},
          {Credo.Check.Design.TagTODO, []}
        ]
      }
    }
  ]
}
