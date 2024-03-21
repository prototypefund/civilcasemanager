defmodule EventsWeb.EventLive.IconComponent do
  use Phoenix.Component
  import EventsWeb.CoreComponents

  @doc """
  Displays an icon based on the event type.
  """
  def render(assigns) do
    event_type = assigns[:type]

    icon_name =
      case event_type do
        :email -> "hero-mail-open-solid"
        :phone_call -> "hero-phone-solid"
        _ -> "hero-exclamation-circle-solid" # Fallback icon for unknown types
      end


    assigns = Map.put(assigns, :icon_name, icon_name)

    ~H"""
    <div>
      <.icon name={@icon_name} class="h-5 w-5" />
    </div>
    """
  end
end
