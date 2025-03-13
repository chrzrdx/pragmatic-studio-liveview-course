# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Liveview.Repo.insert!(%Liveview.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

defmodule Liveview.Boat.Seeder do
  alias Liveview.Repo
  alias Liveview.Boats.Boat

  @tags [
    "Motor",
    "Sail",
    "Luxury",
    "Fishing",
    "Sport",
    "Family",
    "Cruiser",
    "Yacht",
    "Catamaran",
    "Speedboat",
    "Pontoon",
    "Houseboat",
    "Dinghy",
    "Trawler",
    "Classic",
    "Modern"
  ]

  @colors [
    "E6F7FF",
    "FFEBEE",
    "E8F5E9",
    "FFF8E1",
    "F3E5F5",
    "E0F7FA",
    "FFF3E0",
    "F1F8E9",
    "E8EAF6",
    "FAFAFA"
  ]

  @prices ["$", "$$", "$$$", "$$$$"]

  @boat_names [
    "Sea Breeze Explorer",
    "Voyager",
    "Coastal Explorer",
    "Wave Dancer",
    "Horizon Ocean Chaser",
    "Aqua",
    "Blue Marlin",
    "Sunset Cruiser",
    "Northern Star",
    "Spray",
    "Golden Caribbean Tide",
    "Royal",
    "Emerald Wake",
    "Ruby",
    "Diamond Seas",
    "Sapphire Ocean Surf",
    "Pearl",
    "Coral Reef",
    "Current",
    "Amber Sea Wanderer",
    "Crystal",
    "Velvet Tide",
    "Sailor",
    "Ivory Coast",
    "Ebony Morning Wake",
    "Crimson",
    "Azure Drift",
    "Pacific Ocean Explorer",
    "Violet",
    "Turquoise Bay Cruiser"
  ]

  def random_price, do: Enum.random(@prices)

  def random_tags, do: Enum.take_random(@tags, Enum.random(1..2))

  defp random_color, do: Enum.random(@colors)

  defp create_image_url(name) do
    # URL encode the boat name for the image URL
    encoded_name = URI.encode(name)
    bg_color = random_color()

    "https://placehold.co/600x400/#{bg_color}/31343C.svg?font=playfair-display&text=#{encoded_name}"
  end

  def run() do
    Repo.delete_all(Boat)

    boats =
      Enum.map(@boat_names, fn name ->
        %{
          name: name,
          image: create_image_url(name),
          tags: random_tags(),
          price: random_price()
        }
      end)

    # Insert boats
    Enum.each(boats, fn boat_data ->
      %Boat{}
      |> Boat.changeset(boat_data)
      |> Repo.insert!()
    end)

    IO.puts("Seeded #{length(boats)} boats")
  end
end

Liveview.Boat.Seeder.run()
