export $(xargs < "dev.env")

docker-compose up -d postgres

iex -S mix phx.server