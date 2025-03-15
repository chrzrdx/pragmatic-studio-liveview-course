defmodule LiveviewWeb.ServersLive do
  use LiveviewWeb, :live_view

  alias Liveview.Servers

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, coffees: 0)}
  end

  @impl true
  def handle_params(%{"id" => id}, _uri, socket) do
    servers = Servers.list_servers()
    selected_server = Servers.get_server!(String.to_integer(id))

    socket =
      socket
      |> assign(selected_server: selected_server)
      |> stream(:servers, servers)

    {:noreply, socket}
  end

  def handle_params(_, _uri, socket) do
    servers = Servers.list_servers()
    selected_server = hd(servers)

    socket =
      socket
      |> assign(selected_server: selected_server)
      |> stream(:servers, servers)

    {:noreply, socket}
  end

  @impl true
  def handle_event("add_coffee", _params, socket) do
    {:noreply, update(socket, :coffees, &(&1 + 1))}
  end

  defp format_size(size) when size < 1024, do: "#{size} KB"

  defp format_size(size) when size < 1024 * 1024, do: "#{Float.round(size / 1024, 1)} MB"

  defp format_size(size) when size < 1024 * 1024 * 1024,
    do: "#{Float.round(size / 1024 / 1024, 1)} GB"
end
