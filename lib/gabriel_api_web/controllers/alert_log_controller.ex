defmodule GabrielAPIWeb.AlertLogController do
  use GabrielAPIWeb, :controller

  alias GabrielAPI.Cameras.CreateAlertLog

  def create(conn, params) do
    case CreateAlertLog.run(params) do
      {:ok, _alert} ->
        send_resp(conn, :created, "")

      {:error, errors} ->
        conn |> put_status(:bad_request) |> json(%{errors: errors})
    end
  end

  def list(conn, params) do

  end
end
