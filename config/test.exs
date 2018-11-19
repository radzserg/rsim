use Mix.Config

config :rsim,
  storage: Rsim.StorageMock,
  repo: Rsim.ImageRepoMock


config :rsim, Rsim.Repo,
  pool: Ecto.Adapters.SQL.Sandbox

config :logger, level: :warn

import_config "test.secret.exs"
