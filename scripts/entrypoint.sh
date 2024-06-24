#!/bin/bash
# Docker entrypoint script.

if [[ -z `psql -Atqc "\\list $POSTGRES_USER"` ]]; then
  echo "Database $POSTGRES_USER does not exist. Creating..."
  mix setup
  echo "Database $POSTGRES_USER created."
fi

mix phx.server