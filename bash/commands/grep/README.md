# `grep` — Integrated Challenges (80/20)

> Each challenge blends `grep` with pipes and other commands.
> Practice inside the `practice/` folder.

```bash
cd bash/commands/grep/practice
```

---

## Challenge 1 — How many ERRORs happened today?

Count the total number of `ERROR` lines in `logs/error.log`.

<details>
<summary>Solution</summary>

```bash
grep -c "ERROR" logs/error.log

# Or with a pipe:
grep "ERROR" logs/error.log | wc -l
```

> `-c` counts matching lines directly. `wc -l` is the pipe equivalent.

</details>

---

## Challenge 2 — Which unique IPs hit your server?

Extract all IPs from `logs/access.log` and show them **deduplicated and sorted**.

<details>
<summary>Solution</summary>

```bash
grep -oE "^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+" logs/access.log | sort | uniq
```

> `-o` prints only the matched part. `-E` enables regex. `sort | uniq` deduplicates.

</details>

---

## Challenge 3 — How many requests were NOT successful (not 200)?

Count lines in `logs/access.log` that do **not** contain `200`.

<details>
<summary>Solution</summary>

```bash
grep -v "200" logs/access.log | wc -l
```

> `-v` inverts the match — keeps lines that do NOT match.

</details>

---

## Challenge 4 — Find all 404 and 403 responses in the access log

Show only those lines and count them.

<details>
<summary>Solution</summary>

```bash
# Show the lines
grep -E "403|404" logs/access.log

# Count them
grep -E "403|404" logs/access.log | wc -l
```

</details>

---

## Challenge 5 — Security scan: find any file containing `password`

Search all files in `configs/` recursively, show the filename and line number.

> 💡 This is how you audit config files for accidentally committed secrets.

<details>
<summary>Solution</summary>

```bash
grep -rni "password" configs/
```

> `-r` recursive, `-n` line numbers, `-i` case-insensitive.

</details>

---

## Challenge 6 — Show the last 5 errors with context

Print the last 5 `ERROR` lines from `logs/app.log`.

<details>
<summary>Solution</summary>

```bash
grep "ERROR" logs/app.log | tail -5
```

> Pipe grep results into `tail` to get only the most recent ones.

</details>

---

## Challenge 7 — Which config files mention `port`? Show their sizes too.

Find files in `configs/` mentioning `port`, then check how much space they take.

<details>
<summary>Solution</summary>

```bash
# Step 1: which files mention port?
grep -ril "port" configs/

# Step 2: pipe to du to see their sizes
grep -ril "port" configs/ | xargs du -sh
```

> `grep -l` = list filenames only. `xargs` feeds them to `du -sh`.

</details>

---

## 💿 Disk Space Challenge — How much total space is used on your system?

```bash
# 1. Full system view (partitions, used, available)
df -h

# 2. Space used by current directory
du -sh .

# 3. Which subfolder is the heaviest?
du -sh */ | sort -h

# 4. Top 5 largest files anywhere in the tree
find . -type f | xargs du -sh | sort -rh | head -5
```

| Command | Answers |
|---|---|
| `df -h` | Total space, used, available per partition |
| `du -sh .` | Weight of current directory |
| `du -sh */ \| sort -h` | Which subfolder eats the most space |
| `find . -type f \| xargs du -sh \| sort -rh \| head -5` | Top 5 largest files |

> **Quick answer to "how much disk is used?"** → `df -h`, look at `Use%` on your `/` partition.

---

## Cheat Sheet

| Goal | Command |
|---|---|
| Count matches | `grep -c "pattern" file` |
| Unique IPs / values | `grep -oE "regex" file \| sort \| uniq` |
| Exclude lines | `grep -v "pattern" file \| wc -l` |
| OR pattern | `grep -E "pat1\|pat2" file` |
| Recursive + line numbers | `grep -rn "pattern" dir/` |
| Files containing pattern | `grep -rl "pattern" dir/` |
| Last N matches | `grep "pattern" file \| tail -N` |
| Size of matched files | `grep -rl "pattern" . \| xargs du -sh` |
| Total system disk usage | `df -h` |
