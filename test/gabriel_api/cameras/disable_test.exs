defmodule GabrielAPI.Cameras.DisableTest do
  use ExUnit.Case

  alias GabrielAPI.Cameras.Disable

  setup do
    Ecto.Adapters.SQL.Sandbox.mode(GabrielAPI.Repo, {:shared, self()})
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(GabrielAPI.Repo)

    customer = insert(:customer, %{name: "Pablo Escovação"})
    camera = insert(:camera, %{customer_id: customer.id, ip: "127.0.0.1", is_enabled: true})
    {:ok, %{camera: camera}}
  end

  describe "run/1" do
    test "it should disable the camera", %{camera: camera} do
      assert camera.is_enabled
      assert {:ok, %Disable{is_enabled: false}} = Disable.run(%{camera_id: camera_id})
    end

    test "it should return an error when camera not found" do
      assert {:error, :camera_not_found} = Disable.run(%{camera_id: 9_999_999})
    end

    test "it should return an error when `camera_id` was not passed" do
      assert {:error, :required_camera_id} = Disable.run(%{})
    end
  end
end
