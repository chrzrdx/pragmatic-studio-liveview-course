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
      <h1 class="text-center text-5xl font-extrabold">Snappy Sales 📊</h1>
      <ul class="flex flex-wrap items-center justify-around gap-16 rounded-xl border border-zinc-300 bg-white p-10 shadow-lg">
        <li class="min-w-content">
          <.stat value={@new_orders} label="New Orders" />
        </li>
        <li class="min-w-content">
          <.stat value={@sales_amount} label="Sales Amount" />
        </li>
        <li class="min-w-content">
          <.stat value={@satisfaction} label="Satisfaction" />
        </li>
      </ul>
      <button
        phx-click="refresh"
        class="cursor-pointer rounded-md border border-indigo-300 bg-indigo-50 px-5 py-3 text-lg font-medium text-indigo-800 shadow-sm transition-colors duration-100 hover:bg-indigo-100"
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
      <span class="text-7xl font-extrabold text-indigo-700">{@value}</span>
      <span class="text-2xl font-medium text-zinc-600">{@label}</span>
    </div>
    """
  end
end
