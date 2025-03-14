defmodule LiveviewWeb.SandboxLive do
  use LiveviewWeb, :live_view

  alias Liveview.Sandbox

  def mount(params, _session, socket) do
    {l, w, h} = validate_params(params)

    {
      :ok,
      assign(socket,
        length: l,
        width: w,
        height: h,
        weight: Sandbox.calculate_weight(l, w, h),
        price: nil
      )
    }
  end

  def handle_event("update", params, socket) do
    {l, w, h} = validate_params(params)

    {
      :noreply,
      assign(
        socket,
        length: l,
        width: w,
        height: h,
        weight: Sandbox.calculate_weight(l, w, h),
        price: nil
      )
    }
  end

  def handle_event("get-quote", params, socket) do
    {l, w, h} = validate_params(params)

    weight = Sandbox.calculate_weight(l, w, h)
    price = Sandbox.calculate_price(weight)

    {
      :noreply,
      assign(
        socket,
        length: l,
        width: w,
        height: h,
        weight: weight,
        price: price
      )
    }
  end

  def render(assigns) do
    ~H"""
    <div class="mx-auto max-w-2xl space-y-12">
      <h1 class="text-center text-5xl font-extrabold">Build a sandbox</h1>
      <div class="flex flex-col items-center gap-8 rounded-xl border border-zinc-300 bg-white p-8 shadow">
        <form phx-change="update" phx-submit="get-quote" id="sandbox">
          <div class="flex flex-wrap gap-8">
            <.dimension label="Length" unit="feet" id="length" name="length" value={@length} />
            <.dimension label="Width" unit="feet" id="width" name="width" value={@width} />
            <.dimension label="Height" unit="inch" id="height" name="height" value={@height} />
          </div>
        </form>
        <div class="text-2xl font-bold">
          You need {@weight} pounds of sand 🏖️
        </div>
        <button
          form="sandbox"
          type="submit"
          class="cursor-pointer rounded-md bg-green-500 px-8 py-4 text-2xl font-bold text-white transition-colors hover:bg-green-600"
        >
          Get a quote
        </button>
      </div>
      <.price_quote :if={@price} price={@price} />
    </div>
    """
  end

  attr :id, :string, required: true
  attr :name, :string, required: true
  attr :value, :string, required: true
  attr :label, :string, required: true
  attr :unit, :string, required: true
  attr :rest, :global

  defp dimension(assigns) do
    ~H"""
    <div class="w-full space-y-2 sm:w-auto">
      <label class="block text-center text-xl font-bold" for={@id}>{@label}</label>
      <div class="flex items-center gap-2 rounded-lg border-2 border-zinc-200 px-4 py-3 text-lg focus-within:border-zinc-600">
        <input
          class="w-full outline-none"
          type="number"
          min="0"
          max="99999"
          autocomplete="off"
          id={@id}
          name={@name}
          value={@value}
        />
        <span class="text-zinc-500">{@unit}</span>
      </div>
    </div>
    """
  end

  attr :price, :string, required: true

  defp price_quote(assigns) do
    ~H"""
    <div class="border-8 border-dotted p-8 text-2xl font-bold text-green-700">
      Get your personal beach day today for only {@price}
    </div>
    """
  end

  # Validates and extracts length, width, and height from params
  defp validate_params(params) do
    l = Map.get(params, "length", "0")
    w = Map.get(params, "width", "0")
    h = Map.get(params, "height", "0")

    {
      validate_input(l),
      validate_input(w),
      validate_input(h)
    }
  end

  # Validates input by ensuring positive numbers and handling empty inputs
  defp validate_input(value) when is_binary(value) do
    case value do
      "" ->
        "0"

      _ ->
        # Parse as float, take absolute value, convert back to string
        {num, _} = Float.parse(value)
        num |> abs() |> Float.to_string() |> String.trim_trailing(".0")
    end
  end
end
