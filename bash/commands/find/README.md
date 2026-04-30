# `find` Command — Challenges (80/20)

> Go to the `practice/` folder and complete each challenge in order.
> Each one teaches a core `find` pattern you'll use constantly as a DevOps engineer.

## Setup

```bash
cd bash/commands/find/practice
```

That's it. All the files you need are already there.

---

## Challenge 1 — Find by Name

**Goal:** List every `.doc` file inside `practice/` recursively.

```
Expected output (3 files):
./docs/report.doc
./docs/draft.doc
./archive/old-draft.doc
```

<details>
<summary>Solution</summary>

```bash
find . -name "*.doc"
```

</details>

---

## Challenge 2 — Find by Type

**Goal 1:** List only files (not directories).
**Goal 2:** List only directories.

<details>
<summary>Solution</summary>

```bash
find . -type f   # only files
find . -type d   # only directories
```

</details>

---

## Challenge 3 — Find + Delete

**Goal:** Delete all `.doc` files recursively without touching any other file.

> 💡 Why not `rm *.doc`? The shell glob only matches in the current directory — it won't go into subdirectories.

<details>
<summary>Solution</summary>

```bash
# Preview first (dry run)
find . -name "*.doc"

# Then delete
find . -name "*.doc" -delete
```

</details>

---

## Challenge 4 — Find by Size

**Goal 1:** Find files larger than 1KB.
**Goal 2:** Find files smaller than 1KB.

<details>
<summary>Solution</summary>

```bash
find . -type f -size +1k   # larger than 1KB
find . -type f -size -1k   # smaller than 1KB
```

</details>

---

## Challenge 5 — Find by Modification Time

**Goal 1:** Find files modified in the last 24 hours.
**Goal 2:** Find files NOT modified in the last 7 days (stale files).

<details>
<summary>Solution</summary>

```bash
find . -mtime -1   # modified in last 24h
find . -mtime +7   # not touched in more than 7 days
```

</details>

---

## Challenge 6 — Find + Execute

**Goal:** Print the contents of every `.log` file found recursively.

<details>
<summary>Solution</summary>

```bash
find . -name "*.log" -exec cat {} \;
```

> `{}` is replaced by each matched file path. `\;` ends the `-exec` block.

</details>

---

## Challenge 7 — Case-Insensitive Search

**Goal:** Find all `.LOG` files regardless of case (`.log`, `.LOG`, `.Log` — all match).

<details>
<summary>Solution</summary>

```bash
find . -iname "*.log"
```

</details>

---

## Cheat Sheet

| Goal | Command |
|---|---|
| Find by name | `find . -name "*.ext"` |
| Find only files | `find . -type f` |
| Find only dirs | `find . -type d` |
| Delete matches | `find . -name "*.ext" -delete` |
| Larger than X | `find . -size +1M` |
| Modified in last 24h | `find . -mtime -1` |
| Run command on results | `find . -name "*.x" -exec cmd {} \;` |
| Case-insensitive name | `find . -iname "*.ext"` |
