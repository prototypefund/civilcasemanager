defmodule Events.Cases.Status do
  use EctoEnum, values: [:draft, :open, :closed]
end
