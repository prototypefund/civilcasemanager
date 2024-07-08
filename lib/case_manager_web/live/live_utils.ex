defmodule CaseManagerWeb.LiveUtils do
  def pagination_opts() do
    base =
      "shadow rounded-lg space-x-4 bg-indigo-600 text-white hover:bg-indigo-500 dark:hover:bg-gray-950 "

    [
      wrapper_attrs: [class: "flex justify-center gap-2 mt-4"],
      pagination_list_attrs: [class: "flex order-2 gap-2 py-2 px-3 "],
      previous_link_attrs: [class: "order-1 py-2 px-3 " <> base],
      next_link_attrs: [class: "order-3 py-2 px-3 " <> base],
      pagination_link_attrs: [class: "py-2 px-3 " <> base],
      current_link_attrs: [class: "py-2 px-3 " <> base <> "bg-indigo-400"]
    ]
  end
end
