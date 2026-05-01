# Bash Scripting — Morning Practice

> One level per day ≈ 5–7 min. Full run ≈ 30 min.
> Write each script from scratch in your editor, run it, debug it.
> Use `bash -x script.sh` when something breaks. Run `shellcheck script.sh` before submitting anything.

---

## How to use this

```bash
cd bash/scripting/practice

# Write your solution
vim challenge.sh

# Check for issues before running
shellcheck challenge.sh

# Run it
bash challenge.sh

# Debug mode (shows each line as it executes)
bash -x challenge.sh
```

> **shellcheck** is your linter. Install it: `sudo apt install shellcheck` or `brew install shellcheck`.
> **bash -x** traces every command. Add `set -x` inside a script to debug a specific section.

---

## Level 1 — Variables & Quotes

> Topics: assignment, access, single vs double quotes, command substitution

**1.1** Write a script that stores your name, today’s date, and the current hostname into variables, then prints them on one line each.
<details><summary>Solution</summary>

```bash
#!/bin/bash
name="Juanes"
today=$(date +%Y-%m-%d)
host=$(hostname)

echo "Name: $name"
echo "Date: $today"
echo "Host: $host"
```

> `$(command)` captures the output of a command into a variable. No spaces around `=`.
</details>

**1.2** What’s the difference between these two lines? Predict the output before running.

```bash
user="Juanes"
echo "Hello $user"
echo 'Hello $user'
```
<details><summary>Solution</summary>

```
Hello Juanes   ← double quotes: variables are expanded
Hello $user    ← single quotes: everything is literal
```

> Rule: use double quotes almost always. Use single quotes when you want a literal string with no expansion.
</details>

**1.3** What’s wrong with this script? Fix it.

```bash
#!/bin/bash
greeting = "Hello"
echo $greeting
```
<details><summary>Solution</summary>

```bash
#!/bin/bash
greeting="Hello"   # no spaces around =
echo "$greeting"   # always quote variables
```

> Spaces around `=` make bash think `greeting` is a command. Always quote `$var` to avoid word splitting.
</details>

---

## Level 2 — Arguments & Debug Mode

> Topics: `$1`, `$#`, `$@`, `bash -x`, `shellcheck`

**2.1** Write a script `greet.sh` that takes a name as `$1` and prints `Hello, <name>!`. If no argument is given, print `Usage: greet.sh <name>` and exit with code 1.
<details><summary>Solution</summary>

```bash
#!/bin/bash

if [[ $# -eq 0 ]]; then
  echo "Usage: $0 <name>"
  exit 1
fi

echo "Hello, $1!"
```

> `$#` = number of arguments. `$0` = script name. `exit 1` signals failure.
</details>

**2.2** Write a script that prints each argument it receives on a separate line, prefixed with its position number.

```bash
# Example: bash script.sh alpha beta gamma
# 1: alpha
# 2: beta
# 3: gamma
```
<details><summary>Solution</summary>

```bash
#!/bin/bash
i=1
for arg in "$@"; do
  echo "$i: $arg"
  (( i++ ))
done
```

> `"$@"` expands to all arguments as separate quoted strings. Never use `$*` — it breaks on spaces in arguments.
</details>

**2.3** Run any of your scripts with `bash -x` and observe the trace. Then add `set -x` halfway through a script to debug only that section.
<details><summary>What to look for</summary>

```bash
bash -x greet.sh Juanes
# + [[ 0 -eq 0 ]]   ← each line shows with + prefix
# + echo 'Hello, Juanes!'
# Hello, Juanes!
```

> Lines prefixed with `+` are the expanded commands bash actually ran. This is how you catch quoting bugs.
</details>

---

## Level 3 — Parameter Expansion

> Your mentor’s core lesson: stop spawning subprocesses. Do it inside bash.

**3.1** Without using `sed`, `cut`, or `awk` — extract the filename, directory, extension, and base name from this path.

```bash
filepath="/home/juanes/reports/summary.tar.gz"
```
<details><summary>Solution</summary>

```bash
#!/bin/bash
filepath="/home/juanes/reports/summary.tar.gz"

filename="${filepath##*/}"    # summary.tar.gz
directory="${filepath%/*}"    # /home/juanes/reports
extension="${filename##*.}"   # gz
basename="${filename%%.*}"    # summary

echo "filename:  $filename"
echo "directory: $directory"
echo "extension: $extension"
echo "basename:  $basename"
```

> Memory aid: `#` is left of `$` on keyboard → removes from left (prefix). `%` is right of `$` → removes from right (suffix). Single = shortest match, double = longest match.
</details>

**3.2** Write a script `deploy.sh` that takes an environment as `$1`. Use a default value so it falls back to `staging` if nothing is passed.
<details><summary>Solution</summary>

```bash
#!/bin/bash
env="${1:-staging}"
log_level="${LOG_LEVEL:-info}"

echo "Deploying to: $env (log level: $log_level)"
```

