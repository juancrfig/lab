# `find` — Integrated Challenges (80/20)

> Each challenge blends `find` with pipes and other commands.
> Practice inside the `practice/` folder.

```bash
cd bash/commands/find/practice
```

---

## Challenge 1 — How many `.doc` files exist?

Find all `.doc` files and **count** them.

```
Expected: 3
```

<details>
<summary>Solution</summary>

```bash
find . -name "*.doc" | wc -l
```

> `wc -l` counts lines. Since `find` prints one result per line, it counts files.

</details>

---

## Challenge 2 — How much space do your `.log` files take?

Find all `.log` files and show the **total disk usage**.

<details>
<summary>Solution</summary>

```bash
find . -name "*.log" | xargs du -sh
```

> `xargs` feeds each `find` result as arguments to `du -sh`.

</details>

---

## Challenge 3 — Which files were modified in the last day?

List files modified in the last 24h, sorted alphabetically.

<details>
<summary>Solution</summary>

```bash
find . -type f -mtime -1 | sort
```

</details>

---

## Challenge 4 — Find all shell scripts containing the word `ERROR`

Search only inside `.sh` files recursively.

> 💡 This is the real-world pattern: narrow by file type first, then search inside.

<details>
<summary>Solution</summary>

```bash
find . -name "*.sh" | xargs grep -l "ERROR"
```

> `-l` tells grep to print only the **filename**, not the matching lines.

</details>

---

## Challenge 5 — Which folder takes the most space?

Show disk usage per top-level subdirectory, sorted from smallest to largest.

<details>
<summary>Solution</summary>

```bash
du -sh */ | sort -h
```

> `du -sh */` shows human-readable size of each directory.
> `sort -h` sorts by human-readable numbers (K < M < G).

</details>

---

## Challenge 6 — Delete all `.doc` files recursively

First preview what will be deleted, then delete.

<details>
<summary>Solution</summary>

```bash
# Step 1: preview
find . -name "*.doc"

# Step 2: delete
find . -name "*.doc" -delete
```

> Why not `rm *.doc`? The glob `*.doc` only matches in the **current directory** — it won't recurse into subdirectories.

</details>

---

## Challenge 7 — Find the 3 largest files in the tree

List all files with their sizes, then show only the top 3.

<details>
<summary>Solution</summary>

```bash
find . -type f | xargs du -sh | sort -rh | head -3
```

> `sort -rh` = sort descending by human-readable size. `head -3` = take top 3.

</details>

---

## 💿 Disk Space Challenge — How much total space is used on your system?

Three commands, three levels of detail:

```bash
# 1. Overall disk usage of the whole system (partitions view)
df -h

# 2. How much space is used in the current directory (summary)
du -sh .

# 3. Breakdown by each subdirectory, sorted
du -sh */ | sort -h
```

| Command | Answers |
|---|---|
| `df -h` | Total space, used, available per partition |
| `du -sh .` | How much this folder weighs in total |
| `du -sh */ \| sort -h` | Which subfolder is eating the most space |

> **Quick answer to "how much disk is used?"** → `df -h` — look at the `Use%` column for your main partition (`/`).

---

## Cheat Sheet

| Goal | Command |
|---|---|
| Count found files | `find . -name "*.ext" \| wc -l` |
| Size of found files | `find . -name "*.ext" \| xargs du -sh` |
| Find files containing text | `find . -name "*.ext" \| xargs grep -l "word"` |
| Largest files | `find . -type f \| xargs du -sh \| sort -rh \| head -5` |
| Delete by extension | `find . -name "*.ext" -delete` |
| Space per subdirectory | `du -sh */ \| sort -h` |
| Total system disk usage | `df -h` |
