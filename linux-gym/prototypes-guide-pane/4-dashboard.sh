#!/usr/bin/env bash
# PROTOTYPE variant 4 — DASHBOARD / DAILY ON-RAMP. Wipe me.
# Question: does a "what do I do today" home screen kill the on-ramp friction?
# Shows streak + today's pick, [Enter] launches straight into the flat brief.
set -euo pipefail
cd "$(dirname "$0")"; source ./_content.sh
b=$'\e[1m'; d=$'\e[2m'; c=$'\e[36m'; g=$'\e[32m'; y=$'\e[33m'; r=$'\e[0m'; clr=$'\e[2J\e[H'

# fake state — real version reads a ledger file
streak=6; done_total=13

printf '%s' "$clr"
printf '%s  ╔══════════════════════════╗%s\n' "$c" "$r"
printf '%s  ║      L I N U X   G Y M    ║%s\n' "$c" "$r"
printf '%s  ╚══════════════════════════╝%s\n\n' "$c" "$r"
printf '   %s🔥 %s%s-day streak%s      %s%s solved%s\n\n' "$y" "$b" "$streak" "$r" "$d" "$done_total" "$r"
printf '   %sTODAY  %s→%s  %s%s%s\n' "$b" "$d" "$r" "$g" "$TOPIC" "$r"
printf '          %s%s%s\n\n' "$d" "$(echo "$TICKET" | head -1)…" "$r"
printf '   %s[Enter]%s start   %s[s]%s skip/reroll   %s[q]%s quit\n' "$c" "$r" "$c" "$r" "$c" "$r"

read -rsn1 k
case "$k" in
  q) printf '%s' "$clr";;
  *) exec ./1-flat.sh;;   # launches into the brief + (real version) the box
esac