> `${var:-default}` is the professional way to handle missing args. No `if` statement needed.
</details>

**3.3** Validate a password variable: if it’s shorter than 8 characters, print an error and exit 1.
<details><summary>Solution</summary>

```bash
#!/bin/bash
password="${1:-’’}"

if [[ ${#password} -lt 8 ]]; then
  echo "Error: password too short (${#password} chars, need 8+)"
  exit 1
fi

echo "Password length OK: ${#password} chars"
```

> `${#var}` = length of the string. No `echo | wc -c` needed.
</details>

**3.4** Replace all spaces in a string with underscores, then uppercase it — without `tr` or `sed`.
<details><summary>Solution</summary>

```bash
#!/bin/bash
text="hello world from bash"
no_spaces="${text// /_}"
upper="${no_spaces^^}"

echo "$upper"   # HELLO_WORLD_FROM_BASH
```

> `${var// /replacement}` replaces all matches. `${var^^}` uppercases. Both are built-in.
</details>

---

## Level 4 — Conditionals & Exit Codes

> Topics: `[[ ]]`, `-f/-d/-e`, `-z/-n`, `&&`, `||`, `$?`, `case`

**4.1** Write a script that checks if a file passed as `$1` exists and is readable. Print a clear message for each case.
<details><summary>Solution</summary>

```bash
#!/bin/bash
file="${1:-}"

if [[ -z "$file" ]]; then
  echo "Usage: $0 <file>"
  exit 1
fi

if [[ ! -f "$file" ]]; then
  echo "Error: '$file' does not exist or is not a file"
  exit 1
fi

if [[ ! -r "$file" ]]; then
  echo "Error: '$file' is not readable"
  exit 1
fi

echo "OK: '$file' exists and is readable"
```
</details>

**4.2** Write a `case` statement that prints a message based on the environment argument: `production`, `staging`, `dev`, or anything else.
<details><summary>Solution</summary>

```bash
#!/bin/bash
env="${1:-dev}"

case "$env" in
  production)
    echo "[PROD] Full logging, no debug"
    ;;
  staging)
    echo "[STAGING] Verbose logging enabled"
    ;;
  dev)
    echo "[DEV] Debug mode on"
    ;;
  *)
    echo "Unknown environment: $env"
    exit 1
    ;;
esac
```

> `case` is cleaner than chained `if/elif` for matching a variable against known values.
</details>

**4.3** Run a command and check its exit code with `$?`. Use `&&` and `||` to handle success and failure in one line.
<details><summary>Solution</summary>

```bash
#!/bin/bash

# Long form with $?
ls /etc/passwd
if [[ $? -eq 0 ]]; then
  echo "Command succeeded"
else
  echo "Command failed"
fi

# Concise with && / ||
ls /nonexistent 2>/dev/null && echo "Found" || echo "Not found"

# Professional pattern: abort on failure
mkdir -p /tmp/myapp && echo "Dir ready" || { echo "Failed to create dir"; exit 1; }
```

> `{ cmd; exit 1; }` is a command group — use it with `||` when you need multiple commands on failure.
</details>

---

## Level 5 — Loops

> Topics: `for`, `while`, `read -r`, `break`, `continue`, file globs

**5.1** Loop over a list of services and print whether each binary exists on the system.
<details><summary>Solution</summary>

```bash
#!/bin/bash
services=(nginx git docker kubectl node)

for svc in "${services[@]}"; do
  if command -v "$svc" &>/dev/null; then
    echo "[OK]     $svc"
  else
    echo "[MISSING] $svc"
  fi
done
```

> `command -v` is the right way to check if a binary exists. Not `which`. Not `type`.
</details>

**5.2** Read `practice/../logs/app.log` line by line and print only the ERROR lines.
<details><summary>Solution</summary>

```bash
#!/bin/bash
logfile="../logs/app.log"

while read -r line; do
  if [[ "$line" == *"[ERROR]"* ]]; then
    echo "$line"
  fi
done < "$logfile"
```

> Always use `read -r` — without `-r`, backslashes are interpreted. `< file` feeds the file into the loop as stdin.
</details>

**5.3** Loop over all `.sh` files in `../scripts/` using a glob (not `ls`) and print each filename and its line count.
<details><summary>Solution</summary>

```bash
#!/bin/bash

for script in ../scripts/*.sh; do
  [[ -f "$script" ]] || continue   # skip if glob matched nothing
  lines=$(wc -l < "$script")
  echo "${script##*/}: $lines lines"
done
```

> **Never** use `$(ls *.sh)` — it breaks on filenames with spaces. Globs are safe and built-in.
</details>

---

## Level 6 — Functions

> Topics: defining functions, `local`, return values, reusability

**6.1** Write a function `log_info` and `log_error` that prefix messages with `[INFO]` and `[ERROR]` plus a timestamp.
<details><summary>Solution</summary>

