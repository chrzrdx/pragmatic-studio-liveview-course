defmodule Liveview.Servers.Server do
  use Ecto.Schema
  import Ecto.Changeset

  @valid_statuses ["up", "down"]

  schema "servers" do
    field :name, :string
    field :size, :integer
    field :status, :string
    field :stack, :string
    field :deploys, :integer
    field :last_commit, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(server, attrs) do
    server
    |> cast(attrs, [:name, :status, :deploys, :size, :stack, :last_commit])
    |> validate_required([:name, :status, :deploys, :size, :stack, :last_commit])
    |> validate_inclusion(:status, @valid_statuses)
    |> validate_length(:name, max: 255)
    |> validate_length(:stack, max: 255)
    |> validate_length(:last_commit, max: 1024)
    |> validate_number(:size, greater_than_or_equal_to: 0)
    |> validate_number(:deploys, greater_than_or_equal_to: 0)
    |> unique_constraint(:name)
  end
end
