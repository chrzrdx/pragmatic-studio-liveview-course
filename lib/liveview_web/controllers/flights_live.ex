defmodule LiveviewWeb.FlightsLive do
  use LiveviewWeb, :live_view
  alias Liveview.Flights

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     assign(
       socket,
       airport: "",
       flights: [],
       loading: false
     )}
  end

  @impl true
  def handle_event("search_flights", %{"airport" => airport}, socket) do
    send(self(), {:search_flights, airport})

    {:noreply,
     assign(
       socket,
       airport: airport,
       flights: socket.assigns.flights,
       loading: true
     )}
  end

  @impl true
  def handle_info({:search_flights, airport}, socket) do
    {:noreply,
     assign(
       socket,
       airport: airport,
       flights: Flights.search_by_airport(airport),
       loading: false
     )}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div class="space-y-12 max-w-2xl mx-auto">
      <h1 class="text-5xl font-extrabold text-center">Find a Flight</h1>

      <form class="max-w-96 mx-auto text-xl" phx-submit="search_flights">
        <div class="flex gap-4 py-2 px-4 border-2 border-gray-300 rounded-lg focus-within:ring-2 focus-within:ring-blue-500 focus-within:border-transparent">
          <label for="airport" class="sr-only">Search by airport</label>
          <input
            class="w-full border-none outline-none placeholder:text-gray-400"
            id="airport"
            type="search"
            name="airport"
            value={@airport}
            maxlength="5"
            required
            placeholder="Airport code"
            autocomplete="off"
            autofocus
            readonly={@loading}
          />
          <button type="submit" disabled={@loading} class="rounded-r-lg cursor-pointer ">🔍</button>
        </div>
      </form>

      <ul
        :if={length(@flights) > 0 or @loading}
        phx-remove={JS.transition({"ease-out duration-300", "opacity-100", "opacity-0"})}
        phx-mounted={JS.transition({"ease-out duration-300", "opacity-0", "opacity-100"})}
        class="rounded bg-white overflow-hidden border border-zinc-300 shadow-lg divide-y divide-zinc-300 relative min-h-22"
      >
        <li :if={@loading} class="grid place-content-center py-4 px-6 inset-0 bg-white/80 absolute">
          <.loader class="size-16" />
        </li>
        <li
          :for={flight <- @flights}
          class="grid grid-cols-2 items-center grid-rows-2 py-4 px-6 hover:bg-indigo-100 gap-2"
        >
          <span class="text-indigo-700 font-bold">Flight #{flight.number}</span>
          <span class="text-indigo-700 font-medium text-right">
            {flight.origin} to {flight.destination}
          </span>
          <span class="text-sm text-zinc-500">Departs: {flight.departure_time}</span>
          <span class="text-sm text-zinc-500 text-right">Arrives: {flight.arrival_time}</span>
        </li>
      </ul>
    </div>
    """
  end

  attr :class, :string, default: "size-8"

  defp loader(assigns) do
    ~H"""
    <svg
      fill="none"
      class={["animate-spin text-indigo-600", @class]}
      viewBox="0 0 32 32"
      xmlns="http://www.w3.org/2000/svg"
    >
      <path
        clip-rule="evenodd"
        d="M15.165 8.53a.5.5 0 01-.404.58A7 7 0 1023 16a.5.5 0 011 0 8 8 0 11-9.416-7.874.5.5 0 01.58.404z"
        fill="currentColor"
        fill-rule="evenodd"
      >
      </path>
    </svg>
    """
  end
end
