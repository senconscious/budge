defmodule BudgeWeb.PlanComponents do
  use BudgeWeb, :component

  @months ~w(january february march april may june july august september october november december)

  def months do
    @months
  end

  def current_month do
    Enum.at(@months, Date.utc_today().month - 1)
  end

  def current_year do
    Date.utc_today().year
  end

  def index_page(assigns) do
    ~H"""
    <.link navigate={~p"/plans/new"}>Create New Plan</.link>
    <.async_result :let={plans} assign={@plans}>
      <:loading>Loading Plans...</:loading>
      <:failed :let={_failure}>there was an error loading the plans</:failed>
      <.table id="plans" rows={plans} row_click={fn plan -> JS.navigate(~p"/plans/#{plan.id}") end}>
        <:col :let={plan} label="Id"><%= plan.id %></:col>
        <:col :let={plan} label="Year and Month">
          <%= format_year_month(plan.year, plan.month) %>
        </:col>
        <:col :let={plan} label="Rest"><%= plan.rest %></:col>
      </.table>
    </.async_result>
    """
  end

  def new_page(assigns) do
    ~H"""
    <.form for={@form} phx-change="validate" phx-submit="save">
      <div class="box-border p-1 border-2">
        <div class="flex">
          <.input type="number" placeholder="year" value={current_year()} field={@form[:year]} />
          <.input type="select" options={months()} value={current_month()} field={@form[:month]} />
        </div>
        <.incomes form={@form} />
        <.expenses form={@form} />
        <.form_bottom />
      </div>
    </.form>
    """
  end

  def update_page(assigns) do
    ~H"""
    <.form for={@form} phx-change="validate" phx-submit="save">
      <div class="box-border p-1 border-2">
        <div class="flex">
          <.input type="number" placeholder="year" field={@form[:year]} />
          <.input type="select" options={months()} field={@form[:month]} />
        </div>
        <.incomes form={@form} />
        <.expenses form={@form} />
        <.form_bottom />
      </div>
    </.form>
    """
  end

  defp format_year_month(year, month) do
    formatted_month = month |> Atom.to_string() |> String.capitalize()
    "#{formatted_month} #{year}"
  end

  def delete_button(assigns) do
    ~H"""
    <.button
      type="button"
      name={"plan_schema[#{@key}_drop][]"}
      value={@index}
      phx-click={JS.dispatch("change")}
    >
      ❌
    </.button>
    """
  end

  def add_button(assigns) do
    ~H"""
    <div class="flex justify-center">
      <.button
        type="button"
        name={"plan_schema[#{@key}_sort][]"}
        value="new"
        phx-click={JS.dispatch("change")}
      >
        <%= @text %>
      </.button>
    </div>
    """
  end

  def incomes(assigns) do
    ~H"""
    <div class="box-border mt-5 p-1 border-4">
      <p>Incomes</p>
      <.inputs_for :let={income} field={@form[:incomes]}>
        <div class="box-border mt-2 p-1 border-4">
          <input type="hidden" name="plan_schema[incomes_sort][]" value={income.index} />
          <div class="flex">
            <.input type="text" placeholder="name" field={income[:name]} />
            <.delete_button index={income.index} key="incomes" />
          </div>
          <.input type="number" placeholder="value" field={income[:value]} />
        </div>
      </.inputs_for>
      <input type="hidden" name="plan_schema[incomes_drop][]" />

      <.add_button key="incomes" text="Add new income" />
    </div>
    """
  end

  def expenses(assigns) do
    ~H"""
    <div class="box-border mt-5 p-1 border-4">
      <p>Expenses</p>
      <.inputs_for :let={expense} field={@form[:expenses]}>
        <div class="box-border mt-2 p-1 border-4">
          <input type="hidden" name="plan_schema[expenses_sort][]" value={expense.index} />
          <div class="flex">
            <.input type="text" placeholder="name" field={expense[:name]} />
            <.delete_button index={expense.index} key="expenses" />
          </div>
          <.input type="select" options={["flat", "percentage"]} field={expense[:unit]} />
          <.input type="number" placeholder="value" field={expense[:value]} />
        </div>
      </.inputs_for>
      <input type="hidden" name="plan_schema[expenses_drop][]" />

      <.add_button key="expenses" text="Add new expense" />
    </div>
    """
  end

  def form_bottom(assigns) do
    ~H"""
    <div class="mt-2">
      <.button type="submit">Save</.button>
      <.link navigate={~p"/plans"}>Return</.link>
    </div>
    """
  end
end
