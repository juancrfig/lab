# `find` Command Exercises (80/20)

> Master the 20% of `find` features that cover 80% of real-world use cases.

## Setup

Create a test environment before starting:

```bash
mkdir -p ~/find-practice/{logs,docs,scripts}
touch ~/find-practice/logs/{app.log,error.log,old.log}
touch ~/find-practice/docs/{report.doc,notes.txt,draft.doc}
touch ~/find-practice/scripts/{deploy.sh,backup.sh}
```

---

## Exercise 1 — Find by Name

```bash
find ~/find-practice -name "*.doc"
```

✅ Goal: List all `.doc` files recursively.

---

## Exercise 2 — Find by Type

```bash
find ~/find-practice -type f   # only files
find ~/find-practice -type d   # only directories
```

✅ Goal: Understand the difference between files and dirs.

---

## Exercise 3 — Find + Delete

```bash
find ~/find-practice -name "*.doc" -delete
```

✅ Goal: Remove all `.doc` files recursively.

> **Why not `rm *.doc`?** The shell glob `*.doc` only matches files in the current directory — it doesn't cross into subdirectories. `find` is the correct tool for recursive deletion.

---

## Exercise 4 — Find by Size

```bash
find ~/find-practice -size +1k   # files larger than 1KB
find ~/find-practice -size -1k   # files smaller than 1KB
```

✅ Goal: Filter files by size — useful for finding large log files.

---

## Exercise 5 — Find by Modification Time

```bash
find ~/find-practice -mtime -1   # modified in the last 24h
find ~/find-practice -mtime +7   # modified more than 7 days ago
```

✅ Goal: Locate recently changed or stale files.

---

## Exercise 6 — Find + Execute a Command

```bash
find ~/find-practice -name "*.log" -exec cat {} \;
```

✅ Goal: Run a command on every result — the most powerful pattern.

---

## Exercise 7 — Case-Insensitive Search

```bash
find ~/find-practice -iname "*.LOG"
```

✅ Goal: Match filenames regardless of uppercase/lowercase.

---

## Cheat Sheet

| Goal | Command |
|---|---|
| Find by name | `find . -name "*.ext"` |
| Find only files | `find . -type f` |
| Find only dirs | `find . -type d` |
| Delete matches | `find . -name "*.ext" -delete` |
| Larger than X | `find . -size +1M` |
| Modified recently | `find . -mtime -1` |
| Run command on results | `find . -name "*.x" -exec cmd {} \;` |
