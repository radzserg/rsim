FROM elixir:1.7.2

RUN apt-get update && apt-get -y install inotify-tools
WORKDIR /app

RUN mix local.hex --force && mix local.rebar --force

COPY config/* config/
# *.secret.exs is ignored in .dockerignore
# I would like to keep only one ENV
# docker cp config/dev.secret.exs {container_id}:/app/config/dev.secret.exs
COPY mix.exs mix.lock ./
RUN mix do deps.get, deps.compile, compile
