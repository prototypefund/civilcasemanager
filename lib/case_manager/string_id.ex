defmodule CaseManager.StringId do
  use Ecto.Type
  def type, do: :string
  def cast(uuid), do: {:ok, uuid}
  def dump(uuid), do: {:ok, uuid}
  def load(uuid), do: {:ok, uuid}
  def autogenerate, do: Ecto.UUID.generate()
end
