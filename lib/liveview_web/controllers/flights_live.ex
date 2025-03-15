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
