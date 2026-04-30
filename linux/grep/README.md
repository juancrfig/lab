# `grep` — Integrated Challenges (80/20)

> Each challenge blends `grep` with pipes and other commands.
> Practice inside the `practice/` folder.

```bash
cd linux/grep/practice
```

---

## Challenge 1 — How many ERRORs happened today?

Count the total number of `ERROR` lines in `logs/error.log`.

<details>
<summary>Solution</summary>

```bash
grep -c "ERROR" logs/error.log
# Or:
grep "ERROR" logs/error.log | wc -l
```

</details>

---

## Challenge 2 — Which unique IPs hit your server?

Extract all IPs from `logs/access.log`, deduplicated and sorted.

<details>
<summary>Solution</summary>

```bash
grep -oE "^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+" logs/access.log | sort | uniq
```

</details>

---

## Challenge 3 — How many requests were NOT successful (not 200)?

<details>
<summary>Solution</summary>

```bash
grep -v "200" logs/access.log | wc -l
```

</details>

---

## Challenge 4 — Find all 404 and 403 responses

<details>
<summary>Solution</summary>

```bash
grep -E "403|404" logs/access.log
grep -E "403|404" logs/access.log | wc -l
```

</details>

---

## Challenge 5 — Security scan: find any file containing `password`

<details>
<summary>Solution</summary>

```bash
grep -rni "password" configs/
```

</details>

---

## Challenge 6 — Show the last 5 errors

<details>
<summary>Solution</summary>

```bash
grep "ERROR" logs/app.log | tail -5
```

</details>

---

## Challenge 7 — Which config files mention `port`? Show their sizes too.

<details>
<summary>Solution</summary>

```bash
grep -ril "port" configs/
grep -ril "port" configs/ | xargs du -sh
```

</details>

---

## 💿 Disk Space Challenge — How much total space is used on your system?

```bash
df -h
du -sh .
du -sh */ | sort -h
find . -type f | xargs du -sh | sort -rh | head -5
```

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
