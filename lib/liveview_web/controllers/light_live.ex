defmodule LiveviewWeb.LightLive do
  use LiveviewWeb, :live_view

  @temperatures [3000, 4000, 5000]
  @default_temperature @temperatures |> List.first()

  def mount(_params, _session, socket) do
    {:ok,
     assign(socket,
       brightness: 10,
       temperature: @default_temperature,
       temperatures: @temperatures
     )}
  end

  def handle_event("off", _params, socket) do
    {:noreply, assign(socket, :brightness, 0)}
  end

  def handle_event("down", _params, socket) do
    {:noreply, update(socket, :brightness, &max(&1 - 10, 0))}
  end

  def handle_event("random", _params, socket) do
    {:noreply, assign(socket, :brightness, Enum.random(0..100))}
  end

  def handle_event("up", _params, socket) do
    {:noreply, update(socket, :brightness, &min(&1 + 10, 100))}
  end

  def handle_event("on", _params, socket) do
    {:noreply, assign(socket, :brightness, 100)}
  end

  def handle_event("set_temperature", %{"temperature" => temperature}, socket) do
    temperature = String.to_integer(temperature)

    temperature =
      if temperature in @temperatures, do: temperature, else: @default_temperature

    {:noreply, assign(socket, :temperature, temperature)}
  end

  def render(assigns) do
    ~H"""
    <div class="space-y-12">
      <h1 class="text-5xl font-extrabold text-center">Front porch light</h1>

      <div class="space-y-8">
        <.meter brightness={@brightness} temperature={@temperature} />

        <div class="flex gap-4 justify-center">
          <.action phx-click="off" icon="light-off" />
          <.action phx-click="down" icon="down" />
          <.action phx-click="random" icon="fire" />
          <.action phx-click="up" icon="up" />
          <.action phx-click="on" icon="light-on" />
        </div>

        <form phx-change="set_temperature">
          <ul class="flex gap-4 text-xl justify-center">
            <li :for={temp <- @temperatures}>
              <label class="p-2">
                <input type="radio" name="temperature" value={temp} checked={@temperature == temp} />
                {temp}K
              </label>
            </li>
          </ul>
        </form>
      </div>
    </div>
    """
  end

  attr :brightness, :integer, required: true
  attr :temperature, :integer, required: true

  defp meter(assigns) do
    ~H"""
    <div class="h-16 rounded-xl bg-zinc-200 overflow-clip">
      <div
        class={[
          "h-full text-2xl font-bold rounded-xl flex items-center transition-all duration-300 ease-out justify-center",
          meter_color(@temperature)
        ]}
        style={"width: #{@brightness}%"}
      >
        <span class={if(@brightness < 10, do: "pl-12", else: "")}>{@brightness}%</span>
      </div>
    </div>
    """
  end

  defp meter_color(3000), do: "bg-red-400"
  defp meter_color(4000), do: "bg-orange-400"
  defp meter_color(5000), do: "bg-yellow-400"
  defp meter_color(_), do: "bg-zinc-400"

  attr :icon, :string, required: true
  attr :rest, :global

  defp action(assigns) do
    ~H"""
    <button
      class="p-3 bg-white transition-colors size-16 border-2 border-zinc-500 rounded-xl hover:bg-zinc-100 cursor-pointer"
      {@rest}
    >
      <img src={"/images/#{@icon}.svg"} alt={String.capitalize(@icon)} />
    </button>
    """
  end
end
