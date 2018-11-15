defmodule Rsim.Application do
  use Application

  def start(_type, _args) do
    import Supervisor.Spec

    children = [
      supervisor(Rsim.Repo, []),
    ]

    opts = [strategy: :one_for_one, name: Rsim.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
