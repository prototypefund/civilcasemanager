defmodule CaseManagerWeb.CoreComponents do
  @moduledoc """
  Provides core UI components.

  At first glance, this module may seem daunting, but its goal is to provide
  core building blocks for your application, such as modals, tables, and
  forms. The components consist mostly of markup and are well-documented
  with doc strings and declarative assigns. You may customize and style
  them in any way you want, based on your application growth and needs.

  The default components use Tailwind CSS, a utility-first CSS framework.
  See the [Tailwind CSS documentation](https://tailwindcss.com) to learn
  how to customize them or feel free to swap in another framework altogether.

  Icons are provided by [heroicons](https://heroicons.com). See `icon/1` for usage.
  """
  use Phoenix.Component

  alias Phoenix.LiveView.JS
  import CaseManagerWeb.Gettext

  @doc """
  Renders a modal.

  ## Examples

      <.modal id="confirm-modal">
        This is a modal.
      </.modal>

  JS commands may be passed to the `:on_cancel` to configure
  the closing/cancel event, for example:

      <.modal id="confirm" on_cancel={JS.navigate(~p"/posts")}>
        This is another modal.
      </.modal>

  """
  attr :id, :string, required: true
  attr :show, :boolean, default: false
  attr :on_cancel, JS, default: %JS{}
  slot :inner_block, required: true

  def modal(assigns) do
    ~H"""
    <div
      id={@id}
      phx-mounted={@show && show_modal(@id)}
      phx-remove={hide_modal(@id)}
      data-cancel={JS.exec(@on_cancel, "phx-remove")}
      class="relative z-50 hidden"
    >
      <div
        id={"#{@id}-bg"}
        class="bg-zinc-50/90 dark:bg-zinc-500/90 fixed inset-0 transition-opacity"
        aria-hidden="true"
      />
      <div
        class="fixed inset-0 overflow-y-auto"
        aria-labelledby={"#{@id}-title"}
        aria-describedby={"#{@id}-description"}
        role="dialog"
        aria-modal="true"
        tabindex="0"
      >
        <div class="flex min-h-full items-center justify-center">
          <div class="w-full max-w-3xl p-4 sm:p-6 lg:py-8">
            <.focus_wrap
              id={"#{@id}-container"}
              phx-window-keydown={JS.exec("data-cancel", to: "##{@id}")}
              phx-key="escape"
              class="shadow-zinc-700/10 ring-zinc-700/10 relative hidden rounded-2xl bg-white dark:bg-black p-14 shadow-lg ring-1 transition"
            >
              <div class="absolute top-6 right-5">
                <button
                  phx-click={JS.exec("data-cancel", to: "##{@id}")}
                  data-confirm="Changes will be lost, are you sure?"
                  type="button"
                  class="-m-3 flex-none p-3 opacity-20 hover:opacity-40"
                  aria-label={gettext("close")}
                >
                  <.icon name="hero-x-mark-solid" class="h-5 w-5" />
                </button>
              </div>
              <div id={"#{@id}-content"}>
                <%= render_slot(@inner_block) %>
              </div>
            </.focus_wrap>
          </div>
        </div>
      </div>
    </div>
    """
  end

  @doc """
  Renders flash notices.

  ## Examples

      <.flash kind={:info} flash={@flash} />
      <.flash kind={:info} phx-mounted={show("#flash")}>Welcome Back!</.flash>
  """
  attr :id, :string, doc: "the optional id of flash container"
  attr :flash, :map, default: %{}, doc: "the map of flash messages to display"
  attr :title, :string, default: nil
  attr :kind, :atom, values: [:info, :error, :warning], doc: "used for styling and flash lookup"
  attr :rest, :global, doc: "the arbitrary HTML attributes to add to the flash container"

  slot :inner_block, doc: "the optional inner block that renders the flash message"

  def flash(assigns) do
    assigns = assign_new(assigns, :id, fn -> "flash-#{assigns.kind}" end)

    ~H"""
    <div
      :if={msg = render_slot(@inner_block) || Phoenix.Flash.get(@flash, @kind)}
      id={@id}
      phx-click={JS.push("lv:clear-flash", value: %{key: @kind}) |> hide("##{@id}")}
      role="alert"
      class={[
        "fixed top-2 right-2 mr-2 w-80 sm:w-96 z-50 rounded-lg p-3 ring-1",
        @kind == :info && "bg-emerald-50 text-emerald-800 ring-emerald-500 fill-cyan-900",
        @kind == :error && "bg-rose-50 text-rose-900 shadow-md ring-rose-500 fill-rose-900",
        @kind == :warning && "bg-yellow-100 text-yellow-900 shadow-md ring-yellow-500 fill-yellow-900"
      ]}
      {@rest}
    >
      <p :if={@title} class="flex items-center gap-1.5 text-sm font-semibold leading-5">
        <.icon :if={@kind == :info} name="hero-information-circle-mini" class="h-4 w-4" />
        <.icon :if={@kind == :error} name="hero-exclamation-circle-mini" class="h-4 w-4" />
        <.icon :if={@kind == :warning} name="hero-exclamation-triangle-mini" class="h-4 w-4" />
        <%= @title %>
      </p>
      <p class="mt-2 text-sm leading-5"><%= msg %></p>
      <button type="button" class="group absolute top-1 right-1 p-2" aria-label={gettext("close")}>
        <.icon name="hero-x-mark-solid" class="h-5 w-5 opacity-40 group-hover:opacity-70" />
      </button>
    </div>
    """
  end

  @doc """
  Shows the flash group with standard titles and content.

  ## Examples

      <.flash_group flash={@flash} />
  """
  attr :flash, :map, required: true, doc: "the map of flash messages"
  attr :id, :string, default: "flash-group", doc: "the optional id of flash container"

  def flash_group(assigns) do
    ~H"""
    <div id={@id}>
      <.flash kind={:info} title={gettext("Success!")} flash={@flash} />
      <.flash kind={:error} title={gettext("Error!")} flash={@flash} />
      <.flash kind={:warning} title={gettext("Warning!")} flash={@flash} />
      <.flash
        id="client-error"
        kind={:error}
        title={gettext("We can't find the internet")}
        phx-disconnected={show(".phx-client-error #client-error")}
        phx-connected={hide("#client-error")}
        hidden
      >
        <%= gettext("Attempting to reconnect") %>
        <.icon name="hero-arrow-path" class="ml-1 h-3 w-3 animate-spin" />
      </.flash>

      <.flash
        id="server-error"
        kind={:error}
        title={gettext("Something went wrong!")}
        phx-disconnected={show(".phx-server-error #server-error")}
        phx-connected={hide("#server-error")}
        hidden
      >
        <%= gettext("Hang in there while we get back on track") %>
        <.icon name="hero-arrow-path" class="ml-1 h-3 w-3 animate-spin" />
      </.flash>
    </div>
    """
  end

  @doc """
  Renders a simple form.

  ## Examples

      <.simple_form for={@form} phx-change="validate" phx-submit="save">
        <.input field={@form[:email]} label="Email"/>
        <.input field={@form[:username]} label="Username" />
        <:actions>
          <.button>Save</.button>
        </:actions>
      </.simple_form>
  """
  attr :for, :any, required: true, doc: "the datastructure for the form"
  attr :as, :any, default: nil, doc: "the server side parameter to collect all input under"

  attr :rest, :global,
    include: ~w(autocomplete name rel action enctype method novalidate target multipart),
    doc: "the arbitrary HTML attributes to apply to the form tag"

  attr :class, :string, default: nil, doc: "the optional css class to apply to the form"
  slot :inner_block, required: true
  slot :actions, doc: "the slot for form actions, such as a submit button"

  def simple_form(assigns) do
    ~H"""
    <.form :let={f} for={@for} as={@as} {@rest}>
      <div class={["space-y-4 ", @class]}>
        <%= render_slot(@inner_block, f) %>
        <div :for={action <- @actions} class="mt-2 flex items-center justify-between gap-6">
          <%= render_slot(action, f) %>
        </div>
      </div>
    </.form>
    """
  end

  @doc """
  Renders a button.

  ## Examples

      <.button>Send!</.button>
      <.button phx-click="go" class="ml-2">Send!</.button>
  """
  attr :type, :string, default: nil
  attr :class, :string, default: nil
  attr :rest, :global, include: ~w(disabled form name value)

  slot :inner_block, required: true

  def button(assigns) do
    ~H"""
    <button
      type={@type}
      class={[
        "phx-submit-loading:opacity-75 rounded-lg bg-zinc-900 dark:bg-zinc-600 hover:bg-zinc-700 py-2 px-3",
        "text-sm font-semibold leading-5 text-white active:text-white/80",
        @class
      ]}
      {@rest}
    >
      <%= render_slot(@inner_block) %>
    </button>
    """
  end

  @doc """
  Renders an input with label and error messages.

  A `Phoenix.HTML.FormField` may be passed as argument,
  which is used to retrieve the input name, id, and values.
  Otherwise all attributes may be passed explicitly.

  ## Types

  This function accepts all HTML input types, considering that:

    * You may also set `type="select"` to render a `<select>` tag

    * `type="checkbox"` is used exclusively to render boolean values

    * For live file uploads, see `Phoenix.Component.live_file_input/1`

  See https://developer.mozilla.org/en-US/docs/Web/HTML/Element/input
  for more information.

  ## Examples

      <.input field={@form[:email]} type="email" />
      <.input name="my-input" errors={["oh no!"]} />
  """
  attr :id, :any, default: nil
  attr :name, :any
  attr :label, :string, default: nil
  attr :value, :any

  attr :type, :string,
    default: "text",
    values: ~w(checkbox color date datetime-local email file hidden month number password
               range radio search select tel text textarea time url week radiogroup)

  attr :field, Phoenix.HTML.FormField,
    doc: "a form field struct retrieved from the form, for example: @form[:email]"

  attr :errors, :list, default: []
  attr :checked, :boolean, doc: "the checked flag for checkbox inputs"
  attr :prompt, :string, default: nil, doc: "the prompt for select inputs"
  attr :options, :list, doc: "the options to pass to Phoenix.HTML.Form.options_for_select/2"
  attr :multiple, :boolean, default: false, doc: "the multiple flag for select inputs"
  attr :class, :string, default: ""
  attr :wrapper_class, :string, default: ""
  attr :label_class, :string, default: ""

  attr :force_validate, :boolean,
    default: false,
    doc: "whether to always validate the input even if the firm wasn't changed"

  attr :rest, :global,
    include: ~w(accept autocomplete capture cols disabled form list max maxlength min minlength
                multiple pattern placeholder readonly required rows size step)

  def input(%{field: %Phoenix.HTML.FormField{} = field} = assigns) do
    errors =
      if assigns.force_validate || Phoenix.Component.used_input?(field),
        do: field.errors,
        else: []

    assigns
    |> assign(field: nil, id: assigns.id || field.id)
    |> assign(:errors, Enum.map(errors, &translate_error(&1)))
    |> assign_new(:name, fn -> if assigns.multiple, do: field.name <> "[]", else: field.name end)
    |> assign_new(:value, fn -> field.value end)
    |> input()
  end

  def input(%{type: "checkbox"} = assigns) do
    assigns =
      assign_new(assigns, :checked, fn ->
        Phoenix.HTML.Form.normalize_value("checkbox", assigns[:value])
      end)

    ~H"""
    <div class={["flex items-center gap-4  break-inside-avoid", @wrapper_class]}>
      <.label for={@id} class={@label_class}><%= @label %></.label>

      <input type="hidden" name={@name} value="false" />
      <input
        type="checkbox"
        id={@id}
        name={@name}
        value="true"
        checked={@checked}
        class={[
          "rounded border-zinc-300 dark:border-zinc-500  text-zinc-900 focus:ring-0 dark:bg-zinc-900 dark:text-zinc-100 checked:dark:!bg-zinc-900 checked:dark:!border-zinc-500 box-border",
          @class
        ]}
        {@rest}
      />
      <.error :for={msg <- @errors}><%= msg %></.error>
    </div>
    """
  end

  def input(%{type: "select"} = assigns) do
    ~H"""
    <div class={["flex items-center gap-4 break-inside-avoid", @wrapper_class]}>
      <.label :if={@label} for={@id} class={@label_class}>
        <%= @label %>
      </.label>
      <select
        id={@id}
        name={@name}
        class={[
          "mt-2 block w-full rounded-lg text-zinc-900 focus:ring-0 sm:text-sm sm:leading-5 dark:bg-zinc-900 dark:text-zinc-100 dark:focus:border-2 box-border",
          @errors == [] && "border-zinc-300 dark:border-zinc-600 focus:border-zinc-400",
          @errors != [] && "border-rose-400 focus:border-rose-400 has-errors",
          @class
        ]}
        multiple={@multiple}
        {@rest}
      >
        <option :if={@prompt} value=""><%= @prompt %></option>
        <%= CaseManagerWeb.FormOptions.options_for_select_with_invalid(@options, @value) %>
      </select>
      <.error :for={msg <- @errors}><%= msg %></.error>
    </div>
    """
  end

  def input(%{type: "radiogroup"} = assigns) do
    ~H"""
    <div class={["flex  gap-4 break-inside-avoid", @wrapper_class]} {@rest}>
      <.label :if={@label} class={@label_class}><%= @label %></.label>
      <div class="flex">
        <.input
          :for={value <- @options}
          type="radio"
          name={@name}
          id={"#{@id}_#{value}"}
          value={value}
          checked={@value == value}
        />
      </div>
    </div>
    """
  end

  def input(%{type: "radio"} = assigns) do
    ~H"""
    <div class={["flex flex-row items-center gap-2 break-inside-avoid", @wrapper_class]} {@rest}>
      <input
        type="radio"
        name={@name}
        id={@id}
        value={@value || nil}
        checked={@checked}
        class={[
          "border-2 rounded-full border-zinc-300 dark:border-zinc-500 text-zinc-900 focus:ring-0 dark:focus:border-2 box-border",
          "checked:dark:!border-zinc-500",
          @class
        ]}
        {@rest}
      />
      <.label for={@id} class={@label_class}><%= @label || @value %></.label>
      <.error :for={msg <- @errors}><%= msg %></.error>
    </div>
    """
  end

  def input(%{type: "textarea"} = assigns) do
    ~H"""
    <div class={[
      "flex flex-row items-baseline gap-4  break-inside-avoid tabular-nums slashed-zero",
      @wrapper_class
    ]}>
      <.label :if={@label} for={@id} class={@label_class}><%= @label %></.label>
      <textarea
        id={@id}
        name={@name}
        class={[
          "mt-2 block w-full rounded-lg text-zinc-900 dark:text-zinc-100 dark:bg-zinc-900 focus:ring-0 sm:text-sm sm:leading-5",
          "min-h-[6rem] tabular-nums slashed-zero dark:focus:border-2 box-border",
          @errors == [] && "border-zinc-300 dark:border-zinc-500 focus:border-zinc-400",
          @errors != [] && "border-rose-400 focus:border-rose-400 has-errors",
          @class
        ]}
        {@rest}
      ><%= Phoenix.HTML.Form.normalize_value("textarea", @value) %></textarea>
      <.error :for={msg <- @errors}><%= msg %></.error>
    </div>
    """
  end

  def input(%{type: "hidden"} = assigns) do
    ~H"""
    <div class={["invisible", @wrapper_class]}>
      <input
        type={@type}
        name={@name}
        id={@id}
        value={Phoenix.HTML.Form.normalize_value(@type, @value)}
        {@rest}
      />
    </div>
    """
  end

  # All other inputs text, datetime-local, url, password, etc. are handled here...
  def input(assigns) do
    ~H"""
    <div class={["flex flex-row items-baseline gap-4 break-inside-avoid ", @wrapper_class]}>
      <%= if (is_binary(@label) && String.trim(@label) != "") do %>
        <.label for={@id} class={@label_class}><%= @label %></.label>
      <% end %>
      <div class="w-full">
        <input
          type={@type}
          name={@name}
          id={@id}
          value={Phoenix.HTML.Form.normalize_value(@type, @value)}
          class={[
            "mt-2 block w-full rounded-lg text-zinc-900 focus:ring-0 sm:text-sm sm:leading-5",
            " tabular-nums slashed-zero dark:focus:ring-0 dark:focus:border-2 box-border",
            "dark:bg-zinc-900 dark:text-zinc-100",
            @errors == [] && "border-zinc-300 dark:border-zinc-500 focus:border-zinc-400",
            @errors != [] && "border-rose-400 focus:border-rose-400 has-errors",
            @class
          ]}
          {@rest}
        />
        <.error :for={msg <- @errors}><%= msg %></.error>
      </div>
    </div>
    """
  end

  @doc """
  Renders a label.
  """
  attr :for, :string, default: nil
  attr :class, :string, default: ""
  slot :inner_block, required: true

  def label(assigns) do
    ~H"""
    <%= if (@inner_block) do %>
      <label
        for={@for}
        class={[
          "block text-sm font-semibold leading-5 text-zinc-800 dark:text-zinc-200 w-28 shrink-0",
          @class
        ]}
      >
        <%= render_slot(@inner_block) %>
      </label>
    <% end %>
    """
  end

  @doc """
  Generates a generic error message.
  """
  slot :inner_block, required: true

  def error(assigns) do
    ~H"""
    <p class="mt-1 flex gap-3 text-sm leading-5 text-rose-600 ">
      <.icon name="hero-exclamation-circle-mini" class="mt-0.5 h-5 w-5 flex-none" />
      <%= render_slot(@inner_block) %>
    </p>
    """
  end

  @doc """
  Generates a hint if the data could not be processed automatically.
  """
  attr :field_name, :string, required: true
  slot :inner_block, required: true

  def parsing_hint(assigns) do
    ~H"""
    <.error>
      Couldn't process the value for <%= @field_name %>:
      <strong><%= render_slot(@inner_block) %></strong>
    </.error>
    """
  end

  @doc """
  Renders a header with title.
  """
  attr :class, :string, default: nil
  attr :action_class, :string, default: nil

  slot :inner_block, required: true
  slot :subtitle
  slot :actions

  def header(assigns) do
    ~H"""
    <header class={[@actions != [] && "flex items-center justify-between gap-6", @class]}>
      <div>
        <.h1>
          <%= render_slot(@inner_block) %>
        </.h1>
        <p :if={@subtitle != []} class="mt-2 text-sm leading-5 text-zinc-700 dark:text-zinc-300">
          <%= render_slot(@subtitle) %>
        </p>
      </div>
      <div class={["flex-none flex items-center gap-2", @action_class]}>
        <%= render_slot(@actions) %>
      </div>
    </header>
    """
  end

  @doc """
  Renders a h1
  """
  attr :class, :string, default: nil
  slot :inner_block

  def h1(assigns) do
    ~H"""
    <h1 class={["text-lg font-semibold leading-8 text-zinc-800 dark:text-zinc-200", @class]}>
      <%= render_slot(@inner_block) %>
    </h1>
    """
  end >
    @doc ~S"""
    Renders a table with generic styling.

    ## Examples

        <.table id="users" rows={@users}>
          <:col :let={user} label="id"><%= user.id %></:col>
          <:col :let={user} label="username"><%= user.username %></:col>
        </.table>
    """

  attr :id, :string, required: true
  attr :rows, :list, required: true
  attr :row_id, :any, default: nil, doc: "the function for generating the row id"
  attr :row_click, :any, default: nil, doc: "the function for handling phx-click on each row"

  attr :row_item, :any,
    default: &Function.identity/1,
    doc: "the function for mapping each row before calling the :col and :action slots"

  slot :col, required: true do
    attr :label, :string
  end

  slot :action, doc: "the slot for showing user actions in the last table column"

  def table(assigns) do
    assigns =
      with %{rows: %Phoenix.LiveView.LiveStream{}} <- assigns do
        assign(assigns, row_id: assigns.row_id || fn {id, _item} -> id end)
      end

    ~H"""
    <div class="overflow-y-auto px-4 sm:overflow-visible sm:px-0">
      <table class="w-[40rem] mt-11 sm:w-full">
        <thead class="text-sm text-left leading-5 text-zinc-500 dark:text-zinc-300">
          <tr>
            <th :for={col <- @col} class="p-0 pb-4 pr-6 font-normal"><%= col[:label] %></th>
            <th :if={@action != []} class="relative p-0 pb-4">
              <span class="sr-only"><%= gettext("Actions") %></span>
            </th>
          </tr>
        </thead>
        <tbody
          id={@id}
          phx-update={match?(%Phoenix.LiveView.LiveStream{}, @rows) && "stream"}
          class="relative divide-y divide-zinc-100 dark:divide-zinc-800 border-t border-zinc-200 text-sm leading-5 dark:text-zinc-300 text-zinc-700"
        >
          <tr
            :for={row <- @rows}
            id={@row_id && @row_id.(row)}
            class="group hover:bg-zinc-50 dark:hover:bg-zinc-800"
          >
            <td
              :for={{col, i} <- Enum.with_index(@col)}
              phx-click={@row_click && @row_click.(row)}
              class={["relative p-0", @row_click && "hover:cursor-pointer"]}
            >
              <div class="block py-4 pr-6">
                <span class="absolute -inset-y-px right-0 -left-4 group-hover:bg-zinc-50  dark:group-hover:bg-zinc-800 sm:rounded-l-xl" />
                <span class={["relative", i == 0 && "font-semibold text-zinc-900 dark:text-zinc-100"]}>
                  <%= render_slot(col, @row_item.(row)) %>
                </span>
              </div>
            </td>
            <td :if={@action != []} class="relative w-14 p-0">
              <div class="relative whitespace-nowrap py-4 text-right text-sm font-medium">
                <span class="absolute -inset-y-px -right-4 left-0 group-hover:bg-zinc-50 dark:group-hover:bg-zinc-800 sm:rounded-r-xl" />
                <span
                  :for={action <- @action}
                  class="relative ml-4 font-semibold leading-5 text-zinc-900 dark:text-zinc-100 dark:hover:text-zinc-400 hover:text-zinc-700"
                >
                  <%= render_slot(action, @row_item.(row)) %>
                </span>
              </div>
            </td>
          </tr>
        </tbody>
      </table>
    </div>
    """
  end

  @doc ~S"""
  Renders a table with generic styling.

  ## Examples

      <.table id="users" rows={@users}>
        <:col :let={user} label="id"><%= user.id %></:col>
        <:col :let={user} label="username"><%= user.username %></:col>
      </.table>
  """

  attr :id, :string, required: true
  attr :rows, :list, required: true
  attr :row_id, :any, default: nil, doc: "the function for generating the row id"
  attr :row_click, :any, default: nil, doc: "the function for handling phx-click on each row"

  attr :row_item, :any,
    default: &Function.identity/1,
    doc: "the function for mapping each row before calling the :col and :action slots"

  slot :col, required: true do
    attr :label, :string
  end

  slot :action, doc: "the slot for showing user actions in the last table column"

  def compact_table(assigns) do
    assigns =
      with %{rows: %Phoenix.LiveView.LiveStream{}} <- assigns do
        assign(assigns, row_id: assigns.row_id || fn {id, _item} -> id end)
      end

    ~H"""
    <div class="overflow-y-auto px-4 sm:px-0 text-sm">
      <table class="w-full my-2 overflow-hidden">
        <tbody
          id={@id}
          phx-update={match?(%Phoenix.LiveView.LiveStream{}, @rows) && "stream"}
          class="relative  text-sm leading-4 text-zinc-700 dark:text-zinc-300"
        >
          <tr
            :for={row <- @rows}
            id={@row_id && @row_id.(row)}
            class="group hover:bg-zinc-50 dark:hover:bg-zinc-800"
          >
            <td
              :for={{col, i} <- Enum.with_index(@col)}
              phx-click={@row_click && @row_click.(row)}
              class={["relative p-0", @row_click && "hover:cursor-pointer"]}
            >
              <div class="block">
                <span class="absolute -inset-y-px right-0 -left-4 group-hover:bg-zinc-50  dark:group-hover:bg-zinc-800 sm:rounded-l-xl" />
                <span class={["relative", i == 0 && "font-semibold text-zinc-900 dark:text-zinc-100"]}>
                  <%= render_slot(col, @row_item.(row)) %>
                </span>
              </div>
            </td>
            <td :if={@action != []} class="relative w-14 p-0">
              <div class="relative whitespace-nowrap py-2 text-right text-sm font-medium">
                <span class="absolute -inset-y-px -right-4 left-0 group-hover:bg-zinc-50 dark:group-hover:bg-zinc-800 sm:rounded-r-xl" />
                <span
                  :for={action <- @action}
                  class="relative ml-4 font-semibold leading-5 text-zinc-900 dark:text-zinc-100 dark:hover:text-zinc-400 hover:text-zinc-700"
                >
                  <%= render_slot(action, @row_item.(row)) %>
                </span>
              </div>
            </td>
          </tr>
        </tbody>
      </table>
    </div>
    """
  end

  @doc """
  Renders a data list.

  ## Examples

      <.list>
        <:item title="Title"><%= @post.title %></:item>
        <:item title="Views"><%= @post.views %></:item>
      </.list>
  """
  slot :item, required: true do
    attr :title, :string, required: true
  end

  def list(assigns) do
    ~H"""
    <div class="mt-4">
      <dl class="-my-4 divide-y divide-zinc-100 dark:divide-zinc-800">
        <div :for={item <- @item} class="flex gap-4 py-2 text-sm leading-5 sm:gap-8">
          <dt class="w-1/4 flex-none dark:text-zinc-300"><%= item.title %></dt>
          <dd class="text-zinc-700 dark:text-zinc-300 break-words"><%= render_slot(item) %></dd>
        </div>
      </dl>
    </div>
    """
  end

  @doc """
  Renders a back navigation link.

  ## Examples

      <.back navigate={~p"/posts"}>Back to posts</.back>
  """
  attr :navigate, :any, required: true
  attr :class, :string, default: nil
  slot :inner_block, required: true

  def back(assigns) do
    ~H"""
    <div class={["mt-16", @class]}>
      <.link
        navigate={@navigate}
        class="text-sm font-semibold leading-5 text-zinc-900 hover:text-zinc-700"
      >
        <.icon name="hero-arrow-left-solid" class="h-3 w-3" />
        <%= render_slot(@inner_block) %>
      </.link>
    </div>
    """
  end

  @doc """
  Renders a [Heroicon](https://heroicons.com).

  Heroicons come in three styles – outline, solid, and mini.
  By default, the outline style is used, but solid and mini may
  be applied by using the `-solid` and `-mini` suffix.

  You can customize the size and colors of the icons by setting
  width, height, and background color classes.

  Icons are extracted from the `deps/heroicons` directory and bundled within
  your compiled app.css by the plugin in your `assets/tailwind.config.js`.

  ## Examples

      <.icon name="hero-x-mark-solid" />
      <.icon name="hero-arrow-path" class="ml-1 w-3 h-3 animate-spin" />
  """
  attr :name, :string, required: true
  attr :class, :string, default: nil

  def icon(%{name: "hero-" <> _} = assigns) do
    ~H"""
    <span class={[@name, @class]} />
    """
  end

  @doc """
  Renders a card component with a title,
  an icon, a tag, a body, a timestamp, and interactive actions.
  The actions are displayed in a dropdown menu .

  ## Examples

    <.card>
      <p>Inner Content</p>
      <:icon>
        <svg class="hero-annotation" ...></svg> <!-- Insert your SVG or icon component here -->
      </:icon>
      <:title>
        Card Title
      </:title>
      <:tag>
        <span class="bg-emerald-50 text-emerald-800">New</span>
      </:tag>
      <:inner_block>
        <p>Card body content here...</p>
      </:inner_block>
      <:timestamp>
        4 hours ago
      </:timestamp>
      <:actions>
        <div class="dropdown-menu shadow-lg bg-white rounded-md p-2" style="display: none;"> <!-- Adjust styling as needed -->
          <!-- Action items go here -->
          <a href="#" class="block px-4 py-2 text-sm text-gray-700 hover:bg-gray-100">Action 1</a>
          <a href="#" class="block px-4 py-2 text-sm text-gray-700 hover:bg-gray-100">Action 2</a>
        </div>
      </:actions>
    </.card>
  """
  # Investigate solution without requiring id
  attr :id, :string, required: true
  attr :class, :string, default: nil
  slot :inner_block, required: true
  slot :icon, required: true
  slot :title, required: true
  slot :tag, default: nil
  slot :timestamp, default: nil
  attr :rest, :global, doc: "the arbitrary HTML attributes to add to the flash container"
  slot :actions

  def card(assigns) do
    ~H"""
    <div
      class={[
        "flex flex-col justify-between h-full shadow rounded-lg p-3 border-2 border-calypso-50 dark:border-gray-700 hover:bg-gray-50 dark:hover:bg-gray-950 dark:bg-zinc-800",
        @class
      ]}
      id={@id}
      {@rest}
    >
      <div class="row-1 text-gray-900 dark:text-gray-200 leading-snug text-base flex items-start gap-x-2">
        <%= render_slot(@icon) %>
        <strong class="text-base !leading-tight font-semibold">
          <%= render_slot(@title) %>
        </strong>
        <span class="ml-auto flex gap-2">
          <%= render_slot(@tag) %>
        </span>
        <div
          phx-click-away={JS.hide(to: "##{@id}-menu")}
          class={[@actions == [] && "hidden", "actions relative"]}
        >
          <button
            class="hero-ellipsis-vertical-solid text-zinc-700 dark:text-zinc-200 h-5 -mr-2"
            phx-click={
              JS.toggle(
                to: "##{@id}-menu",
                in: {"ease-out duration-100", "opacity-0 scale-95", "opacity-100 scale-100"},
                out: {"ease-out duration-75", "opacity-100 scale-100", "opacity-0 scale-95"}
              )
            }
          />
          <div
            id={@id <> "-menu"}
            class="dropdown absolute hidden right-0 z-10 shadow rounded-md bg-zinc-100 dark:bg-zinc-700 p-2 text-sm w-28 border-zinc-300 border-2 dark:border-zinc-600"
          >
            <%= render_slot(@actions) %>
          </div>
        </div>
      </div>
      <div class="text-wrap break-words text-sm mb-1">
        <%= render_slot(@inner_block) %>
      </div>
      <%= render_slot(@timestamp) %>
    </div>
    """
  end

  @doc """
  Renders a small tag with customizable class

  ## Examples

      <.tag class="bg-emerald-50 text-emerald-800">New</.tag>
  """
  attr :class, :string, default: nil
  attr :color, :string, default: "gray"
  slot :inner_block, required: true

  def tag_badge(assigns) do
    # Allow tweaking of scheme
    colors =
      case assigns.color do
        "gray" ->
          [
            "bg-gray-100 dark:bg-gray-800",
            "border-gray-300 dark:border-gray-600",
            "text-gray-700 dark:text-gray-300"
          ]

        "emerald" ->
          [
            "bg-emerald-100 dark:bg-emerald-800",
            "border-emerald-300 dark:border-emerald-600",
            "text-emerald-700 dark:text-emerald-300"
          ]

        "red" ->
          [
            "bg-red-100 dark:bg-red-800",
            "border-red-300 dark:border-red-600",
            "text-red-700 dark:text-red-300"
          ]

        "blue" ->
          [
            "bg-blue-100 dark:bg-blue-800",
            "border-blue-300 dark:border-blue-600",
            "text-blue-700 dark:text-blue-300"
          ]

        _ ->
          [
            "bg-#{assigns.color}-100 dark:bg-#{assigns.color}-800",
            "border-#{assigns.color}-300 dark:border-#{assigns.color}-600",
            "text-#{assigns.color}-700 dark:text-#{assigns.color}-300"
          ]
      end

    assigns = assign(assigns, :colors, colors)

    ~H"""
    <span class={[
      "border rounded-md px-1 text-xs",
      @colors,
      @class
    ]}>
      <%= render_slot(@inner_block) %>
    </span>
    """
  end

  attr :timestamp, :any, required: true
  attr :class, :string, default: ""

  def timestamp(%{timestamp: timestamp} = assigns) do
    now = DateTime.utc_now()
    diff = DateTime.diff(now, timestamp)

    timestring =
      cond do
        diff < 60 ->
          "#{diff} seconds ago"

        diff < 3600 ->
          "#{div(diff, 60)} minutes ago"

        diff < 86_400 ->
          "#{div(diff, 3600)} hours ago"

        true ->
          "#{Date.to_string(timestamp)}"
      end

    assigns = assign(assigns, :timestring, timestring)

    ~H"""
    <span class={["flex items-center gap-1 text-xs", @class]}>
      <i class="hero-clock text-gray-700 dark:text-gray-300  h-3 w-3"></i>
      <%= @timestring %>
    </span>
    """
  end

  ## JS Commands

  def show(js \\ %JS{}, selector) do
    JS.show(js,
      to: selector,
      transition:
        {"transition-all transform ease-out duration-300",
         "opacity-0 translate-y-4 sm:translate-y-0 sm:scale-95",
         "opacity-100 translate-y-0 sm:scale-100"}
    )
  end

  def hide(js \\ %JS{}, selector) do
    JS.hide(js,
      to: selector,
      time: 200,
      transition:
        {"transition-all transform ease-in duration-200",
         "opacity-100 translate-y-0 sm:scale-100",
         "opacity-0 translate-y-4 sm:translate-y-0 sm:scale-95"}
    )
  end

  def show_modal(js \\ %JS{}, id) when is_binary(id) do
    js
    |> JS.show(to: "##{id}")
    |> JS.show(
      to: "##{id}-bg",
      transition: {"transition-all transform ease-out duration-300", "opacity-0", "opacity-100"}
    )
    |> show("##{id}-container")
    |> JS.add_class("overflow-hidden", to: "body")
    |> JS.focus_first(to: "##{id}-content")
  end

  def hide_modal(js \\ %JS{}, id) do
    js
    |> JS.hide(
      to: "##{id}-bg",
      transition: {"transition-all transform ease-in duration-200", "opacity-100", "opacity-0"}
    )
    |> hide("##{id}-container")
    |> JS.hide(to: "##{id}", transition: {"block", "block", "hidden"})
    |> JS.remove_class("overflow-hidden", to: "body")
    |> JS.pop_focus()
  end

  @doc """
  Translates an error message using gettext.
  """
  def translate_error({msg, opts}) do
    # When using gettext, we typically pass the strings we want
    # to translate as a static argument:
    #
    #     # Translate the number of files with plural rules
    #     dngettext("errors", "1 file", "%{count} files", count)
    #
    # However the error messages in our forms and APIs are generated
    # dynamically, so we need to translate them by calling Gettext
    # with our gettext backend as first argument. Translations are
    # available in the errors.po file (as we use the "errors" domain).
    if count = opts[:count] do
      Gettext.dngettext(CaseManagerWeb.Gettext, "errors", msg, msg, count, opts)
    else
      Gettext.dgettext(CaseManagerWeb.Gettext, "errors", msg, opts)
    end
  end

  @doc """
  Translates the errors for a field from a keyword list of errors.
  """
  def translate_errors(errors, field) when is_list(errors) do
    for {^field, {msg, opts}} <- errors, do: translate_error({msg, opts})
  end
end
