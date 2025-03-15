defmodule Liveview.ServersTest do
  use Liveview.DataCase
  alias Liveview.Servers
  alias Liveview.Servers.Server

  describe "servers" do
    import Liveview.ServersFixtures

    @invalid_attrs %{
      name: nil,
      size: nil,
      status: nil,
      stack: nil,
      deploys: nil,
      last_commit: nil
    }

    test "list_servers/0 returns all servers" do
      server = server_fixture()
      assert Servers.list_servers() == [server]
    end

    test "get_server!/1 returns the server with given id" do
      server = server_fixture()
      assert Servers.get_server!(server.id) == server
    end

    test "create_server/1 with valid data creates a server" do
      name = "server-name-#{System.unique_integer([:positive])}"

      valid_attrs = %{
        name: name,
        size: 42,
        status: "up",
        stack: "some stack",
        deploys: 42,
        last_commit: "some last_commit"
      }

      assert {:ok, %Server{} = server} = Servers.create_server(valid_attrs)
      assert server.name == name
      assert server.size == 42
      assert server.status == "up"
      assert server.stack == "some stack"
      assert server.deploys == 42
      assert server.last_commit == "some last_commit"
    end

    test "create_server/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Servers.create_server(@invalid_attrs)
    end

    test "update_server/2 with valid data updates the server" do
      server = server_fixture()

      update_attrs = %{
        name: "some updated name",
        size: 43,
        status: "down",
        stack: "some updated stack",
        deploys: 43,
        last_commit: "some updated last_commit"
      }

      assert {:ok, %Server{} = server} = Servers.update_server(server, update_attrs)
      assert server.name == "some updated name"
      assert server.size == 43
      assert server.status == "down"
      assert server.stack == "some updated stack"
      assert server.deploys == 43
      assert server.last_commit == "some updated last_commit"
    end

    test "update_server/2 with invalid data returns error changeset" do
      server = server_fixture()
      assert {:error, %Ecto.Changeset{}} = Servers.update_server(server, @invalid_attrs)
      assert server == Servers.get_server!(server.id)
    end

    test "delete_server/1 deletes the server" do
      server = server_fixture()
      assert {:ok, %Server{}} = Servers.delete_server(server)
      assert_raise Ecto.NoResultsError, fn -> Servers.get_server!(server.id) end
    end

    test "change_server/1 returns a server changeset" do
      server = server_fixture()
      assert %Ecto.Changeset{} = Servers.change_server(server)
    end
  end
end
