defmodule GabrielAPI.Cameras.Entities.AlertLog do
  use Ecto.Schema

  import Ecto.Query
  import Ecto.Changeset

  alias GabrielAPI.Cameras.Entities.Camera

  @type t :: %__MODULE__{}

  @fields [:occurred_at, :camera_id]

  schema "alert_logs" do
    field :occurred_at, :naive_datetime

    belongs_to :camera, Camera

    timestamps()
  end

  @spec create_changeset(map) :: Ecto.Changeset.t()
  def create_changeset(attrs) do
    %__MODULE__{}
    |> cast(attrs, @fields)
    |> validate_required(:camera_id)
    |> maybe_put_occurred_at()
  end

  defp maybe_put_occurred_at(%Ecto.Changeset{} = chst) do
    if Map.has_key?(chst.changes, :occurred_at) do
      chst
    else
      put_change(chst, :occurred_at, NaiveDateTime.truncate(NaiveDateTime.utc_now(), :second))
    end
  end

  @type opts :: [limit: integer, offset: integer]

  @spec build_filter_query(map, opts) :: Ecto.Query.t()
  def build_filter_query(filters, limit: limit, offset: offset) do
    initial_query =
      from a in __MODULE__,
        order_by: {:desc, :occurred_at},
        limit: ^limit,
        offset: ^offset

    Enum.reduce(filters, initial_query, fn
      {:customer_id, id}, query ->
        from q in query, join: c in assoc(q, :camera), where: c.customer_id == ^id

      {:start_datetime, value}, query ->
        from q in query, where: field(q, :occurred_at) >= ^value

      {:end_datetime, value}, query ->
        from q in query, where: field(q, :occurred_at) <= ^value

      {:datetime, value}, query ->
        from q in query,
          where: fragment("extract(year from ?)", q.occurred_at) == ^value.year,
          where: fragment("extract(month from ?)", q.occurred_at) == ^value.month,
          where: fragment("extract(day from ?)", q.occurred_at) == ^value.day,
          where: fragment("extract(hour from ?)", q.occurred_at) == ^value.hour
    end)
  end
end
