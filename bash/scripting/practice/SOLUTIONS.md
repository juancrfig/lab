# Solutions

Open only after you've tried. Compare even if yours worked.

---

## L1 — Variables & Quotes

```bash
# 1
#!/bin/bash
name="Juanes"
today=$(date +%Y-%m-%d)
host=$(hostname)
echo "Name: $name"
echo "Date: $today"
echo "Host: $host"
# $(...) captures command stdout. No spaces around =.

# 2 — output:
# Hello Juanes   <- double quotes: variables expand
# Hello $user    <- single quotes: everything literal

# 3 — bugs:
# greeting = "Hello"  ->  greeting="Hello"   (no spaces around =)
# echo $greeting      ->  echo "$greeting"    (always quote variables)
```

---

## L2 — Arguments & Debug

```bash
# 1 — greet.sh
#!/bin/bash
if [[ $# -eq 0 ]]; then
  echo "Usage: $0 <name>"
  exit 1
fi
echo "Hello, $1!"
# $# = arg count. $0 = script name. exit 1 = signal failure.

# 2
#!/bin/bash
i=1
for arg in "$@"; do
  echo "$i: $arg"
  (( i++ ))
done
# "$@" = each arg as its own quoted word
# "$*" = all args collapsed into one string — breaks on spaces

# 3 — bash -x output looks like:
# + [[ 1 -eq 0 ]]
# + echo 'Hello, Juanes!'
# Each + line = one fully expanded command bash ran
```

---

## L3 — Parameter Expansion

```bash
# 1
filepath="/home/juanes/reports/summary.tar.gz"
filename="${filepath##*/}"    # summary.tar.gz  — strip longest prefix to last /
directory="${filepath%/*}"    # /home/juanes/reports — strip suffix from last /
extension="${filename##*.}"   # gz — strip longest prefix to last .
basename="${filename%%.*}"    # summary — strip longest suffix from first .

# Memory aid — keyboard order:
# # is LEFT of $  -> strips LEFT  (prefix)
# % is RIGHT of $ -> strips RIGHT (suffix)
# Double ## or %% -> longest match

# 2 — deploy.sh
#!/bin/bash
env_name="${1:-staging}"
log_level="${LOG_LEVEL:-info}"
echo "Deploying to: $env_name (log level: $log_level)"

# 3
#!/bin/bash
password="${1:-}"
if [[ -z "$password" ]]; then
  echo "Usage: $0 <password>"; exit 1
fi
if [[ ${#password} -lt 8 ]]; then
  echo "Error: too short (${#password} chars, min 8)"; exit 1
fi
echo "OK: length ${#password}"
# ${1:-} = empty string default (not '' which is two literal quote chars)
# ${#var} = string length, no subprocess

# 4
text="hello world from bash"
no_spaces="${text// /_}"
upper="${no_spaces^^}"
echo "$upper"   # HELLO_WORLD_FROM_BASH
# ${var//old/new} replaces all. Single / = first only.
# ${var^^} uppercase. ${var,,} lowercase.
```

---

## L4 — Conditionals & Exit Codes

```bash
# 1
#!/bin/bash
file="${1:-}"
[[ -z "$file" ]] && { echo "Usage: $0 <file>"; exit 1; }
[[ ! -f "$file" ]] && { echo "Error: '$file' not found"; exit 1; }
[[ ! -r "$file" ]] && { echo "Error: '$file' not readable"; exit 1; }
echo "OK: '$file' exists and is readable"
# Always [[ ]] never [ ] — bash-native, safer, no word splitting

# 2
#!/bin/bash
case "${1:-dev}" in
  production) echo "[PROD] Full logging, alerts on" ;;
  staging)    echo "[STAGING] Verbose, errors to Slack" ;;
  dev)        echo "[DEV] Debug mode, local db" ;;
  *)          echo "Error: unknown env '$1'"; exit 1 ;;
esac

# 3
#!/bin/bash
# Pattern 1: check $?
ls /etc/passwd > /dev/null
[[ $? -eq 0 ]] && echo "1. ok"

# Pattern 2: inline
ls /nonexistent 2>/dev/null && echo "2. found" || echo "2. not found"

# Pattern 3: abort
mkdir -p /tmp/myapp || { echo "3. failed to create dir"; exit 1; }
echo "3. dir ready"
```

