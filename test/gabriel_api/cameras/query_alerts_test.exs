defmodule GabrielAPI.Cameras.QueryAlertsTest do
  alias GabrielAPI.Cameras.Entities.AlertLog
  alias GabrielAPI.Cameras.CreateAlertLog
  alias GabrielAPI.Cameras.QueryAlerts
  use ExUnit.Case

  import GabrielAPI.Factory

  @today_alerts_number 20
  @past_alerts_number 15

  @total_per_customer @today_alerts_number + @past_alerts_number

  @alerts_date NaiveDateTime.new!(2000, 7, 30, 10, 0, 0)

  setup do
    Ecto.Adapters.SQL.Sandbox.mode(GabrielAPI.Repo, {:shared, self()})
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(GabrielAPI.Repo)

    customer_1 = insert(:customer, %{name: "Ademir"})
    customer_2 = insert(:customer, %{name: "Dark Valdemir"})
    camera_1 = insert(:camera, %{customer_id: customer_1.id, ip: "100.0.0.0"})
    camera_2 = insert(:camera, %{customer_id: customer_2.id, ip: "81.13.2.5"})

    create_alerts(camera_1)
    create_alerts(camera_2)

    {:ok,
     %{
       customer_1: customer_1,
       customer_2: customer_2,
       camera_1: camera_1,
       camera_2: camera_2
     }}
  end

  describe "run/1" do
    test "it should return today's alerts ignoring `customer_id`" do
      assert {:ok, %{alerts: alerts}} = QueryAlerts.run(%{filters: %{}, limit: 100_00})

      ## São 2 customers diferentes e 2 câmeras diferentes, logo 40 alertas
      assert length(alerts) == 40
    end

    test "it should return alerts to specific customer and specific range", %{
      customer_1: customer_1
    } do
      assert {:ok, %{alerts: alerts}} =
               QueryAlerts.run(%{
                 limit: @total_per_customer,
                 filters: %{
                   customer_id: customer_1.id,
                   start_datetime: @alerts_date,
                   end_datetime: NaiveDateTime.utc_now()
                 }
               })

      assert @total_per_customer = length(alerts)
    end

    test "it should return alert from specific date", %{camera_1: camera_1} do
      datetime = NaiveDateTime.new!(2024, 02, 13, 0, 0, 0)
      CreateAlertLog.run(%{camera_id: camera_1.id, occurred_at: datetime})

      assert {:ok, %{alerts: [alert]}} = QueryAlerts.run(%{filters: %{datetime: datetime}})
      %AlertLog{occurred_at: occurred_at} = alert
      assert occurred_at == datetime
    end
  end

  defp create_alerts(camera) do
    for _ <- 1..@today_alerts_number do
      Task.async(fn -> CreateAlertLog.run(%{camera_id: camera.id}) end)
    end
    |> Task.await_many(:infinity)

    for _ <- 1..@past_alerts_number do
      Task.async(fn ->
        CreateAlertLog.run(%{
          camera_id: camera.id,
          occurred_at: @alerts_date
        })
      end)
    end
    |> Task.await_many(:infinity)
  end
end
