defmodule GabrielAPIWeb.CameraJSON do
  def show(%{cameras: cameras}) do
    %{cameras: for(c <- cameras, do: data(c))}
  end

  def data(camera) do
    %{
      id: camera.id,
      ip: camera.ip,
      is_enabled: camera.is_enabled,
      customer_id: camera.customer_id
    }
  end
end
