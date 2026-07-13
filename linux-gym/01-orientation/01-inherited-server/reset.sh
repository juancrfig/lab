#!/usr/bin/env bash
set -euo pipefail

read -r -p "Wipe container gym-orient-01 and start the scenario fresh? [y/N] " answer
case "$answer" in
    y|Y) docker rm -f gym-orient-01 ;;
    *)   echo "Aborted." ;;
esac
