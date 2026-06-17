# Stage 1: Build
FROM hexpm/elixir:1.20.1-erlang-29.0.1-debian-bookworm-20250407 AS build

# Install build dependencies
RUN apt-get update -y && apt-get install -y build-essential git \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Install hex and rebar
RUN mix local.hex --force && mix local.rebar --force

ENV MIX_ENV=prod

# Fetch and compile dependencies
COPY mix.exs mix.lock ./
RUN mix deps.get --only $MIX_ENV
RUN mkdir config

# Copy compile-time config files
COPY config/config.exs config/${MIX_ENV}.exs config/
RUN mix deps.compile

# Copy application source
COPY priv priv
COPY lib lib

# Compile the application
RUN mix compile

# Copy runtime config (evaluated at runtime, not compile time)
COPY config/runtime.exs config/

# Build the release
RUN mix release

# Stage 2: Runtime
FROM debian:bookworm-20250407-slim AS app

RUN apt-get update -y && \
    apt-get install -y libstdc++6 openssl libncurses5 locales ca-certificates \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Set locale
RUN sed -i '/en_US.UTF-8/s/^# //g' /etc/locale.gen && locale-gen
ENV LANG=en_US.UTF-8 LANGUAGE=en_US:en LC_ALL=en_US.UTF-8

WORKDIR /app
RUN chown nobody /app

# Copy the release from the build stage
COPY --from=build --chown=nobody:root /app/_build/prod/rel/elixir_backend ./

USER nobody

ENV PHX_SERVER=true
EXPOSE 4000

CMD ["bin/elixir_backend", "start"]
