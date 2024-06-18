defmodule GabrielAPI.Repo do
  use Ecto.Repo,
    otp_app: :gabriel_api,
    adapter: Ecto.Adapters.Postgres
end
