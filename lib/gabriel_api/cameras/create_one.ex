defmodule GabrielAPI.Cameras.CreateOne do
  @moduledoc """
  Operação responsável por criar um #{Camera} dentro do sistema. Uma câmera obrigatoriamente
  precisa estar obrigatoriamente associada a um #{Customer}.
  """

  alias GabrielAPI.Repo
  alias GabrielAPI.Cameras.IP.Ecto.Type, as: IPType
  alias GabrielAPI.Cameras.Entities.Camera

  @type params :: %{
          optional(:ip) => IPType,
          optional(:is_enabled) => boolean,
          required(:customer_id) => integer,
          optional(:name) => String.t()
        }

  @doc """
  Exemplos:
      iex> alias GabrielAPI.Cameras.CreateOne
      iex> CreateOne.run(%{ip: "192.564.123.0", is_enabled: true, customer_id: 1, name: "Rua 7"})
      {:ok, %Camera{}}

      iex> CreateOne.run(%{ip: "192.999.123.0", is_enabled: true, customer_id: 1, name: "Rua 7"})
      iex> {:error, %{ip: ["is invalid"]}}
  """
  @spec run(params) :: {:ok, Camera.t()} | {:error, map}
  def run(params) do
    with %Ecto.Changeset{valid?: true} = chst <- Camera.create_changeset(params),
         {:ok, camera} <- Repo.insert(chst) do
      {:ok, camera}
    else
      {:error, %Ecto.Changeset{} = chst} -> {:error, format_errors(chst)}
      %Ecto.Changeset{} = chst -> {:error, format_errors(chst)}
    end
  end

  defp format_errors(%Ecto.Changeset{} = chst) do
    Ecto.Changeset.traverse_errors(chst, fn {msg, _opt} -> msg end)
  end
end
