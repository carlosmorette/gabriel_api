defmodule GabrielAPI.Cameras.QueryCameras do
  @moduledoc """
  Operação responsável por buscar no banco de dados câmeras associadas a um #{Customer}.
  """

  use Params

  alias GabrielAPI.Repo
  alias GabrielAPI.Cameras.Entities.Camera

  @default_limit 5

  defparams(
    query_params(%{
      customer_id!: :integer,
      filters!: %{
        is_enabled: :boolean
      },
      limit: :integer,
      offset: :integer
    })
  )

  @type map_result :: %{cameras: list(Camera.t()), offset: integer}

  @doc """
  Exemplos:

      iex> alias GabrielAPI.Cameras.QueryCameras
      iex> QueryCameras.run(%{customer_id: 1})
      iex> {:ok, %{cameras: [%Camera{}]}}

      iex> QueryCameras.run(%{})
      iex> {:error, %{customer_id: ["can't be blank"]}}

      iex> QueryCameras.run(%{customer_id: 1, filters: %{is_enabled: true}})
      iex> {:ok, %{cameras: [%Camera{}, %Camera{}]}}
  """
  @spec run(map) :: {:ok, map_result} | {:error, map}
  def run(params) do
    case query_params(params) do
      %Ecto.Changeset{valid?: true} = chst ->
        {:ok, do_query(chst)}

      chst ->
        {:error, Ecto.Changeset.traverse_errors(chst, fn {msg, _opts} -> msg end)}
    end
  end

  defp do_query(chst) do
    params = Params.to_map(chst)
    limit = Map.get(params, :limit, @default_limit)
    offset = Map.get(params, :offset, 0)

    cameras =
      params.customer_id
      |> Camera.build_filter_query(params.filters, limit: limit, offset: offset)
      |> Repo.all()

    %{cameras: cameras, offset: offset + length(cameras)}
  end
end
