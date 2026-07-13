#!/bin/bash
# check — grades Part 1 of ~/report.md. Expected values are computed live
# against the running system; no answers are hardcoded here.

REPORT="$HOME/report.md"
pass=0
fail=0

if [ ! -f "$REPORT" ]; then
    echo "No report found at $REPORT" >&2
    exit 1
fi

get() {
    grep -m1 -i "^- $1:" "$REPORT" | cut -d: -f2- | sed 's/^[[:space:]]*//; s/[[:space:]]*$//'
}

ok()  { printf 'OK    %s\n' "$1"; pass=$((pass + 1)); }
bad() { printf 'FAIL  %s (got: "%s")\n' "$1" "$2"; fail=$((fail + 1)); }

# contains FIELD VALUE NEEDLE... — every needle must appear (case-insensitive)
contains() {
    local field=$1 val=$2 needle
    shift 2
    for needle in "$@"; do
        if ! grep -qiF -- "$needle" <<< "$val"; then
            bad "$field" "$val"
            return
        fi
    done
    ok "$field"
}

equals() {
    local field=$1 val=$2 want=$3
    if [ "$val" = "$want" ]; then ok "$field"; else bad "$field" "$val"; fi
}

contains hostname         "$(get hostname)"         "$(hostname)"
contains distro           "$(get distro)"           debian 12
contains kernel           "$(get kernel)"           "$(uname -r)"
equals   user             "$(get user)"             dev
equals   uid              "$(get uid)"              "$(id -u dev)"
contains user-groups      "$(get user-groups)"      developers ops
equals   cpu-count        "$(get cpu-count)"        "$(nproc)"

v=$(get memory-gb)
mem=$(free -g | awk '/^Mem:/ {print $2}')
if [[ "$v" =~ ^[0-9]+$ ]] && [ "$v" -ge $((mem - 1)) ] && [ "$v" -le $((mem + 1)) ]; then
    ok memory-gb
else
    bad memory-gb "$v"
fi

contains login-shell      "$(get login-shell)"      bash
contains nmap-installed   "$(get nmap-installed)"   yes
contains docker-installed "$(get docker-installed)" no
contains deploy-env       "$(get deploy-env)"       prod-eu-1
contains others-logged-in "$(get others-logged-in)" marta
contains contractor-claim-verdict "$(get contractor-claim-verdict)" refut

v=$(get last-root-login)
if grep -qiE 'jul[a-z]* *10|07-10|10[/ -]*jul|10/07' <<< "$v"; then
    ok last-root-login
else
    bad last-root-login "$v"
fi

v=$(get evidence)
if [ -n "$v" ]; then ok evidence; else bad evidence "(empty)"; fi

echo
echo "passed: $pass  failed: $fail"
if [ "$fail" -eq 0 ]; then
    echo "Facts verified. Now take Part 2 to Claude for review — that's the real exam."
else
    exit 1
fi
