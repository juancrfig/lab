# Solutions

Open this only after you've tried. Compare — even if yours worked.

---

## Block 1 — `find`

```bash
# 1
find practice/ -type f | wc -l

# 2
find practice/ -name "*.log" | xargs du -sh

# 3
find practice/scripts/ -name "*.sh" | xargs grep -l "ERROR"
# -l = list filenames only, not matching lines

# 4
find practice/ -type f | xargs du -sh | sort -rh | head -3
# sort -rh: -r reverse, -h human-readable sizes (10K < 1M < 1G)

# 5
find practice/configs/ -type f \( -name "*.env" -o -name "*.conf" \)
# \( \) groups the OR — without it, -o has lower precedence and gives wrong results
```

---

## Block 2 — `grep`

```bash
# 1
grep -c "\[ERROR\]" practice/logs/app.log
# -c counts matching lines directly

# 2
grep ' 500 ' practice/logs/nginx-access.log
# spaces prevent false matches on 5000, /path/500items, etc.

# 3
grep -rn "timeout" practice/logs/
# -r recursive, -n line numbers

# 4
grep -riE "password|secret|jwt" practice/
# -i case-insensitive, -E extended regex so | works without backslash

# 5
grep -E "v1\.4\.0|ERROR|aborted" practice/logs/deploy.log
# Escape dots in version numbers — . means "any char" in regex
```

---

## Block 3 — Pipes & Streams

```bash
# 1
cut -d' ' -f1 practice/logs/nginx-access.log | sort | uniq -c | sort -rn
# uniq requires sorted input — always sort before uniq

# 2
grep -oE ' [0-9]{3} ' practice/logs/nginx-access.log | tr -d ' ' | sort -u
# -o prints only matched part. sort -u = sort + deduplicate

# 3 — step 1: see the error
chmod 000 logs/locked.log
grep -r "\[ERROR\]" logs/ > /tmp/errors.txt
# grep: logs/locked.log: Permission denied  <-- prints to terminal (stderr)

# step 2: silence it
grep -r "\[ERROR\]" logs/ > /tmp/errors.txt 2>/dev/null

# 4
grep -oE '\[(INFO|WARN|ERROR)\]' practice/logs/app.log | sort | uniq -c
```

---

## Block 4 — `cut` / `uniq` / `tr` / `xargs`

```bash
# 1
tail -n +2 practice/data/users.tsv | cut -f2
# tail -n +2 skips header. cut -f2 = field 2, tab-delimited by default

# 2
tail -n +2 practice/data/sales.csv | cut -d, -f2 | sort -u

# 3
tail -n +2 practice/data/sales.csv | cut -d, -f3 | sort | uniq -c | sort -rn | head -1

# 4
grep -v '^#' practice/configs/app.env | grep '=' | cut -d= -f1 | tr '[:upper:]' '[:lower:]'

# 5
tr ',' '|' < practice/data/sales.csv | head -5
# tr < file — no cat needed (UUOC: Useless Use of Cat)
```

---

## Block 5 — Permissions

```bash

# 1
chmod 600 practice/configs/*.env && ls -l practice/configs/

# 2
echo "top secret" > /tmp/private.txt
chmod 600 /tmp/private.txt
sudo useradd -m alice
sudo -u alice cat /tmp/private.txt   # Permission denied
chmod 644 /tmp/private.txt
sudo -u alice cat /tmp/private.txt   # works
rm /tmp/private.txt && sudo userdel -r alice

# 3
find practice/ -type f -perm /o+w
```

---

## Block 6 — `journalctl`

```bash
# 1
journalctl -rn 20

# 2
journalctl -b -p err | wc -l

# 3
journalctl -u ssh | grep -i "failed"
# some systems: journalctl -u sshd

# 4
journalctl -b -p err -o cat | sort | uniq -c | sort -rn | head -5
# -o cat strips metadata so uniq groups by message content

# 5
journalctl -f | grep -iE "error|fail"

# 6
journalctl --since "1 hour ago" -p err > ~/errors_$(date +%Y%m%d_%H%M).txt
```

---

## Block 7 — Processes & Memory

```bash
# 1
ps aux | tail -n +2 | wc -l

# 2
ps aux --sort=-%mem | head -6

# 3
uptime -s

# 4
free -h
# Read 'available' column, not 'free' — Linux caches disk in RAM, that's normal

# 5
echo "── Processes ──" && ps aux | tail -n +2 | wc -l && \
echo "── Top RAM ────" && ps aux --sort=-%mem | head -4 && \
echo "── Last Boot ──" && uptime -s && \
echo "── Memory ─────" && free -h
```

---

## Cheat Sheet

```bash
# find
find . -type f | wc -l
find . -name "*.ext" | xargs du -sh | sort -rh | head -5
find . \( -name "*.env" -o -name "*.conf" \)
find . -type f -perm /o+w

# grep
grep -c "pattern" file
grep -rn "pattern" dir/
grep -E "pat1|pat2" file
grep -oE ' [0-9]{3} ' file | tr -d ' ' | sort -u

# streams
cmd > out.txt          # overwrite
cmd >> out.txt         # append
cmd 2>/dev/null        # discard stderr
cmd > all.txt 2>&1     # stdout + stderr together

# cut / uniq / tr
tail -n +2 file | cut -d, -f2 | sort -u
cut -d' ' -f1 file | sort | uniq -c | sort -rn
tr ',' '|' < file

# permissions
chmod 600 *.env    # secrets
chmod 755 *.sh     # scripts
find . -perm /o+w  # world-writable audit

# journalctl
journalctl -rn 50
journalctl -b -p err -o cat | sort | uniq -c | sort -rn | head -5
journalctl -f | grep -iE "error|fail"

# processes
ps aux --sort=-%mem | head -6
uptime -s && free -h
```
