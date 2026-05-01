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
</details>

**1.4** Find the 3 largest files anywhere under `practice/`.
<details><summary>Solution</summary>

```bash
find practice/ -type f | xargs du -sh | sort -rh | head -3
```
</details>

**1.5** Find all config files (`.env` or `.conf`) and print their paths.
<details><summary>Solution</summary>

```bash
find practice/configs/ -type f \( -name "*.env" -o -name "*.conf" \)
```
</details>

---

## Block 2 — `grep`

**2.1** How many ERROR lines are in `app.log`?
<details><summary>Solution</summary>

```bash
grep -c "\[ERROR\]" practice/logs/app.log
```
</details>

**2.2** Show all 500 status responses from the nginx access log.
<details><summary>Solution</summary>

```bash
grep '" 500 ' practice/logs/nginx-access.log
```
</details>

**2.3** Search all log files at once for the word `timeout`.
<details><summary>Solution</summary>

```bash
grep -r "timeout" practice/logs/
# With filename + line number:
grep -rn "timeout" practice/logs/
```
</details>

**2.4** Find any line across all `practice/` files that mentions a password or secret.
<details><summary>Solution</summary>

```bash
grep -ri "password\|secret\|jwt" practice/
```

> This is a real DevOps habit — auditing for accidental secret exposure.
</details>

**2.5** From `deploy.log`, show only the lines from the **failed** deployment (v1.4.0).
<details><summary>Solution</summary>

```bash
grep "v1.4.0\|ERROR\|aborted" practice/logs/deploy.log
```
</details>

---

## Block 3 — Pipes & Streams

> `stdin` fd 0 | `stdout` fd 1 | `stderr` fd 2

**3.1** Count how many requests each IP made in the nginx log.
<details><summary>Solution</summary>

```bash
cut -d' ' -f1 practice/logs/nginx-access.log | sort | uniq -c | sort -rn
```

> `cut -d' ' -f1` extracts the first field (IP). Then sort → uniq → sort by count.
</details>

**3.2** List all unique HTTP status codes seen in the nginx log.
<details><summary>Solution</summary>

```bash
grep -oE '" [0-9]{3} ' practice/logs/nginx-access.log | tr -d '" ' | sort | uniq
```
</details>

**3.3** Save all ERROR lines from `app.log` to a file, discard any grep errors.
<details><summary>Solution</summary>

```bash
grep "\[ERROR\]" practice/logs/app.log > /tmp/errors.txt 2>/dev/null
cat /tmp/errors.txt
```
</details>

**3.4** Count how many log entries exist per severity level (INFO, WARN, ERROR).
<details><summary>Solution</summary>

```bash
grep -oE '\[(INFO|WARN|ERROR)\]' practice/logs/app.log | sort | uniq -c
```
</details>

**3.5** Show the unique endpoints that returned a 4xx or 5xx in the nginx log.
<details><summary>Solution</summary>

```bash
grep -E '" [45][0-9]{2} ' practice/logs/nginx-access.log \
  | grep -oE '"[A-Z]+ [^ ]+' \
  | sort | uniq
```
</details>

---

## Block 4 — `cut` / `uniq` / `tr` / `xargs`

**4.1 `cut`** — Extract just the usernames from `users.tsv` (skip header).
<details><summary>Solution</summary>

```bash
tail -n +2 practice/data/users.tsv | cut -f2
```

> `tail -n +2` skips the header row. `-f2` = field 2 (tab-delimited by default).
</details>

**4.2 `cut`** — List all unique regions from `sales.csv`.
<details><summary>Solution</summary>

```bash
tail -n +2 practice/data/sales.csv | cut -d, -f2 | sort | uniq
```
</details>

**4.3 `uniq`** — Which product appears most in `sales.csv`?
<details><summary>Solution</summary>

```bash
tail -n +2 practice/data/sales.csv | cut -d, -f3 | sort | uniq -c | sort -rn
```
</details>

**4.4 `tr`** — Print all env variable names from `app.env` in lowercase.
<details><summary>Solution</summary>

```bash
grep -v '^#' practice/configs/app.env | grep '=' | cut -d= -f1 | tr '[:upper:]' '[:lower:]'
```
</details>

**4.5 `tr`** — Convert `sales.csv` commas to pipes `|` and preview the first 5 rows.
<details><summary>Solution</summary>

```bash
cat practice/data/sales.csv | tr ',' '|' | head -5
```
</details>

**4.6 `xargs`** — For each `.env` file, print its filename and count how many variables it defines.
<details><summary>Solution</summary>

```bash
find practice/configs/ -name "*.env" | xargs -I{} sh -c 'echo "{}:"; grep -v "^#" {} | grep -c "="'
```
</details>

---

## Block 5 — Permissions

```
-rwxr-xr--  =  owner:rwx  group:r-x  other:r--

Octal  Perms    Common use
  7    rwx      Scripts, dirs
  6    rw-      Config files
  5    r-x      Group/other execute
  4    r--      Read-only
  0    ---      No access

600  rw-------  SSH keys, secrets
644  rw-r--r--  Config files, web assets
755  rwxr-xr-x  Scripts, directories
```

