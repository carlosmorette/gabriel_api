defmodule GabrielAPI.Cameras.Entities.Camera do
  use Ecto.Schema

  import Ecto.Changeset

  alias GabrielAPI.Cameras.IP.Ecto.Type, as: IPType
  alias GabrielAPI.Cameras.Entities.Customer

  schema "cameras" do
    field :name, :string
    field :ip, IPType
    field :is_enabled, :boolean

    belongs_to :customer, Customer
  end

  @spec create_changeset(map) :: Ecto.Changeset.t()
  def create_changeset(attrs) do
    %__MODULE__{}
    |> cast(attrs, [:name, :ip, :is_enabled])
    |> validate_required([:name, :customer_id])
    |> foreign_key_constraint(:customer_id)
    |> unique_constraint(:ip)
  end
end
