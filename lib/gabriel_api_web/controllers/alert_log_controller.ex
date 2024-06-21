defmodule GabrielAPIWeb.AlertLogController do
  use GabrielAPIWeb, :controller

  alias GabrielAPI.Cameras.{CreateAlertLog, QueryAlerts}

  def create(conn, body_params) do
    case CreateAlertLog.run(body_params) do
      {:ok, _alert} ->
        send_resp(conn, :created, "")

      {:error, errors} ->
        conn |> put_status(:bad_request) |> json(%{errors: errors})
    end
  end

  def list(conn, query_params) do
    params = %{
      filters: query_params,
      limit: query_params["limit"],
      offset: query_params["offset"]
    }

    case QueryAlerts.run(params) do
      {:ok, alerts} ->
        render(conn, :show, alerts: alerts)

      {:error, errors} ->
        conn |> put_status(:bad_request) |> json(%{errors: errors})
    end
  end
end
