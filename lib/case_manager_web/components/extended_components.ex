defmodule CaseManagerWeb.ExtendedComponents do
  use Phoenix.Component

  import Flop.Phoenix
  import CaseManagerWeb.CoreComponents
  alias Phoenix.LiveView.JS

  attr :fields, :list, required: true
  attr :meta, Flop.Meta, required: true
  attr :id, :string, default: nil
  attr :on_change, :string, default: "update-filter"
  attr :target, :string, default: nil
  attr :class, :string, default: nil

  def filter_form(%{meta: meta} = assigns) do
    assigns = assign(assigns, form: Phoenix.Component.to_form(meta), meta: nil)

    ~H"""
    <.form
      for={@form}
      id={@id}
      phx-target={@target}
      phx-change={@on_change}
      phx-submit={@on_change}
      class={["grid grid-cols-2 gap-x-4 gap-y-2", @class]}
    >
      <.filter_fields :let={i} form={@form} fields={@fields}>
        <.input
          field={i.field}
          label={i.label}
          type={i.type}
          phx-debounce={150}
          class="inline mr-0"
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

  attr :positions, :list

  def map(assigns) do
    ~H"""
    <div :if={length(@positions) > 0} class="container w-[100%] isolate">
      <div
        id="case-map"
        class="map w-full h-[400px] p-20"
        phx-hook="Leaflet"
        data-positions={Jason.encode!(@positions)}
      >
      </div>
    </div>
    """
  end

  def theme_toggle(assigns) do
    ~H"""
    <div class="relative" id="theme-toggle" phx-hook="ThemeToggle">
      <button
        type="button"
        phx-click={
          JS.toggle(
            to: "#theme-menu",
            in: {"ease-out duration-100", "opacity-0 scale-95", "opacity-100 scale-100"},
            out: {"ease-out duration-75", "opacity-100 scale-100", "opacity-0 scale-95"}
          )
        }
        class="flex items-center justify-center w-10 h-10 rounded-full focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-offset-gray-100 focus:ring-indigo-500"
      >
        <span class="sr-only">Toggle theme</span>
        <svg
          class="w-6 h-6 theme-icon light-icon"
          fill="none"
          viewBox="0 0 24 24"
          stroke="currentColor"
        >
          <path
            stroke-linecap="round"
            stroke-linejoin="round"
            stroke-width="2"
            d="M12 3v1m0 16v1m9-9h-1M4 12H3m15.364 6.364l-.707-.707M6.343 6.343l-.707-.707m12.728 0l-.707.707M6.343 17.657l-.707.707M16 12a4 4 0 11-8 0 4 4 0 018 0z"
          />
        </svg>
        <svg
          class="w-6 h-6 theme-icon text-orange-100 dark-icon"
          fill="none"
          viewBox="0 0 24 24"
          stroke="currentColor"
          style="display: none;"
        >
          <path
            stroke-linecap="round"
            stroke-linejoin="round"
            stroke-width="2"
            d="M20.354 15.354A9 9 0 018.646 3.646 9.003 9.003 0 0012 21a9.003 9.003 0 008.354-5.646z"
          />
        </svg>
        <svg
          viewBox="0 0 24 24"
          class="w-6 h-6 theme-icon system-icon"
          fill="none"
          viewBox="0 0 24 24"
          stroke="currentColor"
          style="display: none;"
        >
          <path
            d="M4 6a2 2 0 0 1 2-2h12a2 2 0 0 1 2 2v7a2 2 0 0 1-2 2H6a2 2 0 0 1-2-2V6Z"
            stroke-linecap="round"
            stroke-linejoin="round"
            stroke-width="2"
          />
          <path
            d="M14 15c0 3 2 5 2 5H8s2-2 2-5"
            stroke-linecap="round"
            stroke-linejoin="round"
            stroke-width="2"
          />
        </svg>
      </button>
      <div
        id="theme-menu"
        class=" absolute right-0 w-48 py-2 mt-2 bg-white rounded-md shadow-xl dark:bg-gray-800"
        style="display: none;"
      >
        <a
          href="#"
          phx-value-theme="light"
          class="block px-4 py-2 text-sm text-gray-700 hover:bg-gray-100 dark:text-gray-300 dark:hover:bg-gray-700"
          role="menuitem"
        >
          Light
        </a>
        <a
          href="#"
          phx-value-theme="dark"
          class="block px-4 py-2 text-sm text-gray-700 hover:bg-gray-100 dark:text-gray-300 dark:hover:bg-gray-700"
          role="menuitem"
        >
          Dark
        </a>
        <a
          href="#"
          phx-value-theme="system"
          class="block px-4 py-2 text-sm text-gray-700 hover:bg-gray-100 dark:text-gray-300 dark:hover:bg-gray-700"
          role="menuitem"
        >
          System
        </a>
      </div>
    </div>
    """
  end
end
