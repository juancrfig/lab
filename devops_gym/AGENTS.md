# AGENTS.md — devops_gym

Single shared Docker container for all DevOps/Linux gym tickets. Fresh build per
session; `--rm` so no state persists between runs. Juanes opens the container
himself — agents only write guides and setup.sh broken states.

## Structure

```
devops_gym/
├── Dockerfile       ← ubuntu:24.04, user juanes (NOPASSWD sudo)
├── setup.sh         ← fabricates broken state; grows as tickets are added
├── run.sh           ← docker build + docker run --rm -it --hostname devops-lab
└── pool/
    ├── 02-files/
    │   └── <scenario>/guide.md
    ├── 03-text/
    │   └── <scenario>/guide.md
    └── 04-users-perms/
        └── <scenario>/guide.md
```

## Container decisions (settled)

- One container, all topics. Base: `ubuntu:24.04`.
- Fresh build per session (`./run.sh` always rebuilds). `--rm` wipes on exit.
- No `check.sh` — concept questions go to Claude post-solve.
- `setup.sh` is one growing file. Refactor only when it hurts.
- Juanes opens the container himself; guide is separate (`linux-gym/gym`).

## Adding a ticket

1. `pool/<topic>/<scenario>/guide.md` — follow the format below.
2. Add broken state to `setup.sh`.
3. `./run.sh` — verify the broken state lands correctly.
4. Update vault ledger: `0 - Inbox/Linux Gym - Ledger.md`.

## guide.md format (parsed by `linux-gym/gym`)

```markdown
# <title>
## TICKET
<symptom — NEVER names a command>
## COMMANDS
cmd1 cmd2 cmd3
## QUESTIONS
1. <theory + hands-on mix>
```

## Design rules

- Never name the command in the ticket. Symptoms only.
- 3–5 command cluster + 1 stretch (not in notes; Juanes must find via `man`).
- `setup.sh` should itself be good shell-scripting practice to read post-solve.

## Command inventory by topic

| Topic | Commands |
|---|---|
| 02-files | ls find file stat wc du df touch rm |
| 03-text | cat head tail grep sort cut tr xargs wc |
| 04-users-perms | groups adduser deluser chmod chown su usermod id |
| 05-processes | ps pgrep kill fg bg pstree free lscpu |
| stretch pool | id env printenv last |
