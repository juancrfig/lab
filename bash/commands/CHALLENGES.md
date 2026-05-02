# Commands Practice

Left pane: this file. Right pane: terminal in `practice/`.
No peeking at SOLUTIONS.md until you've run your own answer.

---

## Block 1 — `find`

1. How many files are in `practice/` total?
2. List every `.log` file and its size.
3. Which scripts inside `scripts/` contain the word `ERROR`?
4. Find the 3 largest files under `practice/`.
5. Find all `.env` and `.conf` files under `configs/`.

---

## Block 2 — `grep`

1. How many ERROR lines are in `app.log`?
2. Show all 500 status lines from `nginx-access.log`.
3. Search all log files for the word `timeout`. Show filenames and line numbers.
4. Find any line across all `practice/` mentioning a password, secret, or JWT.
5. From `deploy.log`, show only lines related to the failed deployment v1.4.0.

---

## Block 3 — Pipes & Streams

1. Count requests per IP in `nginx-access.log`, sorted most to least.
2. List all unique HTTP status codes in `nginx-access.log`.
3. Lock `locked.log` so it can't be read.
   Run grep recursively across all of `logs/` searching for `[ERROR]`, redirect matches to `/tmp/errors.txt`.
4. Count log entries per level (INFO, WARN, ERROR) in `app.log`.
5. Show lines that returned 4xx or 5xx in `nginx-access.log`.

--

## Block 4 — `cut` / `uniq` / `tr` / `xargs`

1. Extract only usernames from `users.tsv` (skip header).
2. List all unique regions from `sales.csv`.
<<<<<<< HEAD
3. Which product appears most in `sales.csv`?
4. Extract all variable names from `app.env` (skip comments, skip values).
   Run it once to get the names as-is.
   Then pipe to `tr` to lowercase them.
   Compare both outputs — that's what `tr` does.
5. Convert `sales.csv` commas to pipes `|`, preview first 5 rows.
6. For each `.env` file, print its name and how many variables it defines.
=======

---

## Block 5 — Permissions

1. Check permissions on both scripts in `scripts/`.
2. Make both scripts executable. Verify.
3. Lock down all `.env` files — owner read/write only. Verify.
4. Prove permissions work: create a file, lock it to `600`, try to read it as another user.
5. Find any world-writable files under `practice/`.

---

## Block 6 — `journalctl`

1. Show last 20 journal entries, newest first.
2. How many error-level events since last boot?
3. Show SSH logs filtered for failed login attempts.
4. Top 5 most repeated error messages since last boot.
5. Watch live logs, show only lines with `error` or `fail`.
6. Save the last hour's errors to a timestamped file.

---

## Block 7 — Processes & Memory

1. How many processes are running right now?
2. Which process uses the most memory?
3. When was the system last booted?
4. How much memory is available?
5. One-liner: print processes count, top RAM user, last boot, memory summary.
