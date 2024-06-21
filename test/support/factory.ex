defmodule GabrielAPI.Factory do
  alias GabrielAPI.Cameras.Entities.{Customer, Camera, AlertLog}
  alias GabrielAPI.Repo

  def insert(:customer, params) do
    Customer |> struct(params) |> Repo.insert!()
  end

  def insert(:camera, params) do
    Camera |> struct(params) |> Repo.insert!()
  end

  def insert(:alert_log, params) do
    AlertLog |> struct(params) |> Repo.insert!()
  end
end
