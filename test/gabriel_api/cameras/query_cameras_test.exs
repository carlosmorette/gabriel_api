defmodule GabrielAPI.Cameras.QueryCamerasTest do
  use ExUnit.Case

  import GabrielAPI.Factory

  alias GabrielAPI.Cameras.QueryCameras
  alias GabrielAPI.Cameras.CreateOne

  @cameras_number 10

  setup do
    Ecto.Adapters.SQL.Sandbox.mode(GabrielAPI.Repo, {:shared, self()})
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(GabrielAPI.Repo)

    customer = insert(:customer, %{name: "Ademir"})
    create_cameras(customer)
    {:ok, %{customer: customer}}
  end

  describe "run/1" do
    test "it should return enabled câmeras to specific customer with pagination", %{
      customer: customer
    } do
      assert {:ok, %{cameras: cameras, offset: 5}} =
               QueryCameras.run(%{customer_id: customer.id, filters: %{is_enabled: true}})

      assert length(cameras) == 5

      assert {:ok, %{cameras: more_cameras, offset: 10}} =
               QueryCameras.run(%{
                 customer_id: customer.id,
                 filters: %{is_enabled: true},
                 offset: 5
               })

      assert length(more_cameras) == 5
    end

    test "it should return disabled câmeras", %{
      customer: customer
    } do
      assert {:ok, %{cameras: cameras, offset: 10}} =
               QueryCameras.run(%{
                 limit: 10,
                 customer_id: customer.id,
                 filters: %{is_enabled: false}
               })

      assert length(cameras) == 10
    end
  end

  defp create_cameras(customer) do
    create_enabled_cameras(customer.id)
    create_disabled_cameras(customer.id)
  end

  defp create_enabled_cameras(customer_id) do
    for final_ip_number <- 0..@cameras_number do
      Task.async(fn ->
        CreateOne.run(%{
          ip: "192.168.0.#{final_ip_number}",
          customer_id: customer_id
        })
      end)
    end
    |> Task.await_many(:infinity)
  end

  defp create_disabled_cameras(customer_id) do
    for final_ip_number <- 0..@cameras_number do
      Task.async(fn ->
        CreateOne.run(%{
          ip: "30.70.1.#{final_ip_number}",
          is_enabled: false,
          customer_id: customer_id
        })
      end)
    end
    |> Task.await_many(:infinity)
  end
end
