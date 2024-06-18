defmodule GabrielAPI.Cameras.CreateOne do
  alias GabrielAPI.Repo
  alias GabrielAPI.Cameras.IP.Ecto.Type, as: IPType
  alias GabrielAPI.Cameras.Entities.Camera

  @type params :: %{
          optional(:ip) => IPType,
          optional(:is_enabled?) => boolean,
          required(:customer_id) => integer,
          required(:name) => String.t()
        }

  def run(params) do
    case Camera.create_changeset(params) do
      %Ecto.Changeset{valid?: true} = changeset ->
        Repo.insert(changeset)

      %Ecto.Changeset{} = chst ->
        Ecto.Changeset.traverse_errors(chst, fn {msg, _opt} -> msg end)
    end
  end
end
