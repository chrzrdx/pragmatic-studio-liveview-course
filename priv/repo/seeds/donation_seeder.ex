defmodule Liveview.Repo.Seeds.DonationSeeder do
  alias Liveview.Donations.Donation
  alias Liveview.Repo

  def run do
    Repo.delete_all(Donation)

    food_items = [
      {"Apples", "🍎"}, {"Bananas", "🍌"}, {"Bread", "🍞"}, {"Carrots", "🥕"},
      {"Corn", "🌽"}, {"Cucumber", "🥒"}, {"Eggs", "🥚"}, {"Grapes", "🍇"},
      {"Lettuce", "🥬"}, {"Milk", "🥛"}, {"Onions", "🧅"}, {"Oranges", "🍊"},
      {"Peaches", "🍑"}, {"Pears", "🍐"}, {"Peppers", "🫑"}, {"Potatoes", "🥔"},
      {"Rice", "🍚"}, {"Tomatoes", "🍅"}, {"Watermelon", "🍉"}, {"Cheese", "🧀"},
      {"Meat", "🥩"}, {"Chicken", "🍗"}, {"Fish", "🐟"}, {"Pasta", "🍝"},
      {"Soup", "🥣"}, {"Cereal", "🥣"}, {"Peanut Butter", "🥜"}, {"Beans", "🫘"},
      {"Broccoli", "🥦"}, {"Garlic", "🧄"}, {"Mushrooms", "🍄"}, {"Nuts", "🥜"},
      {"Avocado", "🥑"}, {"Butter", "🧈"}, {"Pancake Mix", "🥞"}, {"Lemon", "🍋"},
      {"Honey", "🍯"}, {"Coconut", "🥥"}, {"Pineapple", "🍍"}, {"Mango", "🥭"},
      {"Yogurt", "🧃"}, {"Juice", "🧃"}, {"Canned Beans", "🥫"}, {"Canned Soup", "🥫"},
      {"Canned Fruit", "🥫"}, {"Canned Vegetables", "🥫"}, {"Canned Fish", "🥫"},
      {"Frozen Meals", "🧊"}, {"Ice Cream", "🍨"}, {"Baby Food", "🍼"}
    ]

    now = DateTime.utc_now(:second)

    donations =
      1..(Enum.random(150..200))
      |> Enum.map(fn _ ->
        {name, emoji} = Enum.random(food_items)
        %{
          name: name,
          emoji: emoji,
          quantity: Enum.random(1..25),
          days_until_expires: Enum.random(0..45),
          inserted_at: now,
          updated_at: now
        }
      end)

    Repo.insert_all(Donation, donations)

    IO.puts("Seeded #{length(donations)} donations")
  end
end
