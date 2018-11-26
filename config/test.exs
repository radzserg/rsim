use Mix.Config

config :rsim,
  ecto_repos: [Rsim.Repo]

config :rsim, Rsim.Repo,
  # adapter: Ecto.Adapters.Postgres,  as soon as migrate to ecto_sql: 3
  username: "rsim",
  password: "rsimpassword",
  database: "rsim",
  hostname: "rsim_db",
  pool_size: 10,
  pool: Ecto.Adapters.SQL.Sandbox

config :rsim,
  storage: Rsim.StorageMock,
  image_repo: Rsim.ImageRepoMock,
  repo: Rsim.Repo


config :logger, level: :warn

import_config "test.secret.exs"
