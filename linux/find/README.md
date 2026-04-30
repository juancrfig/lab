# `find` — Integrated Challenges (80/20)

> Each challenge blends `find` with pipes and other commands.
> Practice inside the `practice/` folder.

```bash
cd linux/find/practice
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

</details>

---

## Challenge 3 — Which files were modified in the last day?

<details>
<summary>Solution</summary>

```bash
find . -type f -mtime -1 | sort
```

</details>

---

## Challenge 4 — Find all shell scripts containing the word `ERROR`

<details>
<summary>Solution</summary>

```bash
find . -name "*.sh" | xargs grep -l "ERROR"
```

</details>

---

## Challenge 5 — Which folder takes the most space?

<details>
<summary>Solution</summary>

```bash
du -sh */ | sort -h
```

</details>

---

## Challenge 6 — Delete all `.doc` files recursively

<details>
<summary>Solution</summary>

```bash
find . -name "*.doc"
find . -name "*.doc" -delete
```

> Why not `rm *.doc`? The glob only matches in the current directory.

</details>

---

## Challenge 7 — Find the 3 largest files in the tree

<details>
<summary>Solution</summary>

```bash
find . -type f | xargs du -sh | sort -rh | head -3
```

</details>

---

## 💿 Disk Space Challenge — How much total space is used on your system?

```bash
df -h                          # full system view (Use% column on /)
du -sh .                       # weight of current directory
du -sh */ | sort -h            # breakdown by subfolder
find . -type f | xargs du -sh | sort -rh | head -5
```

| Command | Answers |
|---|---|
| `df -h` | Total, used, available per partition |
| `du -sh .` | Weight of current directory |
| `du -sh */ \| sort -h` | Which subfolder eats the most space |

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
