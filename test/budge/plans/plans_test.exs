defmodule Budge.PlansTest do
  use Budge.DataCase, async: true

  @subject Budge.Plans

  @valid_plan_attrs %{
    year: 2024,
    month: 9,
    expenses: [
      %{unit: :flat, value: 100, name: "Internet"},
      %{unit: :percentage, value: 1, name: "Tax"}
    ],
    incomes: [%{name: "Total", value: 7_000}]
  }

  describe "create_plan/1" do
    test "properly calculates rest" do
      assert {:ok, %{plan_with_rest: plan}} =
               @subject.create_plan(@valid_plan_attrs)

      assert plan.rest == 6830
    end
  end

  describe "list_plans/0" do
    test "returns ordered plans by date asc" do
      september_plan = insert(:plan, year: 2024, month: 9)
      next_year_january_plan = insert(:plan, year: 2025, month: 1)
      august_plan = insert(:plan, year: 2024, month: 8)

      assert @subject.list_plans() == [august_plan, september_plan, next_year_january_plan]
    end
  end

  describe "update_plan/2" do
    test "properly recalculates rest" do
      %{expenses: [expense]} = plan = insert(:plan)

      attrs = %{expenses: [Map.from_struct(expense), %{unit: :percentage, value: 1, name: "Tax"}]}

      assert {:ok, %{plan_with_rest: plan}} = @subject.update_plan(plan.id, attrs)

      assert plan.rest == 6830
    end
  end
end
