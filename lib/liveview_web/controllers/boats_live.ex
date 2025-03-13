defmodule LiveviewWeb.BoatsLive do
  use LiveviewWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok,
     assign(socket,
       boats: []
     )}
  end

  def render(assigns) do
    ~H"""
    <div class="space-y-12 mx-auto">
      <h1 class="text-5xl font-extrabold text-center">Daily Boat Rentals</h1>

      <div></div>

      <ul>
        <li :for={boat <- @boats}>
          <div class="flex items-center gap-2">
            <img src={boat.image} alt={boat.name} class="w-16 h-16 rounded-lg" />
            <div>
              <h2 class="text-2xl font-bold">{boat.name}</h2>
            </div>
          </div>
        </li>
      </ul>
    </div>
    """
  end
end
