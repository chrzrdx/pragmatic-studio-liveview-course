defmodule Liveview.BoatsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Liveview.Boats` context.
  """

  @doc """
  Generate a boat.
  """
  def boat_fixture(attrs \\ %{}) do
    {:ok, boat} =
      attrs
      |> Enum.into(%{
        image: "some image",
        name: "some name",
        price: "some price",
        tags: ["option1", "option2"]
      })
      |> Liveview.Boats.create_boat()

    boat
  end
end
