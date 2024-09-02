defmodule Budge.Repo.Migrations.CreateIncomes do
  use Ecto.Migration

  def change do
    create table(:incomes) do
      add :plan_id, references(:plans, on_delete: :delete_all, on_update: :update_all),
        null: false

      add :name, :text, null: false
      add :value, :integer, null: false

      timestamps()
    end

    create index(:incomes, [:plan_id])

    create constraint(:incomes, :value_is_positive_or_zero, check: "value >= 0")
  end
end
