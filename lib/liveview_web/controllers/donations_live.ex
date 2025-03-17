defmodule LiveviewWeb.DonationsLive do
  use LiveviewWeb, :live_view
  alias Liveview.Donations

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(params, _uri, socket) do
    params = Donations.ListParams.validate(params)
    donations = Donations.list_donations(params)
    count_donations = Donations.count_donations()
    max_pages = max(1, ceil(count_donations / params.per_page))

    {:noreply,
     socket
     |> assign(params: params)
     |> assign(:max_pages, max_pages)
     |> stream(:donations, donations, reset: true)}
  end

  @impl true
  def handle_event("update_per_page", %{"per_page" => per_page}, socket) do
    params = %{socket.assigns.params | per_page: per_page}
    {:noreply, push_patch(socket, to: ~p"/donations?#{params}")}
  end

  defp sort_icon(assigns) do
    ~H"""
    <span class={[
      "invisible ml-2 flex-none rounded-sm text-white group-hover:visible group-focus:visible",
      "group-data-sort-direction:visible group-data-sort-direction:bg-indigo-500"
    ]}>
      <svg
        class="size-5 transition-transform duration-100 ease-in-out group-data-[sort-direction=asc]:rotate-180"
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

  defp get_sort_link(%{sort_by: sort_by} = params, sort_by) do
    ~p"/donations?#{%{params | sort_direction: get_next_sort_order(params.sort_direction)}}"
  end

  defp get_sort_link(params, sort_by) do
    ~p"/donations?#{%{params | sort_by: sort_by, sort_direction: "asc"}}"
  end

  defp get_next_sort_order("asc"), do: "desc"
  defp get_next_sort_order("desc"), do: "asc"
  defp get_next_sort_order(_), do: "asc"

  defp get_pagination_link(%{page: page} = params, max_pages, :previous) do
    ~p"/donations?#{%{params | page: min(max(page - 1, 1), max_pages)}}"
  end

  defp get_pagination_link(%{page: page} = params, max_pages, :next) do
    ~p"/donations?#{%{params | page: min(page + 1, max_pages)}}"
  end
end
