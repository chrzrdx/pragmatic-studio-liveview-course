defmodule Liveview.Seeds.BoatSeeder do
  alias Liveview.Repo
  alias Liveview.Boats.Boat
  alias Liveview.Seeds.Utils

  @tags [
    "Motor", "Sail", "Luxury", "Fishing", "Sport", "Family",
    "Cruiser", "Yacht", "Catamaran", "Speedboat", "Pontoon",
    "Houseboat", "Dinghy", "Trawler", "Classic", "Modern"
  ]

  @prices ["$", "$$", "$$$", "$$$$"]

  @boat_names [
    "Sea Breeze Explorer", "Voyager", "Coastal Explorer", "Ocean Mist",
    "Serenity", "Wave Dancer", "Northern Star", "Blue Horizon",
    "Aqua Dream", "Sea Spirit", "Wind Chaser", "Destiny",
    "Royal Wave", "Sea Dragon", "Ocean Pearl", "Storm Chaser",
    "Nautical Dream", "Sea Wolf", "Poseidon", "Triton",
    "Coral Princess", "Neptune", "Atlantic Wanderer", "Mariner",
    "Sea Witch", "Ocean Whisper", "Salty Dog", "Mermaid Queen",
    "Sea Rover", "Golden Compass"
  ]

  def run do
    Repo.delete_all(Boat)

    boats =
      Enum.map(@boat_names, fn name ->
        %{
          name: name,
          image: Utils.create_image_url(name),
          tags: random_tags(),
          price: random_price()
        }
      end)

    Enum.each(boats, fn boat_data ->
      %Boat{}
      |> Boat.changeset(boat_data)
      |> Repo.insert!()
    end)

    IO.puts("Seeded #{length(boats)} boats")
  end

  defp random_price, do: Enum.random(@prices)
  defp random_tags, do: Enum.take_random(@tags, Enum.random(1..2))
end
