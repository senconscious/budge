defmodule BudgeWeb.PlanLive do
  use BudgeWeb, :live_view

  import BudgeWeb.PlanComponents

  @default_create_form_params %{
    "expenses_drop" => [""],
    "expenses_sort" => ["new"],
    "incomes_drop" => [""],
    "incomes_sort" => ["new"]
  }

  def render(assigns) do
    ~H"""
    <%= case @live_action do %>
      <% :index -> %>
        <.index_page plans={@plans} />
      <% :new -> %>
        <.new_page form={@form} />
      <% :show -> %>
        <.update_page form={@form} />
    <% end %>
    """
  end

  def mount(_, _, %{assigns: %{live_action: :index}} = socket) do
    socket
    |> load_plans()
    |> wrap_ok()
  end

  def mount(_, _session, %{assigns: %{live_action: :new}} = socket) do
    socket
    |> load_new_form()
    |> wrap_ok()
  end

  def mount(%{"id" => id}, _, %{assigns: %{live_action: :show}} = socket) do
    socket
    |> load_plan(id)
    |> load_change_form()
    |> wrap_ok()
  end

  def handle_event(
        "validate",
        %{"plan_schema" => params},
        %{assigns: %{live_action: :new}} = socket
      ) do
    socket
    |> load_new_form(params)
    |> wrap_noreply()
  end

  def handle_event(
        "validate",
        %{"plan_schema" => params},
        %{assigns: %{live_action: :show}} = socket
      ) do
    socket
    |> load_change_form(params)
    |> wrap_noreply()
  end

  def handle_event(
        "save",
        %{"plan_schema" => params},
        %{assigns: %{live_action: :new}} = socket
      ) do
    socket
    |> create_plan(params)
    |> wrap_noreply()
  end

  def handle_event(
        "save",
        %{"plan_schema" => params},
        %{assigns: %{live_action: :show}} = socket
      ) do
    socket
    |> update_plan(params)
    |> wrap_noreply()
  end

  defp load_plans(socket) do
    connected? = connected?(socket)
    action = socket.assigns.live_action

    assign_async(socket, :plans, fn -> {:ok, %{plans: maybe_load_plans(connected?, action)}} end)
  end

  defp maybe_load_plans(true, :index), do: Budge.Plans.list_plans()
  defp maybe_load_plans(_, _), do: []

  defp load_new_form(socket, params \\ @default_create_form_params) do
    form =
      params
      |> Budge.Plans.new_plan()
      |> to_form(action: :validate)

    assign(socket, :form, form)
  end

  defp load_plan(socket, id) do
    with {parsed_id, ""} <- Integer.parse(id),
         {:ok, plan} <- Budge.Plans.fetch_plan(parsed_id) do
      assign(socket, :plan, plan)
    else
      _ ->
        socket
    end
  end

  defp load_change_form(socket, params \\ %{}) do
    form =
      socket.assigns.plan
      |> Budge.Plans.change_plan(params)
      |> to_form(action: :validate)

    assign(socket, :form, form)
  end

  defp wrap_ok(socket), do: {:ok, socket}
  defp wrap_noreply(socket), do: {:noreply, socket}

  defp create_plan(socket, params) do
    case Budge.Plans.create_plan(params) do
      {:ok, _} -> push_navigate(socket, to: ~p"/plans")
      {:error, _, changeset, _} -> assign(socket, :form, to_form(changeset))
    end
  end

  defp update_plan(%{assigns: %{plan: %{id: plan_id}}} = socket, params) do
    case Budge.Plans.update_plan(plan_id, params) do
      {:ok, _} -> push_navigate(socket, to: ~p"/plans")
      {:error, _, changeset, _} -> assign(socket, :form, to_form(changeset))
    end
  end

  defp update_plan(socket, _), do: push_navigate(socket, to: ~p"/plans")
end
