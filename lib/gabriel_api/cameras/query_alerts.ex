defmodule GabrielAPI.Cameras.QueryAlerts do
  use Params

  alias GabrielAPI.Repo
  alias GabrielAPI.Cameras.Entities.AlertLog

  @datetime_filter_keys [:start_datetime, :end_datetime, :datetime]

  defparams(
    query_params(%{
      customer_id: :integer,
      start_datetime: :naive_datetime,
      end_datetime: :naive_datetime,
      datetime: :naive_datetime
    })
  )

  def run(params) do
    case query_params(params) do
      %Ecto.Changeset{valid?: true} = chst ->
        {:ok,
         chst
         |> Params.to_map()
         |> build_filter_params()
         |> Repo.all()}

      %Ecto.Changeset{} = chst ->
        {:error, Ecto.Changeset.traverse_errors(chst, fn {msg, _opt} -> msg end)}
    end
  end

  defp build_filter_params(params) do
    filter_keys = Map.keys(params)
    any_datetime_filter? = Enum.any?(@datetime_filter_keys, fn dtk -> dtk in filter_keys end)

    if any_datetime_filter? do
      AlertLog.build_filter_query(params)
    else
      params
      |> Map.put(:datetime, NaiveDateTime.utc_now())
      |> AlertLog.build_filter_query()
    end
  end
end
