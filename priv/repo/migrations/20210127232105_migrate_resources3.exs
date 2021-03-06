defmodule AshTest.Repo.Migrations.MigrateResources3 do
  @moduledoc """
  Updates resources based on their most recent snapshots.

  This file was autogenerated with `mix ash_postgres.generate_migrations`
  """

  use Ecto.Migration

  def up do
    create unique_index(:players, [:username], name: "players_unique_username_unique_index")

    alter table(:players) do
      add :field, :text
    end
  end

  def down do
    alter table(:players) do
      remove :field
    end

    drop_if_exists unique_index(:players, [:username],
                     name: "players_unique_username_unique_index"
                   )
  end
end