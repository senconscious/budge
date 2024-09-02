defmodule Budge.Plans.PlanQuery do
  @moduledoc false

  import Ecto.Query

  alias Budge.PlanSchema

  alias Budge.Repo

  def all do
    PlanSchema
    |> order_by([:year, :month])
    |> preload([:incomes, :expenses])
    |> Repo.all()
  end

  def fetch(id) do
    id
    |> fetch_query()
    |> Repo.fetch_one()
  end

  def fetch_query(id) do
    PlanSchema
    |> where([plan], plan.id == ^id)
    |> preload([:incomes, :expenses])
  end
end
