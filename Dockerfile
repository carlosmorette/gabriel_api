FROM elixir:1.16-otp-26

WORKDIR /app

COPY assets assets
COPY mix.exs mix.lock ./
COPY config config
COPY lib lib
COPY scripts scripts
COPY priv priv

RUN mix do deps.get, deps.compile, compile

EXPOSE 4000

CMD ["scripts/entrypoint.sh"]
