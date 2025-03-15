defmodule Liveview.BoatsTest do
  use Liveview.DataCase

  alias Liveview.Boats

  describe "boats" do
    alias Liveview.Boats.Boat

    import Liveview.BoatsFixtures

    @invalid_attrs %{name: nil, image: nil, price: nil, tags: nil}

    test "list_boats/0 returns all boats" do
      boat = boat_fixture()
      [returned_boat] = Boats.list_boats()

      # Check specific fields including ID
      assert returned_boat.id == boat.id
      assert returned_boat.name == boat.name
      assert returned_boat.price == boat.price
      assert returned_boat.tags == boat.tags
    end

    test "get_boat!/1 returns the boat with given id" do
      boat = boat_fixture()
      assert Boats.get_boat!(boat.id) == boat
    end

    test "create_boat/1 with valid data creates a boat" do
      valid_attrs = %{
        name: "some name",
        image: "https://placehold.co/600x400/E6F7FF/31343C.svg?font=playfair-display&text=Boat+1",
        price: "$$",
        tags: ["option1", "option2"]
      }

      assert {:ok, %Boat{} = boat} = Boats.create_boat(valid_attrs)
      assert boat.name == "some name"

      assert boat.image ==
               "https://placehold.co/600x400/E6F7FF/31343C.svg?font=playfair-display&text=Boat+1"

      assert boat.price == "$$"
      assert boat.tags == ["option1", "option2"]
    end

    test "create_boat/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Boats.create_boat(@invalid_attrs)
    end

    test "update_boat/2 with valid data updates the boat" do
      boat = boat_fixture()

      update_attrs = %{
        name: "some updated name",
        image: "https://placehold.co/600x400/E6F7FF/31343C.svg?font=playfair-display&text=Boat+2",
        price: "$$$$",
        tags: ["option1"]
      }

      assert {:ok, %Boat{} = boat} = Boats.update_boat(boat, update_attrs)
      assert boat.name == "some updated name"

      assert boat.image ==
               "https://placehold.co/600x400/E6F7FF/31343C.svg?font=playfair-display&text=Boat+2"

      assert boat.price == "$$$$"
      assert boat.tags == ["option1"]
    end

    test "update_boat/2 with invalid data returns error changeset" do
      boat = boat_fixture()
      assert {:error, %Ecto.Changeset{}} = Boats.update_boat(boat, @invalid_attrs)
      assert boat == Boats.get_boat!(boat.id)
    end

    test "delete_boat/1 deletes the boat" do
      boat = boat_fixture()
      assert {:ok, %Boat{}} = Boats.delete_boat(boat)
      assert_raise Ecto.NoResultsError, fn -> Boats.get_boat!(boat.id) end
    end

    test "change_boat/1 returns a boat changeset" do
      boat = boat_fixture()
      assert %Ecto.Changeset{} = Boats.change_boat(boat)
    end
  end
end
