defmodule LiveviewWeb.SalesLive do
  use LiveviewWeb, :live_view
  alias Liveview.Sales

  def mount(_params, _session, socket) do
    if connected?(socket) do
      :timer.send_interval(1000, :tick)
    end

    {:ok, fetch_data(socket)}
  end

  def handle_event("refresh", _params, socket) do
    {:noreply, fetch_data(socket)}
  end

  def handle_info(:tick, socket) do
    {:noreply, fetch_data(socket)}
  end

  defp fetch_data(socket) do
    assign(socket,
      new_orders: Sales.new_orders(),
      sales_amount: "$#{Sales.sales_amount()}",
      satisfaction: "#{Sales.satisfaction()}%"
    )
  end

  def render(assigns) do
    ~H"""
    <div class="space-y-12">
      <h1 class="text-5xl font-extrabold text-center">Snappy Sales 📊</h1>
      <ul class="border border-zinc-300 bg-white p-10 shadow-lg rounded-xl flex gap-16 justify-around items-center">
        <li class="flex-1">
          <.stat value={@new_orders} label="New Orders" />
        </li>
        <li class="flex-1">
          <.stat value={@sales_amount} label="Sales Amount" />
        </li>
        <li class="flex-1">
          <.stat value={@satisfaction} label="Satisfaction" />
        </li>
      </ul>
      <button
        phx-click="refresh"
        class="cursor-pointer hover:bg-indigo-100 transition-colors duration-100 bg-indigo-50 text-lg font-medium shadow-sm border border-indigo-300 text-indigo-800 px-5 py-3 rounded-md"
      >
        🔄 Refresh
      </button>
    </div>
    """
  end

  attr :value, :string, required: true
  attr :label, :string, required: true

  defp stat(assigns) do
    ~H"""
    <div class="flex flex-col items-center gap-3">
      <span class="text-indigo-700 text-7xl font-extrabold">{@value}</span>
      <span class="text-2xl font-medium text-zinc-600">{@label}</span>
    </div>
    """
  end
end
