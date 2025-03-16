defmodule Liveview.Repo.Migrations.CreateDonations do
  use Ecto.Migration

  def change do
    create table(:donations) do
      add :name, :string, null: false
      add :emoji, :string, null: false
      add :quantity, :integer, null: false, default: 0
      add :days_until_expires, :integer, null: false, default: 0

      timestamps(type: :utc_datetime)
    end
  end
end
