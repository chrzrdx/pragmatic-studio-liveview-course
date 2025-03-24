defmodule Liveview.Volunteers.Volunteer do
  use Ecto.Schema
  import Ecto.Changeset

  @phone_regex ~r/^\(?[0-9]{3}\)?[-.\s]?[0-9]{3}[-.\s]?[0-9]{4}$/

  schema "volunteers" do
    field :name, :string
    field :phone, :string
    field :checked_out, :boolean, default: false

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(volunteer, attrs) do
    volunteer
    |> cast(attrs, [:name, :phone, :checked_out])
    |> validate_required([:name, :phone, :checked_out])
    |> validate_length(:name, min: 2, max: 100)
    |> validate_format(:phone, @phone_regex)
  end
end
