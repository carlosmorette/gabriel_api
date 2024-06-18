defmodule GabrielAPIWeb.CameraController do
  use GabrielAPIWeb, :controller

  alias GabrielAPI.Cameras.CreateOne

  def create(conn, params) do
    case CreateOne.run(params) do
      {:ok, _camera} ->
        send_resp(conn, :created, "")

      {:error, errors} ->
        conn |> put_status(:bad_request) |> json(errors)
    end
  end
end
