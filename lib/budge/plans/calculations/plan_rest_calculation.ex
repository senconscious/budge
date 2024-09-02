defmodule Budge.Plans.PlanRestCalculation do
  @moduledoc false

  def call(plan) do
    income = calculate_total_income(plan.incomes)

    income - calculate_expenses(plan.expenses, income)
  end

  defp calculate_total_income(incomes) do
    incomes
    |> Stream.map(fn %{value: value} -> value end)
    |> Enum.sum()
  end

  defp calculate_expenses(expenses, total_income) do
    expenses
    |> Stream.map(&calculate_expense(&1, total_income))
    |> Enum.sum()
  end

  defp calculate_expense(%{unit: :flat} = expense, _income), do: expense.value

  defp calculate_expense(%{unit: :percentage} = expense, income) do
    ceil(income * expense.value / 100)
  end
end
