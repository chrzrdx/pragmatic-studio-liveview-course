defmodule LiveviewWeb.DonationsLive do
  use LiveviewWeb, :live_view
  alias Liveview.Donations

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(params, _uri, socket) do
    params = Donations.validate_list_params(params)
    donations = Donations.list_donations(params)

    {:noreply, assign(socket, donations: donations, params: params)}
  end

  defp sort_icon(assigns) do
    ~H"""
    <span class={[
      "invisible ml-2 flex-none rounded-sm text-white group-hover:visible group-focus:visible",
      "group-data-sort-direction:visible group-data-sort-direction:bg-indigo-500"
    ]}>
      <svg
        class="size-5 transition-transform duration-300 ease-in-out group-data-[sort-direction=asc]:rotate-180"
        viewBox="0 0 20 20"
        fill="currentColor"
        aria-hidden="true"
        data-slot="icon"
      >
        <path
          fill-rule="evenodd"
          d="M5.22 8.22a.75.75 0 0 1 1.06 0L10 11.94l3.72-3.72a.75.75 0 1 1 1.06 1.06l-4.25 4.25a.75.75 0 0 1-1.06 0L5.22 9.28a.75.75 0 0 1 0-1.06Z"
          clip-rule="evenodd"
        />
      </svg>
    </span>
    """
  end

  defp get_next_sort_order("asc"), do: "desc"
  defp get_next_sort_order("desc"), do: "asc"
  defp get_next_sort_order(_), do: "asc"
end
