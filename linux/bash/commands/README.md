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

**2.4** Find all users that do NOT have a login shell (shell is `/usr/sbin/nologin` or `/bin/false`).
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
cat found.txt
cat errors.txt
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

> `2>&1` means “send fd2 to wherever fd1 is going.”
</details>

**3.4** Use a pipe to count how many users have `/bin/bash` as their shell.
<details><summary>Solution</summary>

```bash
grep "/bin/bash" /etc/passwd | wc -l
```
</details>

**3.5** Chain 3 commands: extract all shells, sort them, count unique ones.
<details><summary>Solution</summary>

```bash
cut -d: -f7 /etc/passwd | sort | uniq -c | sort -rn
```

> This shows which shells are most common on the system.
</details>

---

## Block 4 — `cut` / `uniq` / `tr` / `xargs`

> `/etc/passwd` fields (colon-separated):
> `username:password:UID:GID:comment:home:shell`
> `    1        2     3   4     5      6     7`

**4.1 `cut`** — Extract just the usernames (field 1) from `/etc/passwd`.
<details><summary>Solution</summary>

```bash
cut -d: -f1 /etc/passwd
```

> `-d:` sets `:` as delimiter. `-f1` selects field 1.
</details>

**4.2 `cut`** — Extract username and home directory (fields 1 and 6).
<details><summary>Solution</summary>

```bash
cut -d: -f1,6 /etc/passwd
```
</details>

**4.3 `uniq`** — List all unique shells in use, sorted.
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

> `tr` translates characters. It doesn't accept filenames — only stdin via pipe.
</details>

**4.5 `tr`** — Replace the `:` delimiter in `/etc/passwd` with a tab.
<details><summary>Solution</summary>

```bash
cat /etc/passwd | tr ':' '\t'
```
</details>

**4.6 `xargs`** — Take a list of usernames and look each one up in `/etc/passwd`.
<details><summary>Solution</summary>

```bash
echo -e "root\ndaemon" | xargs -I{} grep "^{}:" /etc/passwd
```

> `-I{}` defines a placeholder replaced by each input line.
</details>

---

## Block 5 — Permissions

### Reference

| File | Readable by |
|---|---|
| `/etc/passwd` | Everyone |
| `/etc/shadow` | root only |
| `/etc/group` | Everyone |

```
-rwxr-xr--  =  owner:rwx  group:r-x  other:r--

Octal   Binary  Perms
  7      111    rwx
  6      110    rw-
  5      101    r-x
  4      100    r--
  0      000    ---

Common modes:
  600  rw-------  SSH keys, secret files
  644  rw-r--r--  Config files, web assets
  755  rwxr-xr-x  Scripts, directories
```

**5.1** Read the permission bits on the 3 system files and decode them.
<details><summary>Solution</summary>

```bash
ls -l /etc/passwd /etc/shadow /etc/group
# Try reading shadow without sudo:
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
# Setup
sudo useradd -m alice
echo "top secret" > /tmp/private.txt

# 600: alice blocked
chmod 600 /tmp/private.txt
sudo -u alice cat /tmp/private.txt   # Permission denied

# 644: alice can read
chmod 644 /tmp/private.txt
sudo -u alice cat /tmp/private.txt   # top secret

# Cleanup
rm /tmp/private.txt
sudo userdel -r alice
grep alice /etc/passwd               # no output = done
```
</details>

**5.4** Combine with `find` — audit world-writable files in `/tmp`.
<details><summary>Solution</summary>

```bash
find /tmp -type f -perm /o+w 2>/dev/null
```
</details>

---

## Cheat Sheet

```bash
# find
find . -name "*.ext" | wc -l          # count files
find . -name "*.ext" | xargs du -sh   # size of files
find . -type f | xargs du -sh | sort -rh | head -5  # top 5 largest

# grep
grep -c "pattern" file                # count matches
grep -v "pattern" file | wc -l        # count non-matches
grep -E "pat1|pat2" file              # OR match
grep -rni "pattern" dir/              # recursive, case-insensitive, line numbers

# streams
cmd > out.txt          # stdout to file
cmd 2> err.txt         # stderr to file
cmd > all.txt 2>&1     # both to same file
cmd 2>/dev/null        # silence errors

# cut / uniq / tr / xargs
cut -d: -f1 /etc/passwd               # field 1
cut -d: -f1,6 /etc/passwd             # fields 1 and 6
cat file | sort | uniq                 # deduplicate
cat file | sort | uniq -c | sort -rn  # count occurrences
cat file | tr 'a-z' 'A-Z'             # uppercase
cat file | tr ':' '\t'                # replace delimiter
echo -e "a\nb" | xargs -I{} cmd {}   # run cmd for each line

# permissions
ls -l file                   # view permissions
chmod 644 file               # change mode
chown user:group file        # change owner
find . -perm /o+w            # find world-writable
```
