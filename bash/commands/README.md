# Bash Commands — Morning Practice

> One block per day ≈ 5–7 min. Full run ≈ 30 min.
> All exercises use files from `practice/` or live system files — no setup needed.

```
practice/
├── logs/
│   ├── app.log           ← [INFO/WARN/ERROR] structured app logs
│   ├── nginx-access.log  ← IP, method, status code, bytes
│   └── deploy.log        ← multi-deployment history
├── data/
│   ├── sales.csv         ← date, region, product, units, revenue
│   └── users.tsv         ← id, username, email, role, status
├── configs/
│   ├── app.env           ← production env vars
│   ├── staging.env       ← staging env vars
│   └── nginx.conf        ← nginx server block
├── scripts/
│   ├── deploy.sh
│   └── backup.sh
└── docs/
    ├── report-q1.md
    ├── report-q2.md
    └── notes.txt
```

---

## Block 1 — `find`

**1.1** How many files are in `practice/` in total?
<details><summary>Solution</summary>

```bash
find practice/ -type f | wc -l
```
</details>

**1.2** List every `.log` file and show its size.
<details><summary>Solution</summary>

```bash
find practice/ -name "*.log" | xargs du -sh
```
</details>

**1.3** Which scripts contain the word `ERROR`?
<details><summary>Solution</summary>

```bash
find practice/scripts/ -name "*.sh" | xargs grep -l "ERROR"
```

> `xargs grep -l` prints only the filenames, not the matching lines. `-l` = "list files".
</details>

**1.4** Find the 3 largest files anywhere under `practice/`.
<details><summary>Solution</summary>

```bash
find practice/ -type f | xargs du -sh | sort -rh | head -3
```

> `sort -rh`: `-r` = reverse (largest first), `-h` = human-readable sizes (10K < 1M < 1G).
</details>

**1.5** Find all config files (`.env` or `.conf`) and print their paths.
<details><summary>Solution</summary>

```bash
find practice/configs/ -type f \( -name "*.env" -o -name "*.conf" \)
```

> The `\( ... \)` groups the OR condition. Without grouping, `-o` has lower precedence than the implicit AND and gives wrong results.
</details>

---

## Block 2 — `grep`

**2.1** How many ERROR lines are in `app.log`?
<details><summary>Solution</summary>

```bash
grep -c "\[ERROR\]" practice/logs/app.log
```

> `-c` counts matching lines directly. Faster than piping to `wc -l`.
</details>

**2.2** Show all 500 status responses from the nginx access log.
<details><summary>Solution</summary>

```bash
grep ' 500 ' practice/logs/nginx-access.log
```

> The spaces around `500` prevent false matches on things like `5000` or `/path/500items`.
</details>

**2.3** Search all log files at once for the word `timeout`.
<details><summary>Solution</summary>

```bash
grep -rn "timeout" practice/logs/
```

> `-r` = recursive through directory. `-n` = show line numbers. Always use `-n` when debugging — you want to know *where* it appeared.
</details>

**2.4** Find any line across all `practice/` files that mentions a password or secret.
<details><summary>Solution</summary>

```bash
grep -ri "password\|secret\|jwt" practice/
```

> This is a real DevOps habit — audit your repo for accidental secret exposure before pushing.
> `-i` = case-insensitive. `\|` = OR in basic regex. Use `-E` with `|` if you prefer extended regex:
> ```bash
> grep -riE "password|secret|jwt" practice/
> ```
</details>

**2.5** From `deploy.log`, show only lines from the failed deployment (v1.4.0).
<details><summary>Solution</summary>

```bash
grep -E "v1\.4\.0|ERROR|aborted" practice/logs/deploy.log
```

> `-E` enables extended regex so `|` works without backslash. Dots in version numbers should be escaped (`\.`) to match literal dots.
</details>

---

## Block 3 — Pipes & Streams

> `stdin` fd 0 | `stdout` fd 1 | `stderr` fd 2

**3.1** Count how many requests each IP address made in the nginx log, sorted by most requests.
<details><summary>Solution</summary>

```bash
cut -d' ' -f1 practice/logs/nginx-access.log | sort | uniq -c | sort -rn
```

