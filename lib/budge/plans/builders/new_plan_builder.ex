defmodule Budge.Plans.NewPlanBuilder do
  @moduledoc false

  alias Budge.PlanSchema

  def call(attrs) do
    PlanSchema.changeset(%PlanSchema{}, attrs)
  end
end
