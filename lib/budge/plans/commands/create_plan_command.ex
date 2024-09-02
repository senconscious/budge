defmodule Budge.Plans.CreatePlanCommand do
  @moduledoc false

  alias Budge.PlanSchema

  alias Budge.Plans.PlanRestCalculation

  alias Ecto.Multi
  alias Ecto.Changeset
  alias Budge.Repo

  def execute(attrs) do
    Multi.new()
    |> Multi.insert(:plan, new(attrs))
    |> Multi.update(:plan_with_rest, &update_rest/1)
    |> Repo.transaction()
  end

  defp new(attrs), do: PlanSchema.changeset(%PlanSchema{}, attrs)

  defp update_rest(%{plan: plan}) do
    Changeset.change(plan, %{rest: PlanRestCalculation.call(plan)})
  end
end
