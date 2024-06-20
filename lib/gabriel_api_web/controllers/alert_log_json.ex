defmodule GabrielAPIWeb.AlertLogJSON do
  def show(%{alerts: alerts}) do
    %{alerts: for(a <- alerts, do: data(a))}
  end

  def data(alert) do
    %{
      camera_id: alert.camera_id,
      occurred_at: alert.occurred_at
    }
  end
end