```bash
#!/bin/bash

log_info() {
  echo "[INFO]  $(date +%H:%M:%S) $*"
}

log_error() {
  echo "[ERROR] $(date +%H:%M:%S) $*" >&2
}

log_info "Starting deployment"
log_error "Database connection failed"
log_info "Done"
```

> `$*` inside a function = all arguments passed to the function. `>&2` sends to stderr.
</details>

**6.2** Write a function `file_exists` that returns exit code 0 if a file exists, 1 if not. Use it with `if`.
<details><summary>Solution</summary>

```bash
#!/bin/bash

file_exists() {
  local path="$1"
  [[ -f "$path" ]]
}

if file_exists "/etc/passwd"; then
  echo "File found"
else
  echo "File not found"
fi
```

> Functions return exit codes, not values. Use `local` to prevent variable leaks into global scope.
</details>

**6.3** Refactor this messy script into functions. Add `set -euo pipefail` at the top.

```bash
#!/bin/bash
echo "Starting"
mkdir -p /tmp/deploy
cp /etc/hostname /tmp/deploy/
echo "Done"
```
<details><summary>Solution</summary>

```bash
#!/bin/bash
set -euo pipefail

DEPLOY_DIR="/tmp/deploy"

setup_dir() {
  mkdir -p "$DEPLOY_DIR"
}

copy_files() {
  cp /etc/hostname "$DEPLOY_DIR/"
}

main() {
  echo "[INFO] Starting"
  setup_dir
  copy_files
  echo "[INFO] Done"
}

main "$@"
```

> `set -euo pipefail` is the professional header: `-e` exits on error, `-u` errors on unset variables, `-o pipefail` catches failures in pipes. `main "$@"` passes all script args into main.
</details>

---

## Level 7 — Integration Challenge

> Write a complete, production-quality script from scratch. No copy-paste.

**The Challenge:** Write `check-services.sh` that:
1. Takes a list of services as arguments (`$@`)
2. Falls back to a default list `(nginx git docker)` if none given
3. For each service: check if it exists with `command -v`
4. Print `[OK]` or `[MISSING]` with the service name
5. At the end, print a summary: `X/Y services available`
6. Exit with code 1 if any service is missing

<details><summary>Solution</summary>

```bash
#!/bin/bash
set -euo pipefail

# --- Config
DEFAULT_SERVICES=(nginx git docker)

# --- Functions
log_info()  { echo "[INFO]  $*"; }
log_ok()    { echo "[OK]    $*"; }
log_miss()  { echo "[MISSING] $*"; }

check_service() {
  local svc="$1"
  if command -v "$svc" &>/dev/null; then
    log_ok "$svc"
    return 0
  else
    log_miss "$svc"
    return 1
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

  log_info "Checking ${total} services..."

  for svc in "${services[@]}"; do
    check_service "$svc" && (( ok++ )) || true
  done

  echo ""
  echo "${ok}/${total} services available"

  [[ $ok -eq $total ]]
}

main "$@"
```

> Run it: `bash check-services.sh` or `bash check-services.sh git curl node`
> Debug it: `bash -x check-services.sh`
> Lint it: `shellcheck check-services.sh`
</details>

---

## Quick Reference

```bash
# Header every script should have
#!/bin/bash
set -euo pipefail

# Variables
name="value"             # no spaces around =
echo "$name"             # always quote
echo "${name}suffix"     # braces for boundary
result=$(command)        # command substitution

# Arguments
$0   # script name
$1   # first arg
$#   # arg count
$@   # all args (quoted separately)

# Default values
${var:-default}          # use default if var unset/empty

# Parameter expansion (no subprocesses!)
${#var}                  # string length
${var##*/}               # basename (remove longest prefix up to /)
${var%/*}                # dirname (remove shortest suffix from /)
${var##*.}               # extension (remove longest prefix up to .)
${var%%.*}               # base name without any extension
${var/old/new}           # replace first match
${var//old/new}          # replace all matches
${var^^}                 # uppercase
${var,,}                 # lowercase

# Tests — always [[ ]], never [ ]
[[ -f "$f" ]]            # is a file
[[ -d "$d" ]]            # is a directory
[[ -z "$s" ]]            # string is empty
[[ -n "$s" ]]            # string is not empty
[[ $a -eq $b ]]          # numbers equal
[[ $a -gt $b ]]          # greater than
[[ "$s" == "val" ]]      # string match

# Loops
for item in "${arr[@]}"; do ... done   # array
for f in *.sh; do ... done             # glob (not ls!)
while read -r line; do ... done < file # file line by line

# Functions
my_func() {
  local var="$1"   # local scope
  echo "$var"      # return data via echo
}                  # return exit code implicitly

# Exit codes
exit 0    # success
exit 1    # failure
$?        # last exit code
cmd && echo ok || echo fail

# Debug
bash -x script.sh     # trace all commands
set -x / set +x       # toggle inside script
shellcheck script.sh  # lint before running
```
