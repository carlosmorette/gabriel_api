defmodule GabrielAPI.Cameras.CreateAlertLog do
  @moduledoc """
  Operação responsável por criar uma ocorrência dentro do sistema. Representa
  pela entidade #{AlertLog}
  """

  use Params

  alias GabrielAPI.Cameras.Entities.AlertLog
  alias GabrielAPI.Repo

  @type params :: %{
          required(:camera_id) => :integer,
          optional(:occurred_at) => :naive_datetime
        }

  @moduledoc """
  Caso o campo `occurred_at` não seja passado, o valor default é o momento atual.

  Exemplos:
      iex> alias GabrielAPI.Cameras.CreateAlertLog
      iex> CreateAlertLog.run(%{camera_id: 1})
      {:ok, %AlertLog{}}

      iex> CreateAlertLog.run(%{})
      {:error, %{camera_id: ["can't be blank]}}
  """
  @spec run(params) :: {:ok, Alert.t()} | {:error, map}
  def run(params) do
    case AlertLog.create_changeset(params) do
      %Ecto.Changeset{valid?: true} = chst ->
        Repo.insert(chst)

      %Ecto.Changeset{} = chst ->
        {:error, Ecto.Changeset.traverse_errors(chst, fn {msg, _opt} -> msg end)}
    end
  end
end