> Pipeline breakdown:
> 1. `cut -d' ' -f1` — extract field 1 (IP), space-delimited
> 2. `sort` — `uniq` requires sorted input
> 3. `uniq -c` — count consecutive identical lines
> 4. `sort -rn` — sort numerically, largest first
</details>

**3.2** List all unique HTTP status codes seen in the nginx log.
<details><summary>Solution</summary>

```bash
grep -oE ' [0-9]{3} ' practice/logs/nginx-access.log | tr -d ' ' | sort -u
```

> `-o` prints only the matched part (not the full line). `-E` enables extended regex.
> `tr -d ' '` strips the surrounding spaces from each match.
> `sort -u` = sort and deduplicate in one step.
</details>

**3.3** Save all ERROR lines from `app.log` to a file. Discard any grep stderr (e.g. permission errors).
<details><summary>Solution</summary>

```bash
grep "\[ERROR\]" practice/logs/app.log > /tmp/errors.txt 2>/dev/null
cat /tmp/errors.txt
```

> `> file` redirects stdout. `2>/dev/null` discards stderr. They are independent streams.
> In DevOps scripts you often want: `cmd >> /var/log/myapp.log 2>&1` to append both streams to one log file.
</details>

**3.4** Count log entries per severity level (INFO, WARN, ERROR).
<details><summary>Solution</summary>

```bash
grep -oE '\[(INFO|WARN|ERROR)\]' practice/logs/app.log | sort | uniq -c
```

> `-o` + a capturing group extracts just the `[LEVEL]` tag from each line, then counts them.
</details>

**3.5** Show unique endpoints that returned a 4xx or 5xx error in the nginx log.
<details><summary>Solution</summary>

```bash
grep -E ' [45][0-9]{2} ' practice/logs/nginx-access.log \
  | grep -oE '"(GET|POST|PUT|DELETE|PATCH) [^ ]+' \
  | sort -u
```

> Two-stage pipeline: first filter to error-status lines, then extract the method+path.
> `sort -u` deduplicates so each failing endpoint appears once.
</details>

---

## Block 4 — `cut` / `uniq` / `tr` / `xargs`

**4.1 `cut`** — Extract just the usernames from `users.tsv` (skip the header row).
<details><summary>Solution</summary>

```bash
tail -n +2 practice/data/users.tsv | cut -f2
```

> `tail -n +2` starts output from line 2 (skips header). `cut -f2` gets field 2, tab-delimited by default.
</details>

**4.2 `cut`** — List all unique regions from `sales.csv`.
<details><summary>Solution</summary>

```bash
tail -n +2 practice/data/sales.csv | cut -d, -f2 | sort -u
```

> `-d,` sets comma as delimiter. `-f2` = second field. `sort -u` = sort + deduplicate.
</details>

**4.3 `uniq`** — Which product appears most often in `sales.csv`?
<details><summary>Solution</summary>

```bash
tail -n +2 practice/data/sales.csv | cut -d, -f3 | sort | uniq -c | sort -rn | head -1
```

> `uniq -c` requires sorted input — always `sort` first.
> `sort -rn` puts highest count first. `head -1` = top result.
</details>

**4.4 `tr`** — Print all env variable names from `app.env` in lowercase.
<details><summary>Solution</summary>

```bash
grep -v '^#' practice/configs/app.env | grep '=' | cut -d= -f1 | tr '[:upper:]' '[:lower:]'
```

> `grep -v '^#'` removes comment lines. `grep '='` keeps only variable assignments.
> `cut -d= -f1` extracts the name. `tr '[:upper:]' '[:lower:]'` lowercases.
> Note: this is a command-line pipeline — `tr` here is appropriate. In a *script*, use `${var,,}` instead.
</details>

**4.5 `tr`** — Convert `sales.csv` commas to pipes `|` and preview the first 5 rows.
<details><summary>Solution</summary>

```bash
tr ',' '|' < practice/data/sales.csv | head -5
```

> Prefer `tr ',' '|' < file` over `cat file | tr ',' '|'` — one fewer process, same result.
> (The `cat | cmd` pattern is called a UUOC — Useless Use of Cat.)
</details>

