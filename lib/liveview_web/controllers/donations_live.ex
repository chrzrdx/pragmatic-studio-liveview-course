defmodule LiveviewWeb.DonationsLive do
  use LiveviewWeb, :live_view
  alias Liveview.Donations

  @impl true
  def mount(_params, _session, socket) do
    donations = Donations.list_donations() |> IO.inspect(label: "DONATIONS")
    {:ok, assign(socket, donations: donations)}
  end

  # def handle_params(params, _uri, socket) do
  #   {:noreply, socket}
  # end

  defp sort_icon(assigns) do
    ~H"""
    <!-- Active: "bg-gray-200 text-gray-900 group-hover:bg-gray-300", Not Active: "invisible text-gray-400 group-hover:visible group-focus:visible" -->
    <span class="invisible ml-2 flex-none rounded-sm text-gray-400 group-hover:visible group-focus:visible">
      <svg class="size-5" viewBox="0 0 20 20" fill="currentColor" aria-hidden="true" data-slot="icon">
        <path
          fill-rule="evenodd"
          d="M5.22 8.22a.75.75 0 0 1 1.06 0L10 11.94l3.72-3.72a.75.75 0 1 1 1.06 1.06l-4.25 4.25a.75.75 0 0 1-1.06 0L5.22 9.28a.75.75 0 0 1 0-1.06Z"
          clip-rule="evenodd"
        />
      </svg>
    </span>
    """
  end
end
