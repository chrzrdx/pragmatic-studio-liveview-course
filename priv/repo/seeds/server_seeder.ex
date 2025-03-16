defmodule Liveview.Repo.Seeds.ServerSeeder do
  alias Liveview.Repo
  alias Liveview.Servers.Server

  @servers [
    %{
      name: "swift-falcon",
      status: "up",
      deploys: 5,
      size: 147_456,
      stack: "Elixir/Phoenix",
      last_commit: "Add user authentication and OAuth support"
    },
    %{
      name: "silent-bear",
      status: "down",
      deploys: 3,
      size: 96_304,
      stack: "Python/Flask",
      last_commit: "Fix memory leak in WebSocket connection"
    },
    %{
      name: "mighty-whale",
      status: "up",
      deploys: 10,
      size: 248_760,
      stack: "Node/React",
      last_commit: "Update dependencies and fix security vulnerabilities"
    },
    %{
      name: "clever-fox",
      status: "up",
      deploys: 2,
      size: 181_320,
      stack: "Elixir/Phoenix",
      last_commit: "Implement real-time dashboard features"
    },
    %{
      name: "fierce-tiger",
      status: "up",
      deploys: 8,
      size: 123_280,
      stack: "Next.js",
      last_commit: "Optimize Docker build and reduce image size"
    }
  ]

  def run do
    Repo.delete_all(Server)

    now = DateTime.utc_now(:second)

    servers =
      Enum.map(@servers, fn server_data ->
        server_data
        |> Map.put(:inserted_at, now)
        |> Map.put(:updated_at, now)
      end)

    Repo.insert_all(Server, servers)

    IO.puts("Seeded #{length(servers)} servers")
  end
end
