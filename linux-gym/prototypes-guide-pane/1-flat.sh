#!/usr/bin/env bash
# PROTOTYPE variant 1 — FLAT BRIEF. Wipe me.
# Question: is one static consolidated page enough? Zero interaction. You read, you go.
set -euo pipefail
cd "$(dirname "$0")"; source ./_content.sh
b=$'\e[1m'; d=$'\e[2m'; c=$'\e[36m'; r=$'\e[0m'

printf '%s\n' "${d}────────────────────────────────────────${r}"
printf '%s Linux Gym %s· Day %s%s\n' "$b" "$d" "$DAY" "$r"
printf '%s Today: %s%s%s\n' "$d" "$c" "$TOPIC" "$r"
printf '%s\n\n' "${d}────────────────────────────────────────${r}"

printf '%sTICKET%s\n%s\n\n' "$b" "$r" "$TICKET"

printf '%sCONCEPTS IN PLAY%s\n' "$b" "$r"
for line in "${CONCEPTS[@]}"; do printf '  %s%s%s\n' "$d" "$line" "$r"; done
printf '\n%sWhen done:%s run %scheck%s in the box.\n' "$b" "$r" "$c" "$r"
