defmodule Liveview.Boats.Boat do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "boats" do
    field :name, :string
    field :image, :string
    field :price, :string
    field :tags, {:array, :string}, default: []

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(boat, attrs) do
    boat
    |> cast(attrs, [:name, :image, :price, :tags])
    |> validate_required([:name, :image, :price, :tags])
    |> validate_length(:name, min: 1, max: 100)
    |> validate_format(:image, ~r/\Ahttps?:\/\/[\S]+\z/, message: "must be a valid URL")
    |> validate_inclusion(:price, ["$", "$$", "$$$", "$$$$"],
      message: "must be one of the following: [$, $$, $$$, $$$$]"
    )
    |> update_change(:name, &String.trim/1)
  end
end
