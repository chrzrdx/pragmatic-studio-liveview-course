defmodule Liveview.Repo.Migrations.CreateBoats do
  use Ecto.Migration

  def change do
    create table(:boats, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :name, :text, null: false, unique: true
      add :image, :text, null: false
      add :price, :text, null: false
      add :tags, {:array, :string}, default: []

      timestamps(type: :utc_datetime)
    end

    create constraint("boats", :name_max_length, check: "length(name) <= 100")
    create constraint("boats", :name_not_empty, check: "length(name) >= 1")
    create constraint("boats", :price_must_be_valid, check: "price IN ('$', '$$', '$$$', '$$$$')")
  end
end
