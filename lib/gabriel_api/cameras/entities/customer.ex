defmodule GabrielAPI.Cameras.Entities.Customer do
  use Ecto.Schema

  alias GabrielAPI.Repo

  schema "customers" do
    field :name, :string

    timestamps()
  end

  ## Uso apenas para seeds
  def create!(name) do
    Repo.insert!(%__MODULE__{name: name})
  end
end
