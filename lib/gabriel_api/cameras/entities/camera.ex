defmodule GabrielAPI.Cameras.Entities.Camera do
  use Ecto.Schema

  import Ecto.Changeset
  import Ecto.Query

  alias GabrielAPI.Cameras.IP.Ecto.Type, as: IPType
  alias GabrielAPI.Cameras.Entities.Customer

  @type t :: %__MODULE__{}

  @fields [:name, :ip, :is_enabled, :customer_id]

  schema "cameras" do
    field :name, :string
    field :ip, IPType
    field :is_enabled, :boolean, default: true

    belongs_to :customer, Customer

    timestamps()
  end

  @spec create_changeset(map) :: Ecto.Changeset.t()
  def create_changeset(attrs) do
    %__MODULE__{}
    |> cast(attrs, @fields)
    |> validate_required([:customer_id, :ip])
    |> foreign_key_constraint(:customer_id)
    |> unique_constraint(:ip)
    |> maybe_put_name()
  end

  defp maybe_put_name(%Ecto.Changeset{} = chst) do
    if Map.has_key?(chst.changes, :name) do
      chst
    else
      put_change(chst, :name, Ecto.UUID.generate())
    end
  end

  @spec update_changeset(__MODULE__.t(), map) :: Ecto.Changeset.t()
  def update_changeset(camera, attrs) do
    camera
    |> cast(attrs, [:is_enabled])
  end

  @spec query_one(id: integer) :: Ecto.Query.t()
  def query_one(id: id) do
    from c in __MODULE__, where: c.id == ^id
  end

  @type opts :: [limit: integer, offset: integer]

  @spec build_filter_query(integer, map, opts) :: Ecto.Query.t()
  def build_filter_query(customer_id, filters, limit: limit, offset: offset) do
    initial_query =
      from c in __MODULE__,
        where: c.customer_id == ^customer_id,
        order_by: {:desc, :inserted_at},
        limit: ^limit,
        offset: ^offset

    Enum.reduce(filters, initial_query, fn {key, value}, query ->
      from q in query, where: field(q, ^key) == ^value
    end)
  end
end
