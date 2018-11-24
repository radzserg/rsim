use Mix.Config

config :rsim,
  storage: Rsim.StorageMock,
  image_repo: Rsim.ImageRepoMock,
  repo: Rsim.Repo

config :rsim, Rsim.Repo,
  pool: Ecto.Adapters.SQL.Sandbox

config :logger, level: :warn

import_config "test.secret.exs"
