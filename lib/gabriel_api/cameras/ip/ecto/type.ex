defmodule GabrielAPI.Cameras.IP.Ecto.Type do
  use Ecto.Type

  alias GabrielAPI.Cameras.IP

  def type, do: :string

  def cast(ip) do
    if IP.is_valid?(ip) do
      {:ok, ip}
    else
      :error
    end
  end

  ## TODO: criar struct
  def load(ip), do: {:ok, ip}

  def dump(ip), do: {:ok, ip}
end
