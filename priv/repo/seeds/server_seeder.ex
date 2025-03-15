defmodule Liveview.Seeds.ServerSeeder do
  alias Liveview.Repo
  alias Liveview.Servers.Server

  @servers [
    %{
      name: "swift-falcon",
      status: "up",
      deploys: 5,
      size: 147_456, # ~147MB
      stack: "Elixir/Phoenix",
      last_commit: "Add user authentication and OAuth support"
    },
    %{
      name: "silent-bear",
      status: "up",
      deploys: 3,
      size: 98_304, # ~98MB
      stack: "Python/Flask",
      last_commit: "Fix memory leak in WebSocket connection"
    },
    %{
      name: "mighty-whale",
      status: "down",
      deploys: 10,
      size: 245_760, # ~245MB
      stack: "Node/React",
      last_commit: "Update dependencies and fix security vulnerabilities"
    },
    %{
      name: "clever-fox",
      status: "up",
      deploys: 2,
      size: 184_320, # ~184MB
      stack: "Elixir/Phoenix",
      last_commit: "Implement real-time dashboard features"
    },
    %{
      name: "fierce-tiger",
      status: "down",
      deploys: 8,
      size: 122_880, # ~122MB
      stack: "Next.js",
      last_commit: "Optimize Docker build and reduce image size"
    }
  ]

  def run do
    Repo.delete_all(Server)

    Enum.each(@servers, fn server_data ->
      %Server{}
      |> Server.changeset(server_data)
      |> Repo.insert!()
    end)

    IO.puts("Seeded #{length(@servers)} servers")
  end
end
