defmodule LiveviewWeb.LightController do
  use LiveviewWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, assign(socket, brightness: 10)}
  end

  def handle_event("off", _params, socket) do
    {:noreply, assign(socket, brightness: 0)}
  end

  def handle_event("down", _params, socket) do
    {:noreply, update(socket, :brightness, &max(&1 - 10, 0))}
  end

  def handle_event("random", _params, socket) do
    {:noreply, assign(socket, brightness: Enum.random(0..100))}
  end

  def handle_event("up", _params, socket) do
    {:noreply, update(socket, :brightness, &min(&1 + 10, 100))}
  end

  def handle_event("on", _params, socket) do
    {:noreply, assign(socket, brightness: 100)}
  end

  def render(assigns) do
    ~H"""
    <div class="space-y-12">
      <h1 class="text-4xl font-extrabold text-center">Front porch light</h1>

      <div class="space-y-8">
        <.meter brightness={@brightness} />

        <div class="flex gap-4 justify-center">
          <.action phx-click="off" icon="light-off" />
          <.action phx-click="down" icon="down" />
          <.action phx-click="random" icon="fire" />
          <.action phx-click="up" icon="up" />
          <.action phx-click="on" icon="light-on" />
        </div>
      </div>
    </div>
    """
  end

  defp meter(assigns) do
    ~H"""
    <div class="h-16 rounded-xl bg-zinc-200 overflow-clip">
      <div
        class="h-full text-2xl font-bold bg-yellow-400 rounded-xl flex items-center transition-width duration-300 ease-out justify-center"
        style={"width: #{@brightness}%"}
      >
        <span class={@brightness < 10 && "pl-12"}>{@brightness}%</span>
      </div>
    </div>
    """
  end

  defp action(assigns) do
    ~H"""
    <button
      class="p-3 size-16 border-2 border-zinc-500 rounded-xl hover:bg-zinc-50 cursor-pointer"
      {assigns_to_attributes(assigns, [:icon])}
    >
      <img src={"/images/#{@icon}.svg"} alt={String.capitalize(@icon)} />
    </button>
    """
  end
end
