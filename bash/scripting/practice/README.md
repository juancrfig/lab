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

# Debug mode — shows every command as it executes
bash -x challenge.sh
```

> **shellcheck** is your linter. Install: `sudo apt install shellcheck` or `brew install shellcheck`.
> **bash -x** traces every command. Add `set -x` / `set +x` inside a script to debug just one section.

---

## Level 1 — Variables & Quotes

> Topics: assignment, access, single vs double quotes, command substitution

**1.1** Write a script that stores your name, today's date, and the current hostname into variables, then prints them one per line.
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

> `$(command)` captures stdout of a command into a variable. No spaces around `=` — ever.
</details>

**1.2** Predict the output of these two lines *before* running them. Then run them and verify.

```bash
user="Juanes"
echo "Hello $user"
echo 'Hello $user'
```
<details><summary>Solution</summary>

```
Hello Juanes   ← double quotes: variables expand
Hello $user    ← single quotes: everything is literal, no expansion
```

> **Rule:** use double quotes almost always. Use single quotes only when you need a literal string with zero expansion.
</details>

**1.3** This script has two bugs. Find and fix both before running it.

```bash
#!/bin/bash
greeting = "Hello"
echo $greeting
```
<details><summary>Solution</summary>

```bash
#!/bin/bash
greeting="Hello"   # Bug 1: spaces around = make bash treat 'greeting' as a command
echo "$greeting"   # Bug 2: unquoted $var is vulnerable to word splitting
```

> These are the two most common beginner mistakes. Burn them into memory:
> 1. No spaces around `=`
> 2. Always quote `"$variable"`
</details>

---

## Level 2 — Arguments & Debug Mode

> Topics: `$1`, `$#`, `$@`, `$0`, `bash -x`, `shellcheck`

**2.1** Write `greet.sh`. It takes a name as `$1` and prints `Hello, <name>!`. If called with no argument, print a usage message and exit with code 1.
<details><summary>Solution</summary>

```bash
#!/bin/bash

if [[ $# -eq 0 ]]; then
  echo "Usage: $0 <name>"
  exit 1
fi

echo "Hello, $1!"
```

> `$#` = argument count. `$0` = the script's own name. `exit 1` = signal failure to the caller.
</details>

**2.2** Write a script that prints each argument on a separate line, prefixed with its position number.

```
# bash script.sh alpha beta gamma
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

> **`"$@"` vs `$*`:**
> - `"$@"` → each argument stays as its own quoted word: `"alpha"` `"beta"` `"gamma"`
> - `"$*"` → all arguments collapse into one string: `"alpha beta gamma"`
> Use `"$@"` whenever you loop over arguments. `$*` breaks if any argument contains spaces.
</details>

**2.3** Run `greet.sh` with `bash -x` and read the trace. Then add `set -x` halfway through any script to debug only that section, and `set +x` to turn it off.
<details><summary>What to look for</summary>

```bash
bash -x greet.sh Juanes
# + [[ 1 -eq 0 ]]        ← condition evaluated
# + echo 'Hello, Juanes!'
# Hello, Juanes!
```

> Every line prefixed with `+` is the fully expanded command bash ran. This is how you catch bugs where a variable contains something unexpected.
>
> Inside a script:
> ```bash
> set -x   # start tracing here
> some_command
> set +x   # stop tracing
> ```
</details>

---

## Level 3 — Parameter Expansion

> Your mentor's core lesson: **stop spawning subprocesses. Do it inside bash.**
>
> Every `sed`, `awk`, `cut`, or `tr` call inside a script spawns a new process.
> In a loop over 1000 files that's 1000 subprocesses. Parameter expansion is instant — it's built into bash.

**3.1** Without using `sed`, `cut`, or `awk` — extract all four parts of this path using only parameter expansion.

```bash
filepath="/home/juanes/reports/summary.tar.gz"
# Expected:
# filename:  summary.tar.gz
# directory: /home/juanes/reports
# extension: gz
# basename:  summary
```
<details><summary>Solution</summary>

```bash
#!/bin/bash
filepath="/home/juanes/reports/summary.tar.gz"

filename="${filepath##*/}"    # summary.tar.gz  — remove longest prefix up to last /
directory="${filepath%/*}"    # /home/juanes/reports — remove shortest suffix from last /
extension="${filename##*.}"   # gz              — remove longest prefix up to last .
basename="${filename%%.*}"    # summary         — remove longest suffix from first .

