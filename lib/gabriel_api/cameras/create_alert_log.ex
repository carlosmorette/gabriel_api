defmodule GabrielAPI.Cameras.CreateAlertLog do
  use Params

  alias GabrielAPI.Repo
  alias GabrielAPI.Cameras.Entities.AlertLog

  ## TODO: doc + spec
  def run(params) do
    case AlertLog.create_changeset(params) do
      %Ecto.Changeset{valid?: true} = chst ->
        Repo.insert(chst)

      %Ecto.Changeset{} = chst ->
        {:error, Ecto.Changeset.traverse_errors(chst, fn {msg, _opt} -> msg end)}
    end
  end
end
