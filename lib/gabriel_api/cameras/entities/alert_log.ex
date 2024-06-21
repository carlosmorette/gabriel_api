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

  def create_changeset(attrs) do
    %__MODULE__{}
    |> cast(attrs, @fields)
    |> validate_required(:camera_id)
    |> maybe_put_occurred_at(attrs)
  end

  defp maybe_put_occurred_at(%Ecto.Changeset{} = chst, %{occurred_at: _occurred_at}), do: chst

  defp maybe_put_occurred_at(%Ecto.Changeset{} = chst, _params) do
    put_change(chst, :occurred_at, NaiveDateTime.truncate(NaiveDateTime.utc_now(), :second))
  end

  def build_filter_query(filters) do
    initial_query = __MODULE__

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