echo "filename:  $filename"
echo "directory: $directory"
echo "extension: $extension"
echo "basename:  $basename"
```

> **Memory aid — look at your keyboard:**
> `#` is **left** of `$` → removes from the **left** (strips a prefix)
> `%` is **right** of `$` → removes from the **right** (strips a suffix)
> Single `#` or `%` → shortest match
> Double `##` or `%%` → longest match
</details>

**3.2** Write `deploy.sh`. It takes an environment as `$1` and reads `LOG_LEVEL` from the environment. Both should have safe defaults — no `if` statement allowed.
<details><summary>Solution</summary>

```bash
#!/bin/bash
env_name="${1:-staging}"
log_level="${LOG_LEVEL:-info}"

echo "Deploying to: $env_name (log level: $log_level)"
```

> `${var:-default}` is the professional pattern for missing args. Clean, readable, no boilerplate.
> Test it:
> ```bash
> bash deploy.sh              # staging / info
> bash deploy.sh production   # production / info
> LOG_LEVEL=debug bash deploy.sh production  # production / debug
> ```
</details>

**3.3** Validate a password passed as `$1`. Reject it if shorter than 8 characters. Use `${#var}` — not `wc`.
<details><summary>Solution</summary>

```bash
#!/bin/bash
password="${1:-}"

if [[ -z "$password" ]]; then
  echo "Usage: $0 <password>"
  exit 1
fi

if [[ ${#password} -lt 8 ]]; then
  echo "Error: password too short (${#password} chars, minimum 8)"
  exit 1
fi

echo "OK: password length is ${#password}"
```

> `${1:-}` sets an empty string as default (not `''` — that would make the default literally two single-quote characters).
> `${#var}` gives the string length. No subprocess, no pipe.
</details>

**3.4** Replace all spaces in a string with underscores, then uppercase everything — without `tr` or `sed`.
<details><summary>Solution</summary>

```bash
#!/bin/bash
text="hello world from bash"
no_spaces="${text// /_}"
upper="${no_spaces^^}"

echo "$upper"   # HELLO_WORLD_FROM_BASH
```

> `${var// /replacement}` replaces **all** matches (single `/` = first match only).
> `${var^^}` uppercases all. `${var,,}` lowercases all.
> No `tr`, no subprocess.
</details>

---

## Level 4 — Conditionals & Exit Codes

> Topics: `[[ ]]`, file tests, `-z/-n`, `&&`, `||`, `$?`, `case`

**4.1** Write a script that takes a file path as `$1` and validates it step by step: argument given → file exists → file is readable. Exit 1 with a clear message at the first failure.
<details><summary>Solution</summary>

```bash
#!/bin/bash
file="${1:-}"

if [[ -z "$file" ]]; then
  echo "Usage: $0 <file>"
  exit 1
fi

if [[ ! -f "$file" ]]; then
  echo "Error: '$file' does not exist or is not a regular file"
  exit 1
fi

if [[ ! -r "$file" ]]; then
  echo "Error: '$file' exists but is not readable"
  exit 1
fi

echo "OK: '$file' exists and is readable"
```

> **Always use `[[ ]]`, never `[ ]`.** Double brackets are bash-native: safer quoting, no word splitting, supports `==`, `!=`, `=~`, `&&`, `||` inside the test.
</details>

**4.2** Write a `case` statement that selects config based on the environment arg: `production`, `staging`, `dev`, or exit on unknown.
<details><summary>Solution</summary>

```bash
#!/bin/bash
env_name="${1:-dev}"

case "$env_name" in
  production)
    echo "[PROD] Full logging, alerts on, no debug output"
    ;;
  staging)
    echo "[STAGING] Verbose logging, errors to Slack"
    ;;
  dev)
    echo "[DEV] Debug mode on, local database"
    ;;
  *)
    echo "Error: unknown environment '$env_name'"
    echo "Valid options: production, staging, dev"
    exit 1
    ;;
esac
```

> `case` beats a chain of `if/elif` when matching one variable against known values — cleaner and faster to read.
</details>

**4.3** Three ways to handle exit codes — write a script that demonstrates all three patterns.
<details><summary>Solution</summary>

