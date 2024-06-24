defmodule GabrielAPIWeb.CameraControllerTest do
  use GabrielAPIWeb.ConnCase, async: true
  import GabrielAPI.Factory
  alias GabrielAPI.Cameras.Entities.Camera
  alias GabrielAPI.Cameras.CreateOne

  setup do
    Ecto.Adapters.SQL.Sandbox.mode(GabrielAPI.Repo, {:shared, self()})
    Ecto.Adapters.SQL.Sandbox.checkout(GabrielAPI.Repo)

    customer = insert(:customer, %{name: "Pablo Escovação"})
    {:ok, %{customer: customer}}
  end

  describe "POST /api/v1/camera" do
    test "it should require `ip` and `customer_id` field", %{conn: conn} do
      response =
        conn
        |> put_req_header("content-type", "application/json")
        |> post("/api/v1/camera")
        |> json_response(:bad_request)

      assert %{
               "errors" => %{"customer_id" => ["can't be blank"], "ip" => ["can't be blank"]}
             } = response
    end

    test "it should return error when IP is already used", %{conn: conn, customer: customer} do
      ip = "192.168.0.1"
      CreateOne.run(%{customer_id: customer.id, ip: ip})

      body = %{ip: ip, customer_id: customer.id}

      response =
        conn
        |> put_req_header("content-type", "application/json")
        |> post("/api/v1/camera", body)
        |> json_response(:bad_request)

      assert %{"errors" => %{"ip" => ["has already been taken"]}} = response
    end

    test "it should create a camera successfully", %{conn: conn, customer: customer} do
      ip = "100.200.100.0"
      body = %{ip: ip, customer_id: customer.id}

      assert conn
             |> put_req_header("content-type", "application/json")
             |> post("/api/v1/camera", body)
             |> response(:created)

      assert %Camera{is_enabled: true, customer_id: customer_id} =
               GabrielAPI.Repo.get_by(Camera, ip: ip)

      assert customer_id == customer.id
    end
  end

  describe "PATCH /api/v1/camera" do
    test "it should return an error with `required_camera_id`", %{conn: conn} do
      assert %{"error" => "required_camera_id"} =
               conn |> patch("/api/v1/camera") |> json_response(:bad_request)
    end

    test "it should return an error with `camera_not_found`", %{conn: conn} do
      assert %{"error" => "camera_not_found"} =
               conn |> patch("/api/v1/camera", %{camera_id: 9999}) |> json_response(:bad_request)
    end

    test "it should disable camera successfully", %{conn: conn, customer: customer} do
      {:ok, camera} = CreateOne.run(%{customer_id: customer.id, ip: "0.0.0.1"})

      assert conn |> patch("/api/v1/camera", %{camera_id: camera.id}) |> response(:no_content)
    end
  end

  describe "GET /api/v1/camera" do
    setup %{customer: customer} do
      CreateOne.run(%{customer_id: customer.id, ip: "200.100.0.1"})
      CreateOne.run(%{customer_id: customer.id, ip: "100.0.1.200", is_enabled: false})
      :ok
    end

    test "it should return require `customer_id`", %{conn: conn} do
      assert %{"error" => %{"customer_id" => ["can't be blank"]}} =
               conn |> get("/api/v1/camera") |> json_response(:bad_request)
    end

    test "it should return customer cameras, enable and disable", %{
      conn: conn,
      customer: customer
    } do
      assert %{"cameras" => cameras, "offset" => 2} =
               conn
               |> get("/api/v1/camera", customer_id: customer.id)
               |> json_response(:ok)

      assert length(cameras) == 2
    end

    test "it should return just enabled cameras", %{conn: conn, customer: customer} do
      assert %{"cameras" => cameras, "offset" => 1} =
               conn
               |> get("/api/v1/camera", customer_id: customer.id, is_enabled: true)
               |> json_response(:ok)

      assert length(cameras) == 1
    end
  end
end
