defmodule GabrielAPIWeb.Plugs.Authentication do
  import Plug.Conn

  import Phoenix.Controller

  @api_key_header "x-api-key"
  @unauthorized_error "No access to this resource. Contact development team"

  def init(default), do: default

  def call(conn, _opts) do
    if Application.get_env(:gabriel_api, :environment) != :test do
      case get_req_header(conn, @api_key_header) do
        [] ->
          conn |> json(%{error: @unauthorized_error}) |> halt()

        [key] ->
          if correct_api_key?(key) do
            conn
          else
            conn |> json(%{error: @unauthorized_error}) |> halt()
          end
      end
    else
      conn
    end
  end

  defp correct_api_key?(key), do: Application.get_env(:gabriel_api, :api_key) == key
end
