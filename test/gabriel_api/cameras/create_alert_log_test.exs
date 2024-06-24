defmodule GabrielAPI.Cameras.CreateAlertLogTest do
  use ExUnit.Case, async: true
  import GabrielAPI.Factory
  alias GabrielAPI.Cameras.Entities.AlertLog
  alias GabrielAPI.Cameras.CreateAlertLog

  setup do
    Ecto.Adapters.SQL.Sandbox.mode(GabrielAPI.Repo, {:shared, self()})
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(GabrielAPI.Repo)

    customer = insert(:customer, %{name: "Ademir"})
    camera = insert(:camera, %{customer_id: customer.id, ip: "100.100.2.2"})
    {:ok, %{camera: camera}}
  end

  describe "run/1" do
    test "it should create an alert log that occurred on a specific date", %{camera: camera} do
      assert {:ok, %AlertLog{occurred_at: ~N[2024-01-01 00:00:00], camera_id: camera_id}} =
               CreateAlertLog.run(%{camera_id: camera.id, occurred_at: ~N[2024-01-01 00:00:00]})

      assert camera_id == camera.id
    end

    test "it should create an alert that occurred now (UTC)", %{camera: camera} do
      assert {:ok, %AlertLog{occurred_at: occurred_at, camera_id: camera_id}} =
               CreateAlertLog.run(%{camera_id: camera.id})

      utc_now = NaiveDateTime.utc_now()
      assert camera_id == camera.id
      assert occurred_at.hour == utc_now.hour
    end
  end
end
