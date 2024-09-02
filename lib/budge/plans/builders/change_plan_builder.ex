defmodule Budge.Plans.ChangePlanBuilder do
  @moduledoc false

  alias Budge.PlanSchema

  def call(plan, attrs) do
    PlanSchema.changeset(plan, attrs)
  end
end
