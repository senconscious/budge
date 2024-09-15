defmodule Budge.Plans.PlanTemplateQuery do
  @moduledoc false

  alias Budge.PlanSchema

  alias Budge.Repo

  def fetch!(id) do
    id
    |> fetch_plan!()
    |> to_template()
  end

  defp fetch_plan!(id) do
    PlanSchema
    |> Repo.get!(id)
    |> Repo.preload([:incomes, :expenses])
  end

  defp to_template(%PlanSchema{} = plan) do
    plan
    |> Map.from_struct()
    |> Map.update!(:expenses, &to_template/1)
    |> Map.update!(:incomes, &to_template/1)
  end

  defp to_template(list) when is_list(list) do
    Enum.map(list, &to_template/1)
  end

  defp to_template(struct) when is_struct(struct) do
    Map.from_struct(struct)
  end
end
