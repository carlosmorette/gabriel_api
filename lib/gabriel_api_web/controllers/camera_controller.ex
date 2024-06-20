defmodule GabrielAPIWeb.CameraController do
  use GabrielAPIWeb, :controller

  alias GabrielAPI.Cameras.{CreateOne, Disable, QueryCameras}

  @default_error "unexpected_error"

  def create(conn, params) do
    case CreateOne.run(params) do
      {:ok, _camera} ->
        send_resp(conn, :created, "")

      {:error, errors} ->
        conn |> put_status(:bad_request) |> json(%{errors: errors})
    end
  end

  def disable(conn, params) do
    case Disable.run(%{camera_id: params["camera_id"]}) do
      {:ok, _result} -> send_resp(conn, :no_content, "")
      {:error, error} -> conn |> put_status(:bad_request) |> json(%{errors: error})
    end
  end

  def list(conn, query_params) do
    params = %{customer_id: query_params["customer_id"], filters: query_params}
    case QueryCameras.run(params) do
      {:ok, cameras} ->
        render(conn, :show, cameras: cameras)

      {:error, errors} ->
        conn |> put_status(:bad_request) |> json(%{error: errors})
    end
  end
end
