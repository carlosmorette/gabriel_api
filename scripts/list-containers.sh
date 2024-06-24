#!/bin/bash

export $(xargs < "dev.env")

docker-compose ps 