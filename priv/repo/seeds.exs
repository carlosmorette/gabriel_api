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

# create some customers
names = ["Rogério", "Augusto", "César", "Danilo", "João"]

for name <- names do
  Customer.create!(name)
end

IO.puts("Created #{length(names)} Customers!")
