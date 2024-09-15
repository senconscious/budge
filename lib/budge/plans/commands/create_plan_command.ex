defmodule Budge.Plans.CreatePlanCommand do
  @moduledoc false

  alias Budge.PlanSchema

  alias Budge.Repo

  def execute(attrs) do
    %PlanSchema{}
    |> PlanSchema.changeset(attrs)
    |> Repo.insert()
  end
end
