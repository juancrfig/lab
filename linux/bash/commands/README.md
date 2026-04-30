# Bash Commands — Morning Practice

> One block per day. Each block = ~5 min. Full run = 30 min.
> Most exercises use `/etc/passwd` as the data source — it's always there, no setup needed.

---

## Block 1 — `find`

> Practice files are in `practice/` inside this folder.

**1.1** How many `.doc` files exist under `practice/`?
<details><summary>Solution</summary>

```bash
find practice/ -name "*.doc" | wc -l
```
</details>

**1.2** Which shell scripts contain the word `ERROR`?
<details><summary>Solution</summary>

```bash
find practice/ -name "*.sh" | xargs grep -l "ERROR"
```
</details>

**1.3** Find the 3 largest files in `practice/`.
<details><summary>Solution</summary>

```bash
find practice/ -type f | xargs du -sh | sort -rh | head -3
```
</details>

**1.4** Delete all `.doc` files recursively (preview first, then delete).
<details><summary>Solution</summary>

```bash
find practice/ -name "*.doc"          # preview
find practice/ -name "*.doc" -delete  # delete
```
</details>

---

## Block 2 — `grep`

**2.1** How many user accounts exist on this system?
<details><summary>Solution</summary>

```bash
grep -c "" /etc/passwd
# or:
wc -l < /etc/passwd
```
</details>

**2.2** Find your own entry in `/etc/passwd`.
<details><summary>Solution</summary>

```bash
grep "^$(whoami)" /etc/passwd
```
</details>

**2.3** List all users whose shell is `/bin/bash`.
<details><summary>Solution</summary>

```bash
grep "/bin/bash$" /etc/passwd
```
</details>

**2.4** Find all users that do NOT have a login shell (`nologin` or `/bin/false`).
<details><summary>Solution</summary>

```bash
grep -E "nologin|/bin/false" /etc/passwd
```
</details>

---

## Block 3 — Pipes & Streams

> `stdin` = input (fd 0) | `stdout` = output (fd 1) | `stderr` = errors (fd 2)

**3.1** Send stdout to a file, stderr to a different file.
<details><summary>Solution</summary>

```bash
grep "bash" /etc/passwd > found.txt 2> errors.txt
```
</details>

**3.2** Discard errors entirely (send stderr to `/dev/null`).
<details><summary>Solution</summary>

```bash
find / -name "*.log" 2>/dev/null
```

> Without `2>/dev/null` you'd drown in `Permission denied` errors.
</details>

**3.3** Redirect both stdout and stderr to the same file.
<details><summary>Solution</summary>

```bash
grep "bash" /etc/passwd > all_output.txt 2>&1
```

> `2>&1` = "send fd2 to wherever fd1 is going."
</details>

**3.4** Count how many users have `/bin/bash` as their shell.
<details><summary>Solution</summary>

```bash
grep "/bin/bash" /etc/passwd | wc -l
```
</details>

**3.5** Chain 3 commands: extract all shells, sort, count unique ones.
<details><summary>Solution</summary>

```bash
cut -d: -f7 /etc/passwd | sort | uniq -c | sort -rn
```
</details>

---

## Block 4 — `cut` / `uniq` / `tr` / `xargs`

> `/etc/passwd` fields: `username:password:UID:GID:comment:home:shell` (1–7)

**4.1 `cut`** — Extract just the usernames (field 1).
<details><summary>Solution</summary>

```bash
cut -d: -f1 /etc/passwd
```
</details>

**4.2 `cut`** — Extract username and home directory (fields 1 and 6).
<details><summary>Solution</summary>

```bash
cut -d: -f1,6 /etc/passwd
```
</details>

**4.3 `uniq`** — List all unique shells in use.
<details><summary>Solution</summary>

```bash
cut -d: -f7 /etc/passwd | sort | uniq
```

> `uniq` only removes **adjacent** duplicates — always `sort` first.
</details>

**4.4 `tr`** — Print all usernames in UPPERCASE.
<details><summary>Solution</summary>

```bash
cut -d: -f1 /etc/passwd | tr '[:lower:]' '[:upper:]'
```
</details>

**4.5 `tr`** — Replace `:` in `/etc/passwd` with a tab.
<details><summary>Solution</summary>

```bash
cat /etc/passwd | tr ':' '\t'
```
</details>

**4.6 `xargs`** — Look up `root` and `daemon` entries in `/etc/passwd`.
<details><summary>Solution</summary>

```bash
echo -e "root\ndaemon" | xargs -I{} grep "^{}:" /etc/passwd
```

> `-I{}` is a placeholder replaced by each input line.
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

**5.1** Inspect the 3 system files and try to read `/etc/shadow`.
<details><summary>Solution</summary>

```bash
ls -l /etc/passwd /etc/shadow /etc/group
cat /etc/shadow   # Expected: Permission denied
```
</details>

**5.2** `chmod` practice — set a file to 600, then 644, inspect after each.
<details><summary>Solution</summary>

```bash
echo "test" > /tmp/test.txt
chmod 600 /tmp/test.txt && ls -l /tmp/test.txt
chmod 644 /tmp/test.txt && ls -l /tmp/test.txt
```
</details>

