defmodule GabrielAPIWeb.AlertLogControllerTest do
  use GabrielAPIWeb.ConnCase, async: true

  import GabrielAPI.Factory
  alias GabrielAPI.Cameras.Entities.AlertLog

  setup do
    Ecto.Adapters.SQL.Sandbox.mode(GabrielAPI.Repo, {:shared, self()})
    Ecto.Adapters.SQL.Sandbox.checkout(GabrielAPI.Repo)

    customer = insert(:customer, %{name: "Pablo Escovação"})
    camera = insert(:camera, %{customer_id: customer.id, ip: "99.200.0.32"})
    {:ok, %{customer: customer, camera: camera}}
  end

  describe "POST /api/v1/alert_log" do
    test "it should return error with required `camera_id`", %{conn: conn} do
      assert %{"errors" => %{"camera_id" => ["can't be blank"]}} =
               conn
               |> put_req_header("content-type", "application/json")
               |> post("/api/v1/alert_log")
               |> json_response(:bad_request)
    end

    test "it should create an alert occurred now", %{conn: conn, camera: camera} do
      now = NaiveDateTime.utc_now()

      assert conn
             |> put_req_header("content-type", "application/json")
             |> post("/api/v1/alert_log", %{camera_id: camera.id})
             |> response(:created)

      assert [%AlertLog{occurred_at: occurred_at}] = GabrielAPI.Repo.all(AlertLog)
      assert occurred_at.year == now.year
      assert occurred_at.month == now.month
      assert occurred_at.day == now.day
      assert occurred_at.hour == now.hour
    end

    test "it should create an alert occurred for specific date", %{conn: conn, camera: camera} do
      specific_date = NaiveDateTime.new!(2020, 12, 13, 13, 15, 0)

      assert conn
             |> put_req_header("content-type", "application/json")
             |> post("/api/v1/alert_log", %{camera_id: camera.id, occurred_at: specific_date})
             |> response(:created)

      assert [%AlertLog{occurred_at: occurred_at}] = GabrielAPI.Repo.all(AlertLog)
      assert occurred_at == specific_date
    end
  end
end
