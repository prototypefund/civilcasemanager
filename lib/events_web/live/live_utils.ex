defmodule EventsWeb.LiveUtils do

  use PhoenixHTMLHelpers
  import EventsWeb.LiveComponents

  def render_timestamp(timestamp) do
    now = DateTime.utc_now()
    diff = DateTime.diff(now, timestamp)

    timestring = cond do
      diff < 60 ->
        "#{diff} seconds ago"
      diff < 3600 ->
        "#{div(diff, 60)} minutes ago"
      diff < 86400 ->
        "#{div(diff, 3600)} hours ago"
      true ->
        "#{Date.to_string(timestamp)}"
    end

    content_tag(:span, class: "flex items-center gap-1 text-xs") do
      [
        content_tag(:i, "", class: "hero-clock text-gray-700 h-3 w-3"),
        timestring
      ]
    end
  end

end