```bash
#!/bin/bash

# Pattern 1: check $? explicitly (verbose, clear)
ls /etc/passwd > /dev/null
if [[ $? -eq 0 ]]; then
  echo "1. Command succeeded"
fi

# Pattern 2: inline with && / || (concise)
ls /nonexistent 2>/dev/null && echo "2. Found" || echo "2. Not found"

# Pattern 3: abort on failure with a message (production pattern)
mkdir -p /tmp/myapp && echo "3. Dir ready" || { echo "3. Failed to create dir"; exit 1; }
```

> **When to use each:**
> - `$?` → when you need the actual code value or complex logic
> - `&&` / `||` → quick inline checks in scripts
> - `|| { ...; exit 1; }` → bail out with a message on critical failures
>
> `{ cmd; exit 1; }` is a **command group** — the braces run both commands when the left side fails.
</details>

---

## Level 5 — Loops

> Topics: `for`, `while`, `read -r`, `break`, `continue`, file globs

**5.1** Loop over an array of service names and check whether each binary is installed.
<details><summary>Solution</summary>

```bash
#!/bin/bash
services=(nginx git docker kubectl node)

for svc in "${services[@]}"; do
  if command -v "$svc" &>/dev/null; then
    echo "[OK]      $svc"
  else
    echo "[MISSING] $svc"
  fi
done
```

> `command -v` is the correct way to test for a binary. Not `which` (not POSIX), not `type` (verbose).
> `"${arr[@]}"` — always quote array expansions to handle elements with spaces.
</details>

**5.2** Read `/etc/shells` line by line and print only lines that don't start with `#`.
<details><summary>Solution</summary>

```bash
#!/bin/bash

while read -r line; do
  [[ "$line" == "#"* ]] && continue
  [[ -z "$line" ]] && continue
  echo "$line"
done < /etc/shells
```

> **Always `read -r`** — without `-r`, a backslash at end of line merges it with the next line.
> `< file` redirects the file into the loop as stdin — this is faster and more correct than `cat file | while read`.
</details>

**5.3** Loop over all `.sh` files in `../scripts/` using a glob (never `ls`) and print each filename with its line count.
<details><summary>Solution</summary>

```bash
#!/bin/bash

for script in ../scripts/*.sh; do
  [[ -f "$script" ]] || continue       # guard: skip if glob matched nothing
  lines=$(wc -l < "$script")
  echo "${script##*/}: $lines lines"   # ##*/ strips the path, leaving just the filename
done
```

> **Never `$(ls *.sh)`** — breaks on filenames with spaces and is slower.
> Globs are expanded by bash itself, safe and instant.
> The `[[ -f ]] || continue` guard handles the edge case where no `.sh` files exist (glob returns literal `*.sh`).
</details>

---

## Level 6 — Functions

> Topics: defining functions, `local`, return values (exit codes vs echo), `set -euo pipefail`

**6.1** Write `log_info` and `log_error` functions that prefix messages with `[INFO]`/`[ERROR]` and a timestamp. `log_error` should write to stderr.
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

> `$*` inside a function = all arguments passed to it, as one string. Fine here since we're just printing.
> `>&2` sends output to stderr — errors go to stderr, normal output goes to stdout. This matters when piping.
</details>

**6.2** Write a `file_exists` function that returns exit code 0 if a file exists, 1 if not. Compose it with `if`.
<details><summary>Solution</summary>

```bash
#!/bin/bash

file_exists() {
  local path="$1"
  [[ -f "$path" ]]   # last command's exit code becomes the function's exit code
}

if file_exists "/etc/passwd"; then
  echo "File found"
else
  echo "File not found"
fi
```

> **Functions have two ways to return data:**
> 1. **Exit code** (0/1) — for pass/fail decisions, used with `if`/`&&`/`||`
> 2. **Echo** — for returning a string value, captured with `result=$(my_func)`
>
> `local` keeps the variable inside the function. Without it, `path` would leak into global scope.
</details>

**6.3** Refactor this flat script into functions with proper structure. Add `set -euo pipefail`.

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
SOURCE_FILE="/etc/hostname"   # safe to copy — readable by all users

log_info() { echo "[INFO] $*"; }

setup_dir() {
  mkdir -p "$DEPLOY_DIR"
  log_info "Directory ready: $DEPLOY_DIR"
}

copy_files() {
  cp "$SOURCE_FILE" "$DEPLOY_DIR/"
  log_info "Copied $SOURCE_FILE"
}

