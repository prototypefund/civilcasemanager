defmodule EventsWeb.LiveComponents do
  use Phoenix.Component

  import Flop.Phoenix
  import EventsWeb.CoreComponents

  attr :fields, :list, required: true
  attr :meta, Flop.Meta, required: true
  attr :id, :string, default: nil
  attr :on_change, :string, default: "update-filter"
  attr :target, :string, default: nil

  def filter_form(%{meta: meta} = assigns) do
    assigns = assign(assigns, form: Phoenix.Component.to_form(meta), meta: nil)

    ~H"""
    <.form
      for={@form}
      id={@id}
      phx-target={@target}
      phx-change={@on_change}
      phx-submit={@on_change}
      class="flex"
    >
      <.filter_fields :let={i} form={@form} fields={@fields}>
        <.input
          field={i.field}
          label={i.label}
          type={i.type}
          phx-debounce={500}
          {i.rest}
        />
      </.filter_fields>

      <button class="button" name="reset">reset</button>
    </.form>
    """
  end

end
