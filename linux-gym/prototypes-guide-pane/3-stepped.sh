#!/usr/bin/env bash
# PROTOTYPE variant 3 — STEPPED (vimtutor spirit). Wipe me.
# Question: does progressive hint reveal help, or spoon-feed? Ticket up top always;
# press [n] to uncover the NEXT nudge only when stuck. Never shows the command.
set -euo pipefail
cd "$(dirname "$0")"; source ./_content.sh
b=$'\e[1m'; d=$'\e[2m'; c=$'\e[36m'; g=$'\e[32m'; r=$'\e[0m'; clr=$'\e[2J\e[H'

shown=0; total=${#STEPS[@]}
draw(){
  printf '%s' "$clr"
  printf '%s Day %s · %s%s\n\n' "$b" "$DAY" "$TOPIC" "$r"
  printf '%s\n\n' "$TICKET"
  printf '%s── hints revealed: %s/%s ──%s\n' "$d" "$shown" "$total" "$r"
  for ((i=0;i<shown;i++)); do printf '  %s%d.%s %s\n' "$g" "$((i+1))" "$r" "${STEPS[$i]}"; done
  echo
  if (( shown < total )); then
    printf '%s[n]%s reveal next hint   %s[q]%s quit\n' "$c" "$r" "$c" "$r"
  else
    printf '%sAll hints out. Run %scheck%s when solved. %s[q]%s quit\n' "$d" "$c$b" "$r$d" "$c" "$r"
  fi
}
while :; do
  draw; read -rsn1 k
  case "$k" in n) ((shown<total)) && ((shown++));; q) printf '%s' "$clr"; break;; esac
done
