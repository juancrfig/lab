# Scripting Practice

Left pane: this file. Right pane: editor + terminal.
Write every script from scratch. No copy-paste.
Run `shellcheck script.sh` before executing. Use `bash -x script.sh` to debug.

---

## L1 — Variables & Quotes

1. Store your name, today's date, and hostname in variables. Print them one per line.
2. Predict the output of these two lines before running:
   ```bash
   user="Juanes"
   echo "Hello $user"
   echo 'Hello $user'
   ```
3. This script has 2 bugs. Find and fix both:
   ```bash
   #!/bin/bash
   greeting = "Hello"
   echo $greeting
   ```

---

## L2 — Arguments & Debug

1. Write `greet.sh`. Takes `$1` as name, prints `Hello, <name>!`. No arg → print usage and exit 1.
2. Write a script that prints each argument prefixed with its position:
   ```
   1: alpha
   2: beta
   ```
3. Run `greet.sh` with `bash -x`. Read the trace. Then use `set -x` / `set +x` to trace only one section inside a script.

---

## L3 — Parameter Expansion

> No `sed`, `awk`, `cut`, or `tr` allowed in these.

1. Extract filename, directory, extension, and basename from this path — using only parameter expansion:
   ```bash
   filepath="/home/juanes/reports/summary.tar.gz"
   ```
2. Write `deploy.sh`. Takes env as `$1`, reads `LOG_LEVEL` from environment. Both have safe defaults. No `if` allowed.
3. Validate a password passed as `$1`. Reject if shorter than 8 chars. Use `${#var}` — not `wc`.
4. Replace all spaces with underscores and uppercase everything — no `tr` or `sed`.

---

## L4 — Conditionals & Exit Codes

1. Script takes a file path as `$1`. Validate: arg given → file exists → file readable. Exit 1 with a clear message at first failure.
2. Write a `case` statement: takes env arg (`production` / `staging` / `dev`), prints config info. Unknown → exit 1.
3. Demonstrate all 3 exit code patterns in one script: `$?` check, inline `&&`/`||`, and abort with message using `|| { ...; exit 1; }`.

---

## L5 — Loops

1. Loop over `(nginx git docker kubectl node)`. For each, print `[OK]` or `[MISSING]` using `command -v`.
2. Read `/etc/shells` line by line. Print only non-comment, non-empty lines.
3. Loop over all `.sh` files in `../scripts/` using a glob (no `ls`). Print each filename and its line count.

---

## L6 — Functions

1. Write `log_info` and `log_error` functions. Prefix with `[INFO]`/`[ERROR]` + timestamp. Errors go to stderr.
2. Write `file_exists()` — returns exit code 0/1. Use it in an `if` statement.
3. Refactor this into functions with `set -euo pipefail`:
   ```bash
   #!/bin/bash
   echo "Starting"
   mkdir -p /tmp/deploy
   cp /etc/hostname /tmp/deploy/
   echo "Done"
   ```

---

## L7 — Integration Challenge

Write `check-services.sh` from scratch. No references.

- Takes service names as args — defaults to `(nginx git docker)` if none given
- For each: print `[OK]` or `[MISSING]`
- Print summary: `X/Y services available`
- Exit 1 if any missing, exit 0 if all found

When done:
```bash
shellcheck check-services.sh
bash -x check-services.sh git curl
echo $?
```