---

## L5 — Loops

```bash
# 1
#!/bin/bash
services=(nginx git docker kubectl node)
for svc in "${services[@]}"; do
  if command -v "$svc" &>/dev/null; then
    echo "[OK]      $svc"
  else
    echo "[MISSING] $svc"
  fi
done
# command -v = correct binary check. Not which. Not type.
# Always quote array: "${arr[@]}"

# 2
#!/bin/bash
while read -r line; do
  [[ "$line" == "#"* ]] && continue
  [[ -z "$line" ]]      && continue
  echo "$line"
done < /etc/shells
# Always read -r. < file is faster than cat file | while read.

# 3
#!/bin/bash
for script in ../scripts/*.sh; do
  [[ -f "$script" ]] || continue
  lines=$(wc -l < "$script")
  echo "${script##*/}: $lines lines"
done
# Never $(ls *.sh). Globs are bash-native, safe on filenames with spaces.
# [[ -f ]] guard handles the case where no .sh files exist.
```

---

## L6 — Functions

```bash
# 1
#!/bin/bash
log_info()  { echo "[INFO]  $(date +%H:%M:%S) $*"; }
log_error() { echo "[ERROR] $(date +%H:%M:%S) $*" >&2; }
log_info "Starting"
log_error "DB connection failed"
# >&2 sends to stderr. Matters when piping or redirecting.

# 2
#!/bin/bash
file_exists() {
  local path="$1"
  [[ -f "$path" ]]   # last command exit code = function exit code
}
if file_exists "/etc/passwd"; then
  echo "found"
fi
# Functions return data two ways:
# exit code (0/1) -> use with if / && / ||
# echo            -> capture with result=$(my_func)
# local = stays inside function. Without it leaks to global scope.

# 3
#!/bin/bash
set -euo pipefail
# -e  exit on any error
# -u  error on unset variable (catches typos)
# -o pipefail  catch failures inside pipes

DEPLOY_DIR="/tmp/deploy"
SOURCE_FILE="/etc/hostname"  # readable by all users

log_info()   { echo "[INFO] $*"; }
setup_dir()  { mkdir -p "$DEPLOY_DIR"; log_info "Dir ready: $DEPLOY_DIR"; }
copy_files() { cp "$SOURCE_FILE" "$DEPLOY_DIR/"; log_info "Copied $SOURCE_FILE"; }
main()       { log_info "Starting"; setup_dir; copy_files; log_info "Done"; }

main "$@"
# main "$@" passes all script args into main so $1, $2... work inside it
```

---

## L7 — Integration

```bash
#!/bin/bash
set -euo pipefail

DEFAULT_SERVICES=(nginx git docker)

log_info() { echo "[INFO]    $*"; }
log_ok()   { echo "[OK]      $*"; }
log_miss() { echo "[MISSING] $*"; }

check_service() {
  local svc="$1"
  if command -v "$svc" &>/dev/null; then
    log_ok "$svc"; return 0
  else
    log_miss "$svc"; return 1
  fi
}

main() {
  local services=()
  if [[ $# -gt 0 ]]; then
    services=("$@")
  else
    services=("${DEFAULT_SERVICES[@]}")
  fi

  local total=${#services[@]}
  local ok=0

  log_info "Checking $total services..."
  echo ""

  for svc in "${services[@]}"; do
    check_service "$svc" && (( ok++ )) || true
    # || true prevents -e from aborting when check_service returns 1
  done

  echo ""
  echo "${ok}/${total} services available"
  [[ $ok -eq $total ]]
}

main "$@"
```
