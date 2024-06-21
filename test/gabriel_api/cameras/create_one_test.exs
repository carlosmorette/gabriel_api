defmodule GabrielAPI.Cameras.CreateOneTest do
  use ExUnit.Case, async: true
  import GabrielAPI.Factory

  alias GabrielAPI.Cameras.CreateOne
  alias GabrielAPI.Cameras.Entities.Camera

  setup do
    Ecto.Adapters.SQL.Sandbox.mode(GabrielAPI.Repo, {:shared, self()})
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(GabrielAPI.Repo)
    customer = insert(:customer, %{name: "Adevaldo Oliveira"})
    {:ok, %{customer: customer}}
  end

  describe "run/1" do
    test "it should create a camera", %{customer: customer} do
      assert {:ok,
              %Camera{
                is_enabled: true,
                customer_id: customer_id
              }} =
               CreateOne.run(%{
                 customer_id: customer.id,
                 ip: "192.168.0.1"
               })

      assert customer_id == customer.id

      assert {:ok, %Camera{is_enabled: false}} =
               CreateOne.run(%{
                 customer_id: customer.id,
                 is_enabled: false,
                 ip: "255.255.255.0"
               })
    end

    test "it should return error when already exists camera with IP", %{customer: customer} do
      ip = "168.0.200.7"

      {:ok, %Camera{is_enabled: false}} =
        CreateOne.run(%{
          customer_id: customer.id,
          is_enabled: false,
          ip: ip
        })

      assert {:error, %{ip: ["has already been taken"]}} =
               CreateOne.run(%{ip: ip, customer_id: customer.id})
    end
  end
end
