defmodule GabrielAPI.Cameras.Disable do
  alias GabrielAPI.Cameras.Entities.Camera
  alias GabrielAPI.Repo
  alias Ecto.Multi

  @type params :: %{
          required(:camera_id) => integer
        }

  @spec run(params) :: {:ok, any} | {:error, atom | any}
  def run(%{camera_id: id}) do
    Multi.new()
    |> Multi.one(:find_one, Camera.query_one(id: id))
    |> Multi.run(:update, fn
      _repo, %{find_one: nil} -> {:error, :camera_not_found}
      repo, %{find_one: camera} -> repo.update(disable(camera))
    end)
    |> Repo.transaction()
    |> format_result()
  end

  def run(_), do: {:error, :required_camera_id}

  def disable(camera) do
    Camera.update_changeset(camera, %{is_enabled: false})
  end

  defp format_result({:error, :update, error, _state}), do: {:error, error}
  defp format_result({:ok, steps_result}), do: {:ok, steps_result.update}
end