**4.6 `xargs`** — For each `.env` file, print its filename and count how many variables it defines.
<details><summary>Solution</summary>

```bash
find practice/configs/ -name "*.env" | xargs -I{} sh -c 'echo "{}:"; grep -vc "^#" {}'
```

> `xargs -I{}` replaces `{}` with each filename. `-I` runs one command per input line.
> `grep -vc "^#"` counts lines that are NOT comments (`-v` inverts, `-c` counts).
</details>

---

## Block 5 — Permissions

```
-rwxr-xr--  =  owner:rwx  group:r-x  other:r--

Octal  Perms    Common use
  7    rwx      Scripts, directories
  6    rw-      Config files
  5    r-x      Group/other execute
  4    r--      Read-only
  0    ---      No access

600  rw-------  SSH private keys, .env secrets
644  rw-r--r--  Public config files, web assets
755  rwxr-xr-x  Scripts, directories
```

**5.1** Check the current permissions on both scripts in `practice/scripts/`.
<details><summary>Solution</summary>

```bash
ls -l practice/scripts/
```

> Look at the first column. If the 4th character is `-`, the script is not executable.
> Without `x`, running `./deploy.sh` gives `Permission denied`.
</details>

**5.2** Make both scripts executable, then verify.
<details><summary>Solution</summary>

```bash
chmod 755 practice/scripts/*.sh
ls -l practice/scripts/
```

> `755` = owner can read/write/execute, group and others can read/execute.
> This is the standard permission for scripts that should run but not be modified by others.
</details>

**5.3** Lock down the `.env` files so only the owner can read them.
<details><summary>Solution</summary>

```bash
chmod 600 practice/configs/*.env
ls -l practice/configs/
```

> `600` = owner read/write only. Group and others: no access.
> **Production rule:** `.env` files must always be `600`. If you set `644`, every user on the system can read your database password.
</details>

**5.4** The Mentor's Challenge — prove that permissions actually enforce access.
<details><summary>Solution</summary>

```bash
sudo useradd -m alice
echo "top secret" > /tmp/private.txt

chmod 600 /tmp/private.txt
sudo -u alice cat /tmp/private.txt   # Permission denied

chmod 644 /tmp/private.txt
sudo -u alice cat /tmp/private.txt   # top secret

rm /tmp/private.txt
sudo userdel -r alice
grep alice /etc/passwd               # empty = cleaned up
```

> This is the best way to internalize permissions — don't just memorize the numbers, *see* them enforce access.
</details>

**5.5** Find any world-writable files under `practice/`.
<details><summary>Solution</summary>

```bash
find practice/ -type f -perm /o+w
```

> `/o+w` = "other has write bit set". World-writable files are a security risk on shared systems.
> In CI/CD hardening audits, this check is standard.
</details>

---

## Block 6 — `journalctl` + grep + pipes

> `journalctl` is the systemd log reader — the modern replacement for manually hunting through `/var/log/`.

```
journalctl -r                      # newest first
journalctl -f                      # follow (live tail)
journalctl -n 50                   # last 50 lines
journalctl -u nginx                # one service only
journalctl -p err                  # by priority (emerg/alert/crit/err/warning/notice/info/debug)
journalctl -b                      # since last boot
journalctl --since "1 hour ago"    # time filter
journalctl -o cat                  # message only, no metadata
```

**6.1** Show the last 20 journal entries, newest first.
<details><summary>Solution</summary>

```bash
journalctl -rn 20
```
</details>

**6.2** How many error-level events happened since last boot?
<details><summary>Solution</summary>

```bash
journalctl -b -p err | wc -l
```

> `-b` = since last boot. `-p err` = priority err and above (err, crit, alert, emerg).
</details>

**6.3** Show SSH logs filtered for failed login attempts.
<details><summary>Solution</summary>

```bash
journalctl -u ssh | grep -i "failed"
# On some systems the service is named sshd:
journalctl -u sshd | grep -i "failed"
```
</details>

**6.4** Top 5 most repeated error messages since last boot.
<details><summary>Solution</summary>

