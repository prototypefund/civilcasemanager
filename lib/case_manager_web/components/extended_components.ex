defmodule CaseManagerWeb.ExtendedComponents do
  use Phoenix.Component

  import Flop.Phoenix
  import CaseManagerWeb.CoreComponents

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
      class="flex flex-wrap gap-x-4"
    >
      <.filter_fields :let={i} form={@form} fields={@fields}>
        <.input
          field={i.field}
          label={i.label}
          type={i.type}
          phx-debounce={150}
          class="inline w-auto mr-4"
          label_class="mr-2 inline"
          {i.rest}
        />
      </.filter_fields>
      <!--<button class="button hero-x-circle-solid" name="reset">reset</button>-->
    </.form>
    """
  end

  attr :nationalities, :any, required: true
  attr :use_bold, :boolean, default: false

  def nationalities_summary(assigns) do
    ~H"""
    <%= if is_list(@nationalities) and length(@nationalities) > 0 do %>
      <%= for {%CaseManager.CaseNationalities.CaseNationality{} = nat, index} <- Enum.with_index(@nationalities) do %>
        <%= if index > 0 do %>
          ,
        <% end %>
        <span class={@use_bold && "font-bold"}>
          <%= CaseManager.CountryCodes.get_full_name(nat.country) %>:
        </span>
        <%= nat.count || "?" %>
      <% end %>
    <% else %>
      None
    <% end %>
    """
  end
end