**5.1** Check the current permissions on the two scripts in `practice/scripts/`.
<details><summary>Solution</summary>

```bash
ls -l practice/scripts/
```

> Are they executable? If not, you couldn’t run them directly with `./deploy.sh`.
</details>

**5.2** Make both scripts executable, then verify.
<details><summary>Solution</summary>

```bash
chmod 755 practice/scripts/*.sh
ls -l practice/scripts/
```
</details>

**5.3** Lock down the env files so only the owner can read them (simulate secret handling).
<details><summary>Solution</summary>

```bash
chmod 600 practice/configs/*.env
ls -l practice/configs/
```

> Production `.env` files should always be `600`. Never `644` — that exposes secrets to all users.
</details>

**5.4** The Mentor’s Challenge — prove permissions enforce access.
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
grep alice /etc/passwd               # no output = clean
```
</details>

**5.5** Find any world-writable files under `practice/`.
<details><summary>Solution</summary>

```bash
find practice/ -type f -perm /o+w
```
</details>

---

## Block 6 — `journalctl` + grep + pipes

> `journalctl` is the systemd log reader — replaces manually hunting through `/var/log/`.

```
journalctl -r                      # newest first
journalctl -f                      # follow (live)
journalctl -n 50                   # last 50 lines
journalctl -u nginx                # logs for one service
journalctl -p err                  # by priority
journalctl -b                      # since last boot
journalctl --since "1 hour ago"    # time filter
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
</details>

**6.3** Show SSH logs filtered for failed login attempts.
<details><summary>Solution</summary>

```bash
journalctl -u ssh | grep -i "failed"
```
</details>

**6.4** Top 5 most repeated error messages since last boot.
<details><summary>Solution</summary>

```bash
journalctl -b -p err -o cat | sort | uniq -c | sort -rn | head -5
```
</details>

**6.5** Watch live logs, show only `error` or `fail` lines.
<details><summary>Solution</summary>

```bash
journalctl -f | grep -i -E "error|fail"
```
</details>

**6.6** Save last hour’s errors to a timestamped file.
<details><summary>Solution</summary>

```bash
journalctl --since "1 hour ago" -p err > ~/errors_$(date +%Y%m%d_%H%M).txt
```
</details>

---

## Block 7 — Processes, Memory & Uptime

**7.1** How many processes are currently running?
<details><summary>Solution</summary>

```bash
ps aux | tail -n +2 | wc -l
```
</details>

**7.2** Which process is using the most memory?
<details><summary>Solution</summary>

```bash
ps aux --sort=-%mem | head -6
# Interactive:
htop  # press M to sort by memory
```
</details>

**7.3** When was the system last booted?
<details><summary>Solution</summary>

```bash
uptime -s
# or full history:
last reboot | head -5
```
</details>

**7.4** How much memory is available?
<details><summary>Solution</summary>

```bash
free -h
```

> Read `available`, not `free`. Available includes reclaimable cache.
</details>

**7.5** One-liner morning health check.
<details><summary>Solution</summary>

```bash
echo "=== Processes ==="  && ps aux | tail -n +2 | wc -l && \
echo "=== Top Memory ==" && ps aux --sort=-%mem | head -4 && \
echo "=== Last Boot ===" && uptime -s && \
echo "=== Memory ======" && free -h
```
</details>

---

## Cheat Sheet

```bash
# find
find . -type f | wc -l
find . -name "*.ext" | xargs du -sh | sort -rh | head -5
find . -name "*.env" -o -name "*.conf"

# grep
grep -c "pattern" file                      # count matches
grep -rn "pattern" dir/                     # recursive + line numbers
grep -E "pat1|pat2" file                    # OR
grep -v "#" file | grep "="                 # non-comment lines with =
grep -oE '[0-9]{1,3}(\.[0-9]{1,3}){3}' f  # extract IPs

# streams
cmd > out.txt 2>/dev/null    # stdout to file, silence errors
cmd > all.txt 2>&1           # stdout + stderr to same file

# cut / uniq / tr / xargs
tail -n +2 file.csv | cut -d, -f2          # skip header, get field 2
cut -d' ' -f1 file | sort | uniq -c | sort -rn  # count occurrences
cat file | tr ',' '|'                      # replace delimiter
find . -name "*.sh" | xargs -I{} sh -c 'echo {}; wc -l {}'

# permissions
chmod 600 *.env          # lock down secrets
chmod 755 *.sh           # make scripts executable
find . -perm /o+w        # find world-writable
ls -l                    # inspect permissions

# journalctl
journalctl -rn 50
journalctl -f | grep -i -E "error|fail"
journalctl -b -p err -o cat | sort | uniq -c | sort -rn | head -5

# processes / memory
ps aux --sort=-%mem | head -6
uptime -s && free -h
```
