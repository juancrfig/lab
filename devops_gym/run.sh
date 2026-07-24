#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"

docker build -t gym/devops-lab .
exec docker run -it --rm --hostname devops-lab gym/devops-lab
