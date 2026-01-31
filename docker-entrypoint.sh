#!/bin/bash
# Docker entrypoint script
# Runs all scripts in docker-entrypoint.d, then starts the gateway

set -e

# Run all entrypoint scripts
if [ -d "/app/docker-entrypoint.d" ]; then
  for script in /app/docker-entrypoint.d/*.sh; do
    if [ -f "$script" ] && [ -x "$script" ]; then
      echo "==> Running entrypoint script: $(basename "$script")"
      "$script"
    fi
  done
fi

# Start the gateway
exec node dist/index.js gateway --port 8080 --bind lan "$@"
