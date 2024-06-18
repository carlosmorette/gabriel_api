defmodule GabrielAPI.Cameras.IP do
  @moduledoc """
  Modulo responsável por validar e realizar tratamentos em um `IP`. Exemplos de IP's
  válidos:
  - 192.168.0.1
  - 123.123.123.123
  - 255.255.0.111
  """

  @sepator "."
  @slots_amount 4
  @max_ip_number 255
  @min_ip_number 0

  @spec is_valid?(String.t()) :: boolean()
  def is_valid?(ip) when is_binary(ip) do
    splitted = String.split(ip, @sepator)
    correct_slots_amount?(splitted) && valid_number_range(splitted)
  end

  defp correct_slots_amount?(slots), do: length(slots) == @slots_amount

  defp valid_number_range(splitted_ip) do
    Enum.all?(splitted_ip, &in_valid_range?/1)
  end

  defp in_valid_range?(slot) when is_binary(slot) do
    case Integer.parse(slot) do
      {number, ""} -> number <= @max_ip_number and number >= @min_ip_number
      _another_result -> false
    end
  end
end
