# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     GabrielAPI.Repo.insert!(%GabrielAPI.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias GabrielAPI.Cameras.Entities.Customer
alias GabrielAPI.Cameras.{CreateOne, CreateAlertLog}

# create some customers
names = ["Rogério", "Augusto", "César", "Danilo", "João"]

customers = for name <- names, do: Customer.create!(name)

camera_ip_base = "200.100.0"

cameras =
  for c <- customers do
    data = %{
      ip: "#{camera_ip_base}.#{c.id}",
      customer_id: c.id
    }

    CreateOne.run(%{ip: data})
  end

alerts =
  for c <- cameras do
    random_day = Enum.random(1..30)
    random_month = Enum.random(1..12)
    random_year = Enum.random(2000..2024)
    random_hour = Enum.random(0..23)
    random_minute = Enum.random(0..59)
    random_second = Enum.random(0..59)

    occurred_at =
      NaiveDateTime.new!(
        random_year,
        random_month,
        random_day,
        random_hour,
        random_minute,
        random_second
      )

    CreateAlertLog.run(%{camera_id: c.id})

    CreateAlertLog.run(%{
      camera_id: c.id,
      occurred_at: occurred_at
    })
  end

IO.puts("[SEEDS] Created #{length(customers)} customers!")

for c <- customers do
  IO.puts("customer -> ID: #{c.id}, Name: #{c.name}")
end

IO.puts("[SEEDS] Created #{length(cameras)} cameras!")

for c <- cameras do
  IO.puts(
    "camera -> ID: #{c.id}, IP: #{c.ip}, IsEnabled: #{c.is_enabled}, CustomerID: #{c.customer_id}"
  )
end

IO.puts("[SEEDS] Created #{length(alerts)} alerts!")

for a <- alerts do
  IO.puts(
    "alert_log -> ID: #{a.id}, OccurredAt: #{inspect(a.occurred_at)}, CameraID: #{a.camera_id}"
  )
end

IO.puts("end seeds...")
