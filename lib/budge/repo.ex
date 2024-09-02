defmodule Budge.Repo do
  use Ecto.Repo,
    otp_app: :budge,
    adapter: Ecto.Adapters.Postgres

  def fetch_one(query, opts \\ []) do
    case one(query, opts) do
      nil -> {:error, :not_found}
      entity -> {:ok, entity}
    end
  end
end
