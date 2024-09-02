defmodule Budge.Repo.Migrations.CreatePlans do
  use Ecto.Migration

  def change do
    create table(:plans) do
      add :year, :integer, null: false
      add :month, :integer, null: false

      add :rest, :integer

      timestamps()
    end

    create unique_index(:plans, [:year, :month])

    create constraint(:plans, :month_is_valid, check: "month >= 1 AND month <= 12")
    create constraint(:plans, :year_is_supported, check: "year >= 1970 AND year <= 3000")
  end
end
