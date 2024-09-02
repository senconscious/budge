defmodule Budge.Repo.Migrations.CreateExpenses do
  use Ecto.Migration

  def change do
    create table(:expenses) do
      add :plan_id, references(:plans, on_delete: :delete_all, on_update: :update_all),
        null: false

      add :name, :text, null: false
      add :value, :integer, null: false
      add :unit, :text, null: false

      timestamps()
    end

    create index(:expenses, [:plan_id])

    create constraint(:expenses, :value_is_positive_or_zero, check: "value >= 0")
  end
end
