defmodule GabrielAPI.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      GabrielAPIWeb.Telemetry,
      # Start the Ecto repository
      GabrielAPI.Repo,
      # Start the PubSub system
      {Phoenix.PubSub, name: GabrielAPI.PubSub},
      # Start Finch
      {Finch, name: GabrielAPI.Finch},
      # Start the Endpoint (http/https)
      GabrielAPIWeb.Endpoint
      # Start a worker by calling: GabrielAPI.Worker.start_link(arg)
      # {GabrielAPI.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: GabrielAPI.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    GabrielAPIWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
