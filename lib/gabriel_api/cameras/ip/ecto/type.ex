defmodule GabrielAPI.Cameras.IP.Ecto.Type do
  @moduledoc """
  Tipo para validações e banco para a string `IP`
  """

  use Ecto.Type

  alias GabrielAPI.Cameras.IP

  @impl true
  def type, do: :string

  @impl true
  def cast(ip) do
    if IP.is_valid?(ip) do
      {:ok, ip}
    else
      :error
    end
  end

  @impl true
  def load(ip), do: {:ok, ip}

  @impl true
  def dump(ip), do: {:ok, ip}
end