**5.3** The Mentor's Challenge — prove permissions enforce access.
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

**5.4** Audit world-writable files in `/tmp`.
<details><summary>Solution</summary>

```bash
find /tmp -type f -perm /o+w 2>/dev/null
```
</details>

---

## Block 6 — `journalctl` + grep + pipes

> `journalctl` is the systemd log reader. Replaces manually hunting through `/var/log/`.

```
journalctl -r                      # newest first
journalctl -f                      # follow (live)
journalctl -n 50                   # last 50 lines
journalctl -u nginx                # logs for one service
journalctl -p err                  # by priority (emerg alert crit err warning notice info debug)
journalctl -b                      # since last boot
journalctl --since "1 hour ago"    # time filter
```

**6.1** Show the last 20 journal entries, newest first.
<details><summary>Solution</summary>

```bash
journalctl -rn 20
```
</details>

**6.2** How many error-level (or worse) events happened since last boot?
<details><summary>Solution</summary>

```bash
journalctl -b -p err | wc -l
```

> `-p err` includes emerg, alert, crit, err — everything serious.
</details>

**6.3** Show SSH logs and filter for failed login attempts.
<details><summary>Solution</summary>

```bash
journalctl -u ssh | grep -i "failed"
# on some systems:
journalctl -u sshd | grep -i "failed"
```
</details>

**6.4** Find the most repeated error messages since last boot (top 5).
<details><summary>Solution</summary>

```bash
journalctl -b -p err -o cat | sort | uniq -c | sort -rn | head -5
```

> `-o cat` strips timestamps so `uniq` can group identical messages.
</details>

**6.5** Watch logs in real time, show only lines with `error` or `fail`.
<details><summary>Solution</summary>

```bash
journalctl -f | grep -i -E "error|fail"
```
</details>

**6.6** Save all errors from the last hour to a timestamped file.
<details><summary>Solution</summary>

```bash
journalctl --since "1 hour ago" -p err > ~/errors_$(date +%Y%m%d_%H%M).txt
```
</details>

---

## Block 7 — Processes, Memory & Uptime

> Answer your mentor's 4 questions every morning as a health check ritual.

**7.1** How many processes are currently running?
<details><summary>Solution</summary>

```bash
ps aux | wc -l

# Subtract 1 for the header line:
ps aux | tail -n +2 | wc -l
```

> `ps aux` = all processes, all users, with CPU/mem info.
</details>

**7.2** Which process is using the most memory?
<details><summary>Solution</summary>

```bash
# With ps (sorted by memory, top 5):
ps aux --sort=-%mem | head -6

# Interactive (visual):
htop
# Inside htop: press M to sort by memory, q to quit
```

> Column `%MEM` = % of RAM used. Column `RSS` = actual RAM in KB.
</details>

**7.3** When was the system last booted?
<details><summary>Solution</summary>

```bash
# Quick answer:
uptime -s

# With more detail:
who -b

# Full boot history:
last reboot | head -5
```
</details>

**7.4** How much memory is available right now?
<details><summary>Solution</summary>

```bash
free -h
```

```
              total   used   free   shared  buff/cache  available
Mem:           15Gi   4Gi    2Gi    300Mi      8Gi         10Gi
```

> Read the `available` column — not `free`. Available = what the OS can actually give to a new process (includes reclaimable cache).
</details>

**7.5** One-liner morning health check — print all 4 answers at once.
<details><summary>Solution</summary>

```bash
echo "=== Processes ==="  && ps aux | tail -n +2 | wc -l
echo "=== Top Memory ==" && ps aux --sort=-%mem | head -4
echo "=== Last Boot ===" && uptime -s
echo "=== Memory ======" && free -h
```
</details>

---

## Cheat Sheet

```bash
# find
find . -name "*.ext" | wc -l
find . -name "*.ext" | xargs du -sh
find . -type f | xargs du -sh | sort -rh | head -5

# grep
grep -c "pattern" file
grep -v "pattern" file | wc -l
grep -E "pat1|pat2" file
grep -rni "pattern" dir/

# streams
cmd > out.txt            # stdout to file
cmd 2> err.txt           # stderr to file
cmd > all.txt 2>&1       # both to same file
cmd 2>/dev/null          # silence errors

# cut / uniq / tr / xargs
cut -d: -f1 /etc/passwd
cut -d: -f1,6 /etc/passwd
cat file | sort | uniq -c | sort -rn
cat file | tr 'a-z' 'A-Z'
cat file | tr ':' '\t'
echo -e "a\nb" | xargs -I{} cmd {}

# permissions
ls -l file
chmod 644 file
chown user:group file
find . -perm /o+w

# journalctl
journalctl -rn 50
journalctl -f | grep -i "error"
journalctl -b -p err | wc -l
journalctl -u nginx | grep "failed"
journalctl --since "1 hour ago" -p err > errors.txt
journalctl -b -p err -o cat | sort | uniq -c | sort -rn | head -5

# processes / memory / uptime
ps aux | tail -n +2 | wc -l          # process count
ps aux --sort=-%mem | head -6        # top memory consumers
uptime -s                            # last boot time
free -h                              # memory (read 'available')
```
