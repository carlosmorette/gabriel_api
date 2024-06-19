defmodule GabrielAPIWeb.CameraController do
  use GabrielAPIWeb, :controller

  alias GabrielAPI.Cameras.{CreateOne, Disable, Query}

  @default_error "unexpected_error"

  def create(conn, params) do
    case CreateOne.run(params) do
      {:ok, _camera} ->
        send_resp(conn, :created, "")

      {:error, errors} ->
        IO.inspect(errors)
        conn |> put_status(:bad_request) |> json(%{error: errors})
    end
  end

  def disable(conn, params) do
    case Disable.run(params) do
      {:ok, _result} -> send_resp(conn, :no_content, "")
      {:error, _error} -> conn |> put_status(:bad_request) |> json(%{error: @default_error})
    end
  end

  def show(conn, params) do
    case QueryCameras.run(params) do
      {:ok, cameras} ->
        conn |> put_status(:ok) |> json(%{cameras: cameras})

      {:error, error} ->
        conn |> put_status(:bad_request) |> json(%{error: @default_error})
    end
  end
end
