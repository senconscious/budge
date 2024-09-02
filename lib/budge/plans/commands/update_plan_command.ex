defmodule Budge.Plans.UpdatePlanCommand do
  @moduledoc false

  alias Budge.PlanSchema

  alias Budge.Plans.PlanQuery

  alias Budge.Plans.PlanRestCalculation

  alias Ecto.Multi
  alias Ecto.Changeset
  alias Budge.Repo

  def execute(id, attrs) do
    Multi.new()
    |> Multi.put(:id, id)
    |> Multi.put(:attrs, attrs)
    |> Multi.run(:plan, &update_plan/2)
    |> Multi.update(:plan_with_rest, &update_rest/1)
    |> Repo.transaction()
  end

  defp update_plan(repo, %{id: id, attrs: attrs}) do
    with {:ok, plan} <- fetch_plan(repo, id) do
      update(repo, plan, attrs)
    end
  end

  defp fetch_plan(repo, id) do
    id
    |> PlanQuery.fetch_query()
    |> repo.fetch_one()
  end

  defp update(repo, plan, attrs) do
    plan
    |> PlanSchema.changeset(attrs)
    |> repo.update()
  end

  defp update_rest(%{plan: plan}) do
    Changeset.change(plan, %{rest: PlanRestCalculation.call(plan)})
  end
end
