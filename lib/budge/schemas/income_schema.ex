defmodule Budge.IncomeSchema do
  @moduledoc false

  use Ecto.Schema

  import Ecto.Changeset

  schema "incomes" do
    field :name, :string
    field :value, :integer

    belongs_to :plan, Budge.PlanSchema

    timestamps()
  end

  def changeset(entity, attrs) do
    fields = __schema__(:fields) -- [:id, :inserted_at, :updated_at, :plan_id]

    entity
    |> cast(attrs, fields)
    |> validate_required(fields)
    |> validate_length(:name, max: 256)
    |> foreign_key_constraint(:plan_id)
    |> check_constraint(:value, name: "value_is_positive_or_zero")
  end
end
