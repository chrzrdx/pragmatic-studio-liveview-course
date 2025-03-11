defmodule LiveviewWeb.BingoLive do
  use LiveviewWeb, :live_view

  def mount(_params, _session, socket) do
    if connected?(socket) do
      :timer.send_interval(3000, :tick)
    end

    socket =
      assign(socket,
        number: nil,
        numbers: all_numbers()
      )

    {:ok, socket}
  end

  def handle_info(:tick, socket) do
    {:noreply, pick(socket)}
  end

  def render(assigns) do
    ~H"""
    <div class="space-y-8">
      <h1 class="text-5xl font-bold">Bingo Boss 📢</h1>
      <div class="text-7xl text-indigo-700 font-extrabold">
        <span :if={@number}>{@number}</span>
        <span :if={!@number}>&hellip;</span>
      </div>
      <ul class="grid grid-cols-15 gap-4">
        <li :for={number <- @numbers}>{number}</li>
      </ul>
    </div>
    """
  end

  # Assigns the next random bingo number, removing it
  # from the assigned list of numbers. Resets the list
  # when the last number has been picked.
  def pick(socket) do
    case socket.assigns.numbers do
      [head | []] ->
        assign(socket, number: head, numbers: all_numbers())

      [head | tail] ->
        assign(socket, number: head, numbers: tail)
    end
  end

  # Returns a list of all valid bingo numbers in random order.
  #
  # Example: ["B 4", "N 40", "O 73", "I 29", ...]
  def all_numbers() do
    ~w(B I N G O)
    |> Enum.zip(Enum.chunk_every(1..75, 15))
    |> Enum.flat_map(fn {letter, numbers} ->
      Enum.map(numbers, &"#{letter} #{&1}")
    end)
    |> Enum.shuffle()
  end
end
