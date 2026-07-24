# HANDOFF — Ticket design session

**For:** a fresh Claude session on Juanes' Linux machine (Docker available).
**Purpose:** design new gym tickets from Juanes' command notes, then build the
approved ones. **Delete this file when the batch is built and tested.**

Work in caveman style (per global CLAUDE.md). Juanes reads on his phone —
compact, fragments, no filler.

---

## 1. What the gym is now (read once)

Scenario-based practice. Two tmux panes: `gym` (guide) on one, the Docker box
on the other. Juanes solves broken-box tickets using only the shell; scenarios
never say which command to run. This is attempt 3 at beating his notes' retrieval
decay — the fix is daily hands-on tickets, not passive notes.

**It's a DevOps gym, not just Linux** — the pool will grow to docker, k8s, git,
anything valuable on a terminal. Design with that spread in mind.

### Mechanics already built (do NOT relitigate)
- **`gym`** (repo root) — parses each scenario's `guide.md`, shows paged
  Ticket / Commands / Questions; `x` → grade pass/struggle/fail.
- **Leitner spaced repetition** → `.gym-ledger`; every grade logged to
  `.gym-history`. Chosen over SM-2/FSRS deliberately (no overengineering before
  data). `DIAGNOSTIC.md` decides later if/when to upgrade. Don't touch this.
- **Picker shows all due tickets**, no daily cap yet (revisit when a day has 15+).

## 2. The two artifacts every ticket needs

A ticket = **guide.md** (what Juanes reads) + a **runnable box** (what he solves).
A guide with no box is nothing to solve. Both required.

### a) `guide.md` — the format `gym` parses
```markdown
# <ticket title>            ← first line, becomes "TICKET: <title>"
## TICKET
<symptom report / fiction. NEVER names a command. States the problem + what
 to put on file, then "run check when done".>
## COMMANDS
grep cut sort uniq          ← command NAMES only, space/line separated
## QUESTIONS
1. <interview Q mixing theory + the hands-on task — weakest-link graded>
2. ...
```
See `01-orientation/01-inherited-server/guide.md` for a real example.

### b) The box — `internals/` + `run.sh` + `reset.sh`
Copy the scenario-01 pattern:
- `internals/Dockerfile` — base image, users, installs.
- `internals/setup.sh` — fabricates the broken/suspicious state.
- `internals/check.sh` — grades Part 1 machine-checkable answers (`check` in box).
- `internals/brief.md` — in-box ticket + any first-exposure cheatsheet.
- `run.sh` / `reset.sh` — build/resume/wipe (copy verbatim, change the name).

## 3. Design conventions (agreed, do not relitigate)
- **Never tell him which command to run.** Tickets = symptoms + questions only.
  ("not being a monkey typer.")
- **3–5 command cluster + a "+1 stretch"** — 1–2 commands NOT in his notes he
  must discover via `man`/searching.
- **`internals/` is spoilers** — he won't read before solving (honor system);
  post-solve he reads the scripts as shell practice. So write setup.sh to BE
  good shell-scripting practice.
- **Machine-check what you can** (`check.sh` greps a `~/report.md`); concept
  questions go to Claude after check passes → these are the guide's QUESTIONS.
- `06-services` (systemctl/journalctl) is **parked** until a systemd VM exists.

## 4. The notes (source of truth for command coverage)
`~/Repositories/vault/1 - Projects/DevOps/DevOps OS 1 - Technical Notes.md`

Command inventory by topic:
- **01-orientation:** whoami who w hostname pwd uptime uname date lscpu free
  cat /etc/os-release. (Scenario 01 already built — audit/inherited box.)
- **02-files:** ls find file stat wc du df touch rm. (find is flagged
  important: by name/regex/type/size.)
- **03-text:** cat head tail (tail -f) grep sort cut tr xargs wc.
- **04-users-perms:** groups adduser deluser chmod chown -R su usermod id.
- **05-processes:** ps/ps aux pgrep kill fg bg pstree free lscpu (& backgrounding).
- **stretch pool (already "met in gym"):** id, env/printenv, last.

## 5. Task for the session
1. Pick the batch with Juanes (suggest: **3 designs across 02-files, 03-text,
   04-users-perms** to test the format spread — but let him choose).
2. **Design first** (title + broken state + commands forced + check criteria per
   ticket). Get his approval on the batch.
3. **Then build** the approved ones: guide.md + internals + run/reset, and
   **test-build the Docker image** — that's the priority gate before calling a
   ticket done.
4. Number scenarios per topic (`02-files/01-...`, `02`, ...). Update the vault
   ledger (`0 - Inbox/Linux Gym - Ledger.md`) with which commands each exercised.
5. Commit per built+tested scenario. Delete this handoff when the batch is done.
