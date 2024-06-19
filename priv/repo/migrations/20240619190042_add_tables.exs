defmodule GabrielAPI.Repo.Migrations.AddTables do
  use Ecto.Migration

  def change do
    create table(:customers) do
      add :name, :string, null: false

      timestamps()
    end

    create table(:cameras) do
      add :name, :string
      add :ip, :string, null: false
      add :is_enabled, :boolean
      add :customer_id, references(:customers), null: false

      timestamps()
    end

    create unique_index(:cameras, :ip)

    create table(:alert_logs) do
      add :occurred_at, :naive_datetime
      add :camera_id, references(:cameras), null: false
    end
  end
end
