defmodule Budge.Factory do
  use ExMachina.Ecto, repo: Budge.Repo

  def income_factory do
    %Budge.IncomeSchema{
      name: "Total",
      value: 7_000
    }
  end

  def expense_factory do
    %Budge.ExpenseSchema{
      name: "Internet",
      unit: :flat,
      value: 100
    }
  end

  def plan_factory do
    %Budge.PlanSchema{
      year: 2024,
      month: 9,
      rest: 6_900,
      incomes: [build(:income)],
      expenses: [build(:expense)]
    }
  end
end
