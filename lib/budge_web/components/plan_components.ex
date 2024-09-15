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
        <:col :let={plan}><.plan_actions plan_id={plan.id} /></:col>
      </.table>
    </.async_result>
    """
  end

  def plan_actions(assigns) do
    ~H"""
    <div class="flex gap-2 items-center justify-end">
      <.import_plan_button plan_id={@plan_id} />
      <.tooltip postfix_id={"import-#{@plan_id}"} text="Use as template" />
      <.delete_plan_button plan_id={@plan_id} />
      <.tooltip postfix_id={"delete-#{@plan_id}"} text="Delete" />
    </div>
    """
  end

  def import_plan_button(assigns) do
    ~H"""
    <button
      data-tooltip-target={"delete-tooltip-#{@plan_id}"}
      data-tooltip-placement="top"
      type="button"
      class="w-12 h-12"
      value={@plan_id}
      phx-click="new"
    >
      🗒️
    </button>
    """
  end

  def delete_plan_button(assigns) do
    ~H"""
    <button
      data-tooltip-target={"delete-tooltip-#{@plan_id}"}
      data-tooltip-placement="top"
      type="button"
      class="w-12 h-12"
      value={@plan_id}
      phx-click="delete"
    >
      ❌
    </button>
    """
  end

  def tooltip(assigns) do
    ~H"""
    <div
      id={"tooltip-#{@postfix_id}"}
      role="tooltip"
      class="absolute z-10 invisible inline-block px-3 py-2 text-sm font-medium text-white bg-gray-900 rounded-lg shadow-sm opacity-0 tooltip dark:bg-gray-700"
    >
      <%= @text %>
      <div class="tooltip-arrow" data-popper-arrow></div>
    </div>
    """
  end

  def new_page(assigns) do
    ~H"""
    <.form for={@form} phx-change="validate" phx-submit="save">
      <div class="flex flex-col justify-between box-border p-1 border-2">
        <div class="flex flex-row justify-between">
          <div class="flex">
            <.input type="select" options={months()} value={current_month()} field={@form[:month]} />
            <.input type="number" placeholder="year" value={current_year()} field={@form[:year]} />
          </div>
          <.input type="number" placeholder="Current rest" disabled={true} field={@form[:rest]} />
        </div>
        <div class="box-border border-t-4 mt-2"></div>
        <.incomes form={@form} />
        <div class="box-border border-t-4 mt-2"></div>
        <.expenses form={@form} />
        <div class="box-border border-t-4 mt-2"></div>
        <.form_bottom />
      </div>
    </.form>
    """
  end

  def update_page(assigns) do
    ~H"""
    <.form for={@form} phx-change="validate" phx-submit="save">
      <div class="flex flex-col justify-between box-border border-2">
        <div class="flex flex-row justify-between">
          <div class="flex">
            <.input type="select" options={months()} field={@form[:month]} />
            <.input type="number" placeholder="year" field={@form[:year]} />
          </div>
          <.input type="number" placeholder="Current rest" disabled={true} field={@form[:rest]} />
        </div>
        <div class="box-border border-t-4 mt-2"></div>
        <.incomes form={@form} />
        <div class="box-border border-t-4 mt-2"></div>
        <.expenses form={@form} />
        <div class="box-border border-t-4 mt-2"></div>
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
    <button
      type="button"
      name={"plan_schema[#{@key}_drop][]"}
      value={@index}
      phx-click={JS.dispatch("change")}
      class="w-10 h-10 mt-2"
    >
      ❌
    </button>
    """
  end

  def add_button(assigns) do
    ~H"""
    <div class="flex justify-center">
      <.button
        type="button"
        name={"plan_schema[#{@key}_sort][]"}
        value="new"
        class="p-0"
        phx-click={JS.dispatch("change")}
      >
        <%= @text %>
      </.button>
    </div>
    """
  end

  def incomes(assigns) do
    ~H"""
    <div class="flex flex-col justify-between gap-3 mt-5">
      <p>Incomes</p>
      <div>
        <.inputs_for :let={income} field={@form[:incomes]}>
          <div class="flex flex-col">
            <input type="hidden" name="plan_schema[incomes_sort][]" value={income.index} />
            <div class="flex">
              <div class="flex justify-between">
                <.input type="text" placeholder="name" field={income[:name]} />
                <.input type="number" placeholder="value" field={income[:value]} />
              </div>
              <.delete_button index={income.index} key="incomes" />
            </div>
            <div class="box-border border-t-4 mt-2"></div>
          </div>
        </.inputs_for>
      </div>
      <input type="hidden" name="plan_schema[incomes_drop][]" />

      <.add_button key="incomes" text="Add new income" />
    </div>
    """
  end

  def expenses(assigns) do
    ~H"""
    <div class="flex flex-col justify-between gap-3 mt-5">
      <p>Expenses</p>
      <div class="flex flex-col justify-between gap-3">
        <.inputs_for :let={expense} field={@form[:expenses]}>
          <div class="flex flex-col justify-between">
            <input type="hidden" name="plan_schema[expenses_sort][]" value={expense.index} />
            <div class="flex">
              <.input type="text" placeholder="name" field={expense[:name]} />
              <.delete_button index={expense.index} key="expenses" />
            </div>
            <div class="flex">
              <.input type="select" options={["flat", "percentage"]} field={expense[:unit]} />
              <.input type="number" placeholder="value" field={expense[:value]} />
            </div>
          </div>
          <div class="box-border border-t-4 mt-2"></div>
        </.inputs_for>
      </div>
      <input type="hidden" name="plan_schema[expenses_drop][]" />

      <.add_button key="expenses" text="Add new expense" />
    </div>
    """
  end

  def return_button(assigns) do
    ~H"""
    <button
      type="button"
      class={[
        "phx-submit-loading:opacity-75 rounded-lg bg-red-900 hover:bg-red-700 py-2 px-3",
        "text-sm font-semibold leading-6 text-white active:text-white/80"
      ]}
      phx-click={JS.navigate(~p"/plans")}
    >
      Return
    </button>
    """
  end

  def form_bottom(assigns) do
    ~H"""
    <div class="flex justify-around mt-2">
      <.button type="submit">Save</.button>
      <.return_button />
    </div>
    """
  end
end