main() {
  log_info "Starting"
  setup_dir
  copy_files
  log_info "Done"
}

main "$@"
```

> **`set -euo pipefail` explained:**
> - `-e` — exit immediately if any command fails (non-zero exit code)
> - `-u` — treat unset variables as errors (catches typos like `$DEPOY_DIR`)
> - `-o pipefail` — catch failures inside pipes (`false | true` would otherwise succeed)
>
> **`main "$@"`** — always call main with all script arguments so the function can use `$1`, `$2`, etc.
> This is the standard structure for any non-trivial bash script.
</details>

---

## Level 7 — Integration Challenge

> Write a complete, production-quality script from scratch. No copy-paste. No looking at previous levels.
> When done: run `shellcheck` on it, then run it with `bash -x`.

**The Challenge:** Write `check-services.sh` that:
1. Takes a list of services as arguments — falls back to `(nginx git docker)` if none given
2. For each service, check with `command -v` — print `[OK]` or `[MISSING]`
3. At the end, print a summary line: `X/Y services available`
4. Exit 1 if any service is missing, exit 0 if all found

<details><summary>Solution</summary>

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

  log_info "Checking $total services..."
  echo ""

  for svc in "${services[@]}"; do
    check_service "$svc" && (( ok++ )) || true
    # '|| true' prevents -e from aborting when check_service returns 1
  done

  echo ""
  echo "${ok}/${total} services available"

  [[ $ok -eq $total ]]   # exit 0 if all found, exit 1 if any missing
}

main "$@"
```

> Test it:
> ```bash
> bash check-services.sh                    # uses defaults
> bash check-services.sh git curl vim       # custom list
> bash -x check-services.sh git             # debug trace
> shellcheck check-services.sh             # lint
> echo $?                                   # check exit code
> ```
</details>

---

## Quick Reference

```bash
# Every script should start with:
#!/bin/bash
set -euo pipefail

# ── Variables ────────────────────────────────────────────
name="value"             # no spaces around =
echo "$name"             # always quote
echo "${name}suffix"     # braces = explicit boundary
result=$(command)        # capture command output

# ── Arguments ────────────────────────────────────────────
$0   # script name
$1   # first argument
$#   # argument count
$@   # all arguments as separate words (always quote: "$@")

# ── Default values ───────────────────────────────────────
${var:-default}          # use default if var is unset or empty
${var:=default}          # use AND assign default if unset

# ── Parameter expansion (no subprocesses!) ───────────────
${#var}                  # string length
${var##*/}               # basename  (longest prefix to last /)
${var%/*}                # dirname   (shortest suffix from last /)
${var##*.}               # extension (longest prefix to last .)
${var%%.*}               # stem      (longest suffix from first .)
${var/old/new}           # replace first match
${var//old/new}          # replace all matches
${var^^}                 # uppercase all
${var,,}                 # lowercase all

# ── Tests — always [[ ]], never [ ] ──────────────────────
[[ -f "$f" ]]            # is a regular file
[[ -d "$d" ]]            # is a directory
[[ -r "$f" ]]            # is readable
[[ -x "$f" ]]            # is executable
[[ -z "$s" ]]            # string is empty
[[ -n "$s" ]]            # string is not empty
[[ $a -eq $b ]]          # numbers equal
[[ $a -gt $b ]]          # greater than
[[ "$s" == "val" ]]      # string equality
[[ "$s" =~ ^[0-9]+$ ]]  # regex match

# ── Loops ────────────────────────────────────────────────
for item in "${arr[@]}"; do ... done     # array (quoted!)
for f in *.sh; do ... done               # glob — never $(ls)
while read -r line; do ... done < file   # file line by line

# ── Functions ────────────────────────────────────────────
my_func() {
  local var="$1"         # local = stays inside function
  echo "$var"            # return a value: capture with $(...)
  return 0               # return an exit code: use with if/&&
}

# ── Exit codes ───────────────────────────────────────────
exit 0                        # success
exit 1                        # failure
$?                            # exit code of last command
cmd && echo ok || echo fail   # inline success/failure
cmd || { echo "fail"; exit 1; }  # abort with message

# ── Debug ────────────────────────────────────────────────
bash -x script.sh    # trace all commands
set -x               # start trace inside script
set +x               # stop trace
shellcheck script.sh # lint — run before every commit
```
