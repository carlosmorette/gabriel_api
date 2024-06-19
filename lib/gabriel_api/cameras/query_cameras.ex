defmodule GabrielAPI.Cameras.QueryCameras do
  use Params

  alias GabrielAPI.Repo
  alias GabrielAPI.Cameras.Entities.Camera

  defparams(
    query_params(%{
      customer_id!: :integer,
      filters: %{
        is_enabled: :boolean
      }
    })
  )

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

    params.customer_id
    |> Camera.build_filter_query(params.filters)
    |> Repo.all()
  end
end
