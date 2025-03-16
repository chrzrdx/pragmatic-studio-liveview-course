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

Code.require_file("seeds/utils.ex", __DIR__)
Code.require_file("seeds/boat_seeder.ex", __DIR__)
Code.require_file("seeds/server_seeder.ex", __DIR__)

alias Liveview.Repo.Seeds.{BoatSeeder, ServerSeeder}

# Run all seeders
BoatSeeder.run()
ServerSeeder.run()
