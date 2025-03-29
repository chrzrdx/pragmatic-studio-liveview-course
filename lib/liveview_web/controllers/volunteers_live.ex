defmodule LiveviewWeb.VolunteersLive do
  use LiveviewWeb, :live_view
  alias Liveview.Volunteers
  alias Liveview.Volunteers.Volunteer

  def mount(_params, _session, socket) do
    volunteers = Volunteers.list_volunteers()

    {:ok,
     socket
     |> assign_form()
     |> stream(:volunteers, volunteers)}
  end

  def handle_event("validate", %{"volunteer" => params}, socket) do
    changeset = Volunteers.change_volunteer(%Volunteer{}, params)
    {:noreply, assign_form(socket, changeset, :validate)}
  end

  def handle_event("save", %{"volunteer" => params}, socket) do
    case Volunteers.create_volunteer(params) do
      {:ok, volunteer} ->
        {:noreply,
         socket
         |> assign_form()
         |> stream_insert(:volunteers, volunteer, at: 0)
         |> put_flash(:info, "Volunteer created successfully")}

      {:error, changeset} ->
        {:noreply,
         socket
         |> assign_form(changeset, :inserts)
         |> put_flash(:error, "Could not create volunteer")}
    end
  end

  defp assign_form(
         socket,
         changeset \\ %Volunteer{} |> Volunteers.change_volunteer(),
         action \\ nil
       ),
       do: assign(socket, form: to_form(changeset, action: action, as: :volunteer))

  def render(assigns) do
    ~H"""
    <div class="grid gap-12">
      <h1 class="text-center text-5xl font-extrabold">Volunteers Check-In</h1>

      <.form
        for={@form}
        phx-submit="save"
        phx-change="validate"
        class="flex items-start justify-between gap-8 rounded-lg border-4 border-dotted border-zinc-300 p-6 text-xl"
      >
        <.vinput phx-debounce="1000" field={@form[:name]} type="text" placeholder="Name" />
        <.vinput phx-debounce="blur" field={@form[:phone]} type="tel" placeholder="Phone" />
        <button
          phx-disable-with="..."
          type="submit"
          class="min-w-[12ch] cursor-pointer rounded bg-amber-700 px-4 py-2 font-bold text-white transition-colors hover:bg-amber-800 focus:bg-amber-800 phx-submit-loading:opacity-75"
        >
          Check In
        </button>
      </.form>

      <ul class="grid gap-4" id="volunteers" phx-update="stream">
        <li
          :for={{id, volunteer} <- @streams.volunteers}
          id={id}
          class="grid-cols-[1fr_1fr_auto] shadow-xs grid items-center gap-2 rounded border border-zinc-200 bg-white p-6 text-xl"
        >
          <span class="font-bold text-green-950">{volunteer.name}</span>
          <span>{volunteer.phone}</span>
          <button
            type="button"
            class="cursor-pointer rounded bg-green-600 px-4 py-2 font-bold text-white transition-colors hover:bg-green-700 focus:bg-green-700"
          >
            Check out
          </button>
        </li>
      </ul>
    </div>
    """
  end

  attr :id, :any, default: nil
  attr :name, :any
  attr :value, :any
  attr :type, :string, default: "text"
  attr :errors, :list, default: []
  attr :autocomplete, :string, default: "off"
  attr :field, Phoenix.HTML.FormField
  attr :rest, :global

  def vinput(%{field: %Phoenix.HTML.FormField{} = field} = assigns) do
    errors = if Phoenix.Component.used_input?(field), do: field.errors, else: []

    assigns
    |> assign(
      field: nil,
      id: field.id,
      errors: Enum.map(errors, &LiveviewWeb.CoreComponents.translate_error(&1)),
      name: field.name,
      value: field.value
    )
    |> vinput()
  end

  def vinput(assigns) do
    ~H"""
    <div class="flex flex-1 flex-col gap-1">
      <input
        type={@type}
        name={@name}
        id={@id}
        value={Phoenix.HTML.Form.normalize_value(@type, @value)}
        class={[
          "block w-full rounded-lg border bg-white px-4 py-2 text-zinc-900 focus:ring-0",
          @errors == [] && "border-zinc-300 focus:border-zinc-400",
          @errors != [] && "border-rose-400 focus:border-rose-400"
        ]}
        autocomplete={@autocomplete}
        {@rest}
      />
      <ul :if={@errors != []}>
        <li :for={msg <- @errors} class="pl-2 text-sm text-red-500">{msg}</li>
      </ul>
    </div>
    """
  end
end
