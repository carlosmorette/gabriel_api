# GabrielAPI

Esse projeto é referente ao desafio técnico para Desenvolvedor Back-End da empresa **Gabriel**.

## Rodar o projeto
Para iniciar esse projeto siga os seguintes passos:
1. Rode `chmod +xr ./scripts/build-image.sh` para permitir a execução do script.
2. Rode `./scripts/build-image.sh` para criar a imagem do projeto em seu dispositivo.
3. Rode `chmod +xr ./scripts/start.sh` para permitir a execcução do script.
4. Rode `./scripts/start.sh` para rodar os dois containers (app e postgres)

Após seguir os passos acima, será possível testar a aplicação em `http://localhost:4000`.
Alguns registros de teste foram inseridos usando [seeds](https://hexdocs.pm/phoenix/1.3.0-rc.0/seeding_data.html).

Log de exemplo:
```elixir
app_1       | [SEEDS] Created 5 customers!
app_1       | customer -> ID: 34, Name: Rogério
app_1       | customer -> ID: 35, Name: Augusto
app_1       | customer -> ID: 36, Name: César
app_1       | customer -> ID: 37, Name: Danilo
app_1       | customer -> ID: 38, Name: João
app_1       | [SEEDS] Created 5 cameras!
app_1       | camera -> ID: 34, IP: 200.100.0.34, IsEnabled: true, CustomerID: 34
app_1       | camera -> ID: 35, IP: 200.100.0.35, IsEnabled: true, CustomerID: 35
app_1       | camera -> ID: 36, IP: 200.100.0.36, IsEnabled: true, CustomerID: 36
app_1       | camera -> ID: 37, IP: 200.100.0.37, IsEnabled: true, CustomerID: 37
app_1       | camera -> ID: 38, IP: 200.100.0.38, IsEnabled: true, CustomerID: 38
app_1       | [SEEDS] Created 5 alerts!
app_1       | alert_log_1 -> ID: 34, OccurredAt: ~N[2024-06-24 14:49:31], CameraID: 34
app_1       | alert_log_1 -> ID: 35, OccurredAt: ~N[2020-02-11 08:23:06], CameraID: 34
app_1       | alert_log_1 -> ID: 36, OccurredAt: ~N[2024-06-24 14:49:31], CameraID: 35
app_1       | alert_log_1 -> ID: 37, OccurredAt: ~N[2008-11-25 23:01:26], CameraID: 35
app_1       | alert_log_1 -> ID: 38, OccurredAt: ~N[2024-06-24 14:49:31], CameraID: 36
app_1       | alert_log_1 -> ID: 39, OccurredAt: ~N[2004-04-09 16:49:53], CameraID: 36
app_1       | alert_log_1 -> ID: 40, OccurredAt: ~N[2024-06-24 14:49:31], CameraID: 37
app_1       | alert_log_1 -> ID: 41, OccurredAt: ~N[2001-04-28 13:11:20], CameraID: 37
app_1       | alert_log_1 -> ID: 42, OccurredAt: ~N[2024-06-24 14:49:31], CameraID: 38
app_1       | alert_log_1 -> ID: 43, OccurredAt: ~N[2022-11-19 03:30:02], CameraID: 38
```

## Testes
Para rodar os testes, siga os seguintes passos
1. Rode `chmod +xr ./scripts/run-tests.sh` para permitir a execução do script.
2. Rode `./scripts/run-tests.sh` e então os testes do sistema serão executados e terá o seguinte resultado:
```sh
.............................
Finished in 0.08 seconds (0.08s async, 0.00s sync)
29 tests, 0 failures
```

## Observação
Foi incluído o arquivo `dev.env` no tracking do Git, porém em um cenário real ele não subiria junto. O mesmo foi incluído apenas para agilizar os testes do time da Gabriel.