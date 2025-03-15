defmodule Liveview.ServersFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Liveview.Servers` context.
  """

  @doc """
  Generate a unique server name.
  """
  def unique_server_name, do: "some-name-#{System.unique_integer([:positive])}"

  @doc """
  Generate a server.
  """
  def server_fixture(attrs \\ %{}) do
    {:ok, server} =
      attrs
      |> Enum.into(%{
        deploys: 42,
        last_commit: "some last_commit",
        name: unique_server_name(),
        size: 42,
        stack: "some stack",
        status: "up"
      })
      |> Liveview.Servers.create_server()

    server
  end
end
