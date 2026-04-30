# Linux Permissions — Challenges

## Background

### Key Files

| File | What it stores |
|---|---|
| `/etc/passwd` | All users: username, UID, GID, home dir, shell |
| `/etc/shadow` | Hashed passwords (root-only readable) |
| `/etc/group` | Groups and their members |

```bash
# Read them yourself
cat /etc/passwd    # readable by everyone
cat /etc/shadow    # Permission denied (unless root)
cat /etc/group     # readable by everyone

# A line in /etc/passwd looks like:
# juan:x:1001:1001::/home/juan:/bin/bash
#  ^    ^  ^    ^        ^         ^
# user  pw UID  GID    home      shell
```

### Reading `ls -l` output

```
-rwxr-xr--  1  juan  devs  1024  Apr 30  deploy.sh
^││││││││││
│││││││└── other: r--  (read only)
││││└────── group: r-x  (read + execute)
│└───────── owner: rwx  (read + write + execute)
└────────── type:  - = file, d = dir, l = symlink
```

### Octal Numbers Decoded

```
Permission  Binary  Octal
---         000     0
--x         001     1
-w-         010     2
-wx         011     3
r--         100     4
r-x         101     5
rw-         110     6
rwx         111     7
```

| Mode | Meaning | Typical use |
|---|---|---|
| `600` | rw------- | Private files (SSH keys, secrets) |
| `644` | rw-r--r-- | Public config files, web assets |
| `700` | rwx------ | Private scripts |
| `755` | rwxr-xr-x | Public scripts, directories |
| `777` | rwxrwxrwx | ⚠️ Never use in production |

---

## Challenge 1 — Read the system user files

**Goal:** Understand who is on the system and what groups exist.

```bash
# How many users are on the system?
cat /etc/passwd | wc -l

# Find your own user entry
grep "^$(whoami)" /etc/passwd

# What groups does your user belong to?
groups

# Try to read shadow (should fail without sudo)
cat /etc/shadow
```

> ✅ Expected: `Permission denied` on `/etc/shadow`. That's correct behavior.

---

## Challenge 2 — Read and interpret `ls -l`

**Goal:** Decode permission bits from real files.

```bash
ls -l /etc/passwd /etc/shadow /etc/group
```

Expected output:
```
-rw-r--r-- 1 root root   ... /etc/passwd   (644)
-rw-r----- 1 root shadow ... /etc/shadow   (640)
-rw-r--r-- 1 root root   ... /etc/group    (644)
```

**Questions to answer:**
- Who can write to `/etc/passwd`?
- Why can only root (and group `shadow`) read `/etc/shadow`?
- What is the octal number for `rw-r--r--`?

<details>
<summary>Answers</summary>

- Only `root` can write to `/etc/passwd`
- Because passwords would be exposed otherwise — this is a security boundary
- `rw-r--r--` = `644`

</details>

---

## Challenge 3 — `chmod`: What do 755 and 644 mean in practice?

```bash
# Create a test file
echo "hello" > /tmp/test.txt
ls -l /tmp/test.txt

# Set to 644 (owner rw, everyone else r)
chmod 644 /tmp/test.txt
ls -l /tmp/test.txt

# Set to 600 (owner only)
chmod 600 /tmp/test.txt
ls -l /tmp/test.txt

# Set to 755 (common for scripts/dirs)
chmod 755 /tmp/test.txt
ls -l /tmp/test.txt
```

> After each `chmod`, decode the output yourself before moving on.

---

## Challenge 4 — `chown`: Change who owns a file

```bash
# Syntax: chown user:group file
sudo chown root:root /tmp/test.txt
ls -l /tmp/test.txt

# Change back to yourself
sudo chown $(whoami):$(whoami) /tmp/test.txt
ls -l /tmp/test.txt
```

> `$(whoami)` is command substitution — inserts your username dynamically.

---

## Challenge 5 — The Mentor's Challenge (Full Walkthrough)

> Prove that permissions actually enforce access.

```bash
# 1. Create a new user called alice
sudo useradd -m alice

# 2. Create a private file
echo "top secret" > /tmp/private.txt

# 3. Set permissions to 600 (owner-only)
chmod 600 /tmp/private.txt
ls -l /tmp/private.txt
# Expected: -rw------- 1 <youruser> ...

# 4. Prove alice cannot read it
sudo -u alice cat /tmp/private.txt
# Expected: Permission denied ✅

# 5. Open it up to 644
chmod 644 /tmp/private.txt
ls -l /tmp/private.txt
# Expected: -rw-r--r-- 1 <youruser> ...

# 6. Prove alice CAN now read it
sudo -u alice cat /tmp/private.txt
# Expected: top secret ✅

# 7. Clean up
rm /tmp/private.txt
sudo userdel -r alice

# 8. Verify alice is gone
grep alice /etc/passwd
# Expected: (no output)
```

---

## Challenge 6 — Combine with `find`: audit risky permissions

**Goal:** Find all world-writable files in `/tmp`.

```bash
find /tmp -type f -perm /o+w
```

> In production, world-writable files are a security risk. This is how you audit them.

---

## Cheat Sheet

| Goal | Command |
|---|---|
| View permissions | `ls -l file` |
| Change permissions (octal) | `chmod 644 file` |
| Change permissions (symbolic) | `chmod u+x file` |
| Change owner | `chown user:group file` |
| Change owner recursively | `chown -R user:group dir/` |
| Find world-writable files | `find . -perm /o+w` |
| Who am I? | `whoami` |
| What groups am I in? | `groups` |
| Run command as another user | `sudo -u alice command` |
