defmodule Budge.Plans.UpdatePlanCommand do
  @moduledoc false

  alias Budge.PlanSchema

  alias Budge.Plans.PlanQuery

  alias Budge.Repo

  def execute(id, attrs) do
    with {:ok, plan} <- fetch_plan(id) do
      update(plan, attrs)
    end
  end

  defp fetch_plan(id) do
    id
    |> PlanQuery.fetch_query()
    |> Repo.fetch_one()
  end

  defp update(plan, attrs) do
    plan
    |> PlanSchema.changeset(attrs)
    |> Repo.update()
  end
end
