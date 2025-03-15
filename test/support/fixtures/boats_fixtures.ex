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
        image: "https://placehold.co/600x400/E6F7FF/31343C.svg?font=playfair-display&text=Boat+1",
        name: "some name",
        price: "$$",
        tags: ["option1", "option2"]
      })
      |> Liveview.Boats.create_boat()

    boat
  end
end
