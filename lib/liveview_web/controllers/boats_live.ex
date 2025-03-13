defmodule LiveviewWeb.BoatsLive do
  use LiveviewWeb, :live_view
  alias Liveview.Boats
  alias Liveview.Boats.Boat

  def mount(_params, _session, socket) do
    {:ok,
     assign(socket,
       boats: Boats.filter_boats([], []),
       tags: Boats.list_tags(),
       prices: Boats.list_prices(),
       selected_prices: [],
       selected_tag: ""
     )}
  end

  def handle_event("filter_boats", params, socket) do
    tag = Map.get(params, "selected_tag", "")
    prices = Map.get(params, "selected_prices", [])

    boats = Boats.filter_boats(prices, if(tag == "", do: [], else: [tag]))

    {:noreply,
     assign(
       socket,
       selected_prices: prices,
       selected_tag: tag,
       boats: boats
     )}
  end

  def render(assigns) do
    ~H"""
    <div class="space-y-12 mx-auto">
      <h1 class="text-5xl font-extrabold text-center">Daily Boat Rentals</h1>

      <form phx-change="filter_boats" class="flex justify-between gap-4">
        <.filter_by_tag tags={@tags} selected_tag={@selected_tag} />
        <.filter_by_price prices={@prices} selected_prices={@selected_prices} />
      </form>

      <ul class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
        <li :for={boat <- @boats}>
          <.boat boat={boat} />
        </li>
      </ul>
    </div>
    """
  end

  def filter_by_tag(assigns) do
    ~H"""
    <div class="border rounded-lg border-zinc-300 border-2 py-2 px-4">
      <select name="selected_tag">
        <option selected={@selected_tag == ""} value="">All</option>
        <option :for={tag <- @tags} selected={@selected_tag == tag} value={tag}>
          {tag}
        </option>
      </select>
    </div>
    """
  end

  def filter_by_price(assigns) do
    ~H"""
    <div class="grid grid-cols-4 rounded-lg border border-zinc-200 border-2 divide-x divide-zinc-200">
      <div :for={price <- @prices} class="relative">
        <input
          type="checkbox"
          name="selected_prices[]"
          value={price}
          id={"price-#{price}"}
          class="absolute opacity-0 w-0 h-0 peer"
          checked={price in @selected_prices}
        />
        <label
          for={"price-#{price}"}
          class="block px-4 py-2 text-center hover:bg-zinc-100 cursor-pointer first-of-type:rounded-none peer-checked:bg-zinc-200"
        >
          {price}
        </label>
      </div>
    </div>
    """
  end

  attr :boat, Boat, required: true

  defp boat(assigns) do
    ~H"""
    <div class="border rounded-lg border-zinc-200 shadow-sm">
      <img src={@boat.image} alt={@boat.name} class="max-w-full" />
      <div class="p-6 space-y-6">
        <h2 class="text-lg text-center font-bold">{@boat.name}</h2>
        <div class="flex justify-between gap-2">
          <span class="font-bold text-zinc-700">{@boat.price}</span>
          <ul class="inline-flex gap-1">
            <li :for={tag <- @boat.tags}>
              <span class="text-xs bg-zinc-200/50 rounded-full px-2 py-1">{tag}</span>
            </li>
          </ul>
        </div>
      </div>
    </div>
    """
  end
end