```bash
journalctl -b -p err -o cat | sort | uniq -c | sort -rn | head -5
```

> `-o cat` strips metadata so `uniq -c` groups by message content only.
</details>

**6.5** Watch live logs, show only lines containing `error` or `fail`.
<details><summary>Solution</summary>

```bash
journalctl -f | grep -i -E "error|fail"
```
</details>

**6.6** Save the last hour's errors to a timestamped file.
<details><summary>Solution</summary>

```bash
journalctl --since "1 hour ago" -p err > ~/errors_$(date +%Y%m%d_%H%M).txt
```

> `$(date +%Y%m%d_%H%M)` embeds the timestamp directly in the filename. Useful for log rotation scripts.
</details>

---

## Block 7 — Processes, Memory & Uptime

**7.1** How many processes are currently running?
<details><summary>Solution</summary>

```bash
ps aux | tail -n +2 | wc -l
```

> `tail -n +2` skips the header row so it isn't counted.
</details>

**7.2** Which process is consuming the most memory?
<details><summary>Solution</summary>

```bash
ps aux --sort=-%mem | head -6
```

> `--sort=-%mem` sorts by memory descending. `head -6` = header + top 5 processes.
> Interactive alternative: `htop`, press `M` to sort by memory.
</details>

**7.3** When was the system last booted?
<details><summary>Solution</summary>

```bash
uptime -s
# Full boot history:
last reboot | head -5
```
</details>

**7.4** How much memory is available right now?
<details><summary>Solution</summary>

```bash
free -h
```

> Read the `available` column, not `free`. Available = free + reclaimable cache. Linux uses spare RAM for disk cache — that's normal, not a memory leak.
</details>

**7.5** One-liner morning health check — processes, top memory user, last boot, memory.
<details><summary>Solution</summary>

```bash
echo "── Processes ──" && ps aux | tail -n +2 | wc -l && \
echo "── Top RAM ────" && ps aux --sort=-%mem | head -4 && \
echo "── Last Boot ──" && uptime -s && \
echo "── Memory ─────" && free -h
```
</details>

---

## Cheat Sheet

```bash
# ── find ─────────────────────────────────────────────────
find . -type f | wc -l
find . -name "*.ext" | xargs du -sh | sort -rh | head -5
find . \( -name "*.env" -o -name "*.conf" \)
find . -type f -perm /o+w                        # world-writable files

# ── grep ─────────────────────────────────────────────────
grep -c "pattern" file                           # count matches
grep -rn "pattern" dir/                          # recursive + line numbers
grep -E "pat1|pat2" file                         # OR (extended regex)
grep -v "^#" file | grep "="                     # non-comment assignment lines
grep -oE ' [0-9]{3} ' file | tr -d ' ' | sort -u  # extract & deduplicate numbers

# ── streams ──────────────────────────────────────────────
cmd > out.txt              # stdout to file (overwrite)
cmd >> out.txt             # stdout to file (append)
cmd 2>/dev/null            # discard stderr
cmd > all.txt 2>&1         # stdout + stderr to same file
cmd1 | cmd2                # pipe stdout of cmd1 to stdin of cmd2

# ── cut / uniq / tr / xargs ──────────────────────────────
tail -n +2 file.csv | cut -d, -f2               # skip header, get field 2
cut -d' ' -f1 file | sort | uniq -c | sort -rn  # count occurrences
tr ',' '|' < file                               # replace delimiter (no cat needed)
find . -name "*.sh" | xargs -I{} sh -c 'wc -l {}'

# ── permissions ──────────────────────────────────────────
chmod 600 *.env           # lock down secrets (owner only)
chmod 755 *.sh            # make scripts executable
find . -perm /o+w         # find world-writable
ls -l                     # inspect permissions

# ── journalctl ───────────────────────────────────────────
journalctl -rn 50
journalctl -b -p err -o cat | sort | uniq -c | sort -rn | head -5
journalctl -f | grep -iE "error|fail"

# ── processes / memory ───────────────────────────────────
ps aux --sort=-%mem | head -6
uptime -s && free -h
```
