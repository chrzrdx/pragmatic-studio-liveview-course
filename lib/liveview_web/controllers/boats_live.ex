defmodule LiveviewWeb.BoatsLive do
  use LiveviewWeb, :live_view
  alias Liveview.Boats
  alias Liveview.Boats.Boat

  def mount(_params, _session, socket) do
    boats = Boats.list_boats()

    {
      :ok,
      socket
      |> assign(
        all_tags: Boats.list_tags(),
        all_prices: Boats.list_prices(),
        filters: %{tag: "", prices: []}
      )
      |> stream(:boats, boats)
    }
  end

  def handle_event("filter_boats", params, socket) do
    tag = Map.get(params, "tag", "")
    tags = if tag == "", do: [], else: [tag]
    prices = Map.get(params, "prices", [])

    boats = Boats.list_boats(%{tags: tags, prices: prices})

    {
      :noreply,
      socket
      |> assign(filters: %{tag: tag, prices: prices})
      |> stream(:boats, boats, reset: true)
    }
  end

  def render(assigns) do
    ~H"""
    <div class="mx-auto space-y-12">
      <h1 class="text-center text-5xl font-extrabold">Daily Boat Rentals</h1>

      <form phx-change="filter_boats" class="flex flex-col justify-between gap-4 sm:flex-row">
        <.filter_by_tag tags={@all_tags} selected_tag={@filters.tag} />
        <.filter_by_price prices={@all_prices} selected_prices={@filters.prices} />
      </form>

      <ul id="boats" phx-update="stream" class="grid grid-cols-1 gap-4 md:grid-cols-2 lg:grid-cols-3">
        <li :for={{dom_id, boat} <- @streams.boats} id={dom_id}>
          <.boat boat={boat} />
        </li>
        <li id="empty-boats" class="col-span-full hidden py-8 text-center first-of-type:block">
          <p class="text-xl text-zinc-700">No boats match your filters</p>
        </li>
      </ul>
    </div>
    """
  end

  def filter_by_tag(assigns) do
    ~H"""
    <div class="rounded-lg border-2 border-zinc-300 px-4 py-2 focus-within:border-transparent focus-within:ring-2 focus-within:ring-indigo-500">
      <select name="tag" class="w-full outline-none">
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
    <div class="grid grid-cols-4 divide-x-2 divide-zinc-300 overflow-clip rounded-lg border-2 border-zinc-300">
      <div :for={price <- @prices} class="relative">
        <input
          type="checkbox"
          name="prices[]"
          value={price}
          id={"price-#{price}"}
          class="peer absolute h-0 w-0 opacity-0"
          checked={price in @selected_prices}
        />
        <label
          for={"price-#{price}"}
          class="block cursor-pointer px-4 py-2 text-center hover:bg-indigo-100 peer-checked:bg-indigo-200"
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
    <div class="rounded-lg border border-zinc-200 shadow-sm">
      <img
        src={@boat.image}
        alt={@boat.name}
        class="w-full object-cover"
        width="600"
        height="400"
        loading="lazy"
      />
      <div class="space-y-6 p-6">
        <h2 class="text-center text-lg font-bold">{@boat.name}</h2>
        <div class="flex justify-between gap-2">
          <span class="font-bold text-zinc-700">{@boat.price}</span>
          <ul class="inline-flex gap-1">
            <li :for={tag <- @boat.tags}>
              <span class="bg-zinc-200/50 rounded-full px-2 py-1 text-xs">{tag}</span>
            </li>
          </ul>
        </div>
      </div>
    </div>
    """
  end
end
