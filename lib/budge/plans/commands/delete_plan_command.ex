defmodule Budge.Plans.DeletePlanCommand do
  @moduledoc false

  alias Budge.Plans.PlanQuery

  alias Budge.Repo

  def execute(id) do
    with {:ok, plan} <- PlanQuery.fetch(id) do
      Repo.delete(plan)
    end
  end
end
