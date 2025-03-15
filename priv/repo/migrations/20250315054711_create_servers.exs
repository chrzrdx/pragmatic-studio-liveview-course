defmodule Liveview.Repo.Migrations.CreateServers do
  use Ecto.Migration

  def change do
    create table(:servers) do
      add :name, :string, null: false
      add :status, :string, null: false, default: "down"
      add :deploys, :integer, null: false, default: 0
      add :size, :integer, null: false, default: 0
      add :stack, :string, null: false
      add :last_commit, :string, null: false

      timestamps(type: :utc_datetime)
    end

    # Constraints
    create unique_index(:servers, [:name])
    create constraint(:servers, :status_must_be_valid, check: "status IN ('up', 'down')")
  end
end
