defmodule GabrielAPI.Cameras.QueryAlerts do
  use Params

  alias GabrielAPI.Repo
  alias GabrielAPI.Cameras.Entities.AlertLog

  @default_limit 10

  @datetime_filter_keys [:start_datetime, :end_datetime, :datetime]

  defparams(
    query_params(%{
      filters!: %{
        customer_id: :integer,
        start_datetime: :naive_datetime,
        end_datetime: :naive_datetime,
        datetime: :naive_datetime
      },
      limit: :integer,
      offset: :integer
    })
  )

  def run(params) do
    case query_params(params) do
      %Ecto.Changeset{valid?: true} = chst ->
        {:ok, do_query(chst)}

      %Ecto.Changeset{} = chst ->
        {:error, Ecto.Changeset.traverse_errors(chst, fn {msg, _opt} -> msg end)}
    end
  end

  defp do_query(chst) do
    params = build_query_params(chst)

    alerts =
      params.filters
      |> AlertLog.build_filter_query(limit: params.limit, offset: params.offset)
      |> Repo.all()

    %{alerts: alerts, offset: params.offset + length(alerts)}
  end

  defp build_query_params(chst) do
    params = Params.to_map(chst)
    filters = params.filters
    limit = Map.get(params, :limit, @default_limit)
    offset = Map.get(params, :offset, 0)

    filter_keys = Map.keys(filters)
    any_datetime_filter? = Enum.any?(@datetime_filter_keys, fn dtk -> dtk in filter_keys end)

    if any_datetime_filter? do
      %{filters: filters, limit: limit, offset: offset}
    else
      %{
        filters: put_in(filters, [:datetime], NaiveDateTime.utc_now()),
        limit: limit,
        offset: offset
      }
    end
  end
end
