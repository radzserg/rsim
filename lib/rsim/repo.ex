defmodule Rsim.Repo do
  use Ecto.Repo,
    otp_app: :rsim,
    adapter: Ecto.Adapters.Postgres

  def init(_, opts) do
    {:ok, opts}
  end
end
