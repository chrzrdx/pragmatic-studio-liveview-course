defmodule LiveviewWeb.FlightsLive do
  use LiveviewWeb, :live_view
  alias Liveview.Flights

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     assign(
       socket,
       airport: "",
       airports: [],
       flights: [],
       loading_flights: false,
       loading_airports: false
     )}
  end

  @impl true
  def handle_event("search_flights", %{"airport" => airport}, socket) do
    send(self(), {:search_flights, airport})

    {:noreply,
     assign(
       socket,
       airport: airport,
       airports: [],
       loading_flights: true,
       loading_airports: false
     )}
  end

  @impl true
  def handle_event("search_airports", %{"airport" => airport}, socket) do
    send(self(), {:search_airports, airport})

    {:noreply, assign(socket, loading_airports: true)}
  end

  @impl true
  def handle_event("select_airport", %{"code" => code}, socket) do
    send(self(), {:search_flights, code})

    {:noreply,
     assign(
       socket,
       airport: code,
       airports: [],
       loading_flights: true,
       loading_airports: false
     )}
  end

  @impl true
  def handle_info({:search_flights, airport}, socket) do
    {:noreply,
     assign(
       socket,
       airport: airport,
       flights: Flights.search_by_airport(airport),
       loading_flights: false
     )}
  end

  @impl true
  def handle_info({:search_airports, airport}, socket) do
    {:noreply,
     assign(socket,
       airports: Liveview.Airports.suggest(airport),
       loading_airports: false
     )}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div class="mx-auto max-w-2xl space-y-12">
      <h1 class="text-center text-5xl font-extrabold">Find a Flight</h1>

      <form class="max-w-96 mx-auto text-xl" phx-submit="search_flights" phx-change="search_airports">
        <div class="relative flex gap-4 rounded-lg border-2 border-gray-300 px-4 py-2 focus-within:border-transparent focus-within:ring-2 focus-within:ring-blue-500">
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
            readonly={@loading_flights}
            phx-debounce="300"
          />
          <div
            :if={length(@airports) > 0 and not @loading_flights}
            class="absolute top-full right-0 left-0 z-10 mt-1 max-h-60 overflow-y-auto rounded-lg border border-gray-300 bg-white shadow-lg"
          >
            <div
              :for={{airport_code, airport_name} <- @airports}
              class="cursor-pointer px-4 py-2 hover:bg-gray-100"
              phx-click="select_airport"
              phx-value-code={airport_code}
            >
              <div class="text-sm font-medium text-indigo-700">{airport_code}</div>
              <div class="text-xs text-zinc-600">{airport_name}</div>
            </div>
          </div>
          <button
            type="submit"
            disabled={@loading_flights}
            class="size-8 shrink-0 cursor-pointer rounded-r-lg"
          >
            <span :if={not @loading_airports}>🔍</span>
            <.loader :if={@loading_airports} />
          </button>
        </div>
      </form>

      <ul
        :if={length(@flights) > 0 || @loading_flights}
        phx-remove={JS.transition({"ease-out duration-300", "opacity-100", "opacity-0"})}
        phx-mounted={JS.transition({"ease-out duration-300", "opacity-0", "opacity-100"})}
        class="min-h-22 relative divide-y divide-zinc-300 overflow-hidden rounded border border-zinc-300 bg-white shadow-lg"
      >
        <li
          :if={@loading_flights}
          class="bg-white/80 absolute inset-0 grid place-content-center px-6 py-4"
        >
          <.loader class="size-16" />
        </li>
        <li
          :for={flight <- @flights}
          class="grid grid-cols-2 grid-rows-2 items-center gap-2 px-6 py-4 hover:bg-indigo-100"
        >
          <span class="font-bold text-indigo-700">Flight #{flight.number}</span>
          <span class="text-right font-medium text-indigo-700">
            {flight.origin} to {flight.destination}
          </span>
          <span class="text-sm text-zinc-500">Departs: {flight.departure_time}</span>
          <span class="text-right text-sm text-zinc-500">Arrives: {flight.arrival_time}</span>
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
