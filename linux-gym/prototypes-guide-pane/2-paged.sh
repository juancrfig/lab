#!/usr/bin/env bash
# PROTOTYPE variant 2 (chosen) — PAGED guide pane. Wipe me.
# 3 pages, live key-toggle, no quit (Ctrl-C or close the tmux pane).
#   [t] Ticket   [c] Commands (names only)   [q] Questions (theory + hands-on)
set -euo pipefail
cd "$(dirname "$0")"; source ./_content.sh
b=$'\e[1m'; d=$'\e[2m'; c=$'\e[36m'; g=$'\e[32m'; r=$'\e[0m'; clr=$'\e[2J\e[H'

nav(){ # highlight the active page in the footer
  local a=$1
  hl(){ [ "$1" = "$a" ] && printf '%s%s%s' "$c$b" "$2" "$r" || printf '%s%s%s' "$d" "$2" "$r"; }
  printf '\n%s ─ ' "$d"; printf '%s' "$r"
  hl t '[t]icket'; printf '   '; hl c '[c]ommands'; printf '   '; hl q '[q]uestions'
  printf '\n'
}
header(){ printf '%s' "$clr"; }

page_ticket(){ header; printf '%sTICKET%s\n%s\n' "$b" "$r" "$TICKET"; nav t; }
page_commands(){
  header; printf '%sCOMMANDS IN PLAY%s\n\n' "$b" "$r"
  printf '  %s%s%s\n' "$g" "${COMMANDS[*]}" "$r"; nav c; }
page_questions(){
  header; printf '%sQUESTIONS%s\n\n' "$b" "$r"
  local i=1; for q in "${QUESTIONS[@]}"; do printf '  %s%d.%s %s\n\n' "$c" "$i" "$r" "$q"; ((i++)); done
  nav q; }

view=t
while :; do
  case "$view" in t) page_ticket;; c) page_commands;; q) page_questions;; esac
  read -rsn1 k
  case "$k" in t|c|q) view=$k;; esac
done
