#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"

if docker ps -a --format '{{.Names}}' | grep -qx gym-orient-01; then
    exec docker start -ai gym-orient-01
fi

docker build -t gym/orient-01 internals/
exec docker run -it --name gym-orient-01 --hostname vetusto-prod-03 gym/orient-01
