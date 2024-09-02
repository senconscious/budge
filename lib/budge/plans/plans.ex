defmodule Budge.Plans do
  @moduledoc false

  alias Budge.Plans.CreatePlanCommand
  alias Budge.Plans.UpdatePlanCommand
  alias Budge.Plans.DeletePlanCommand

  alias Budge.Plans.NewPlanBuilder
  alias Budge.Plans.ChangePlanBuilder

  alias Budge.Plans.PlanQuery

  defdelegate new_plan(attrs), to: NewPlanBuilder, as: :call
  defdelegate change_plan(plan, attrs), to: ChangePlanBuilder, as: :call
  defdelegate create_plan(attrs), to: CreatePlanCommand, as: :execute
  defdelegate list_plans, to: PlanQuery, as: :all
  defdelegate fetch_plan(id), to: PlanQuery, as: :fetch
  defdelegate update_plan(id, attrs), to: UpdatePlanCommand, as: :execute
  defdelegate delete_plan(id), to: DeletePlanCommand, as: :execute
end
