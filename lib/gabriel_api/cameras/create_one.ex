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

  ## TODO: doc + spec
  def run(params) do
    with %Ecto.Changeset{valid?: true} = chst <- Camera.create_changeset(params),
         {:ok, camera} <- Repo.insert(chst) do
      {:ok, camera}
    else
      {:error, %Ecto.Changeset{} = chst} -> {:error, format_errors(chst)}
      %Ecto.Changeset{} = chst -> {:error, format_errors(chst)}
    end
  end

  def format_errors(%Ecto.Changeset{} = chst) do
    Ecto.Changeset.traverse_errors(chst, fn {msg, _opt} -> msg end)
  end
end
