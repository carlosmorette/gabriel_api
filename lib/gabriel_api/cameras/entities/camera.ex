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
    |> validate_required([:name, :customer_id, :ip])
    |> foreign_key_constraint(:customer_id)
    |> unique_constraint(:ip)
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

  @spec build_filter_query(integer, map) :: Ecto.Query.t()
  def build_filter_query(customer_id, filters) do
    initial_query = from c in __MODULE__, where: c.customer_id == ^customer_id

    Enum.reduce(filters, initial_query, fn {key, value}, query ->
      from q in query, where: field(q, ^key) == ^value
    end)
  end
end
