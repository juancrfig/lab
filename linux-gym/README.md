# Linux Gym

Scenario-based Linux practice. Each scenario is a Docker container with a broken
or suspicious state baked in, plus a ticket. You investigate and fix/answer using
only the shell. No scenario ever tells you which command to run.

## Rules

1. **Read only the scenario's `README.md` before solving.** Everything under
   `internals/` is spoilers (the scripts that fabricate the broken state).
   Read them *after* solving — that post-mortem is shell-scripting practice.
2. Inside the container, start at `~/brief.md`.
3. `man` and `--help` are always fair game. That's not cheating; that's the job.
4. When you think you're done, run `check` inside the container.
5. Concept questions (the ones a script can't grade) go back to Claude for
   review after `check` passes.

## Workflow

```
cd <topic>/<scenario>/
./run.sh      # builds the image (first time) and drops you into the box
              # exit and ./run.sh again to resume where you left off
./reset.sh    # wipe the container and start the scenario fresh
```

## Topics

| Topic | Theme |
|---|---|
| `01-orientation` | You're on an unfamiliar box. Find out everything about it. |
| `02-files` | Filesystem navigation, disk usage, finding things. |
| `03-text` | Extracting answers from logs and configs. |
| `04-users-perms` | Identity, ownership, permission denied. |
| `05-processes` | What's running, what's hung, what shouldn't be there. |
| `06-services` | systemd — parked until the gym runs on a VM. |
| `integration` | Multi-topic tickets. The hard ones. |

The ledger tracking which commands each scenario exercised lives in the vault:
`0 - Inbox/Linux Gym - Ledger.md`.
