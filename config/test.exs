use Mix.Config

config :rsim,
  storage: Rsim.StorageMock,
  repo: Rsim.ImageRepoMock

import_config "test.secret.exs"