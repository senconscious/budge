defmodule Budge.PlanSchema do
  @moduledoc false

  use Ecto.Schema

  import Ecto.Changeset

  schema "plans" do
    field :year, :integer
    field :month, :integer

    field :rest, :integer

    has_many :incomes, Budge.IncomeSchema,
      foreign_key: :plan_id,
      on_delete: :delete_all,
      on_replace: :delete

    has_many :expenses, Budge.ExpenseSchema,
      foreign_key: :plan_id,
      on_delete: :delete_all,
      on_replace: :delete

    timestamps()
  end

  def changeset(entity, attrs) do
    fields = __schema__(:fields) -- [:id, :inserted_at, :updated_at]

    entity
    |> cast(attrs, fields)
    |> cast_assoc(:incomes, required: true, sort_param: :incomes_sort, drop_param: :incomes_drop)
    |> cast_assoc(:expenses,
      required: true,
      sort_param: :expenses_sort,
      drop_param: :expenses_drop
    )
    |> validate_required([:year, :month])
    |> validate_number(:month, greater_than_or_equal_to: 1, less_than_or_equal_to: 12)
    |> validate_number(:year, greater_than_or_equal_to: 1_970, less_than_or_equal_to: 3_000)
    |> unique_constraint([:year, :month], error_key: :month)
    |> check_constraint(:month, name: "month_is_valid")
    |> check_constraint(:year, name: "year_is_supported")
  end
end
