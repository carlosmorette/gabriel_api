#!/bin/bash

export $(xargs < "dev.env")
docker exec -t gabriel_api_app_1 mix test
