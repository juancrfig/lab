# DevOps Gym

Scenario-based Linux/DevOps practice in a single shared Docker container. Each
scenario is a ticket in `pool/<topic>/<scenario>/guide.md` describing a broken
or misconfigured state. You investigate and fix it using only the shell and
built-in documentation. The container is rebuilt fresh every session.

## Rules

1. **Read only the scenario's `guide.md` before solving.** The ticket names
   symptoms, never commands.
2. Inside the container, start from the guide rendered by `./gym`.
3. `man`, `--help`, and online docs are always fair game. That's not cheating;
   that's the job.
4. There is no `check.sh`. Verify your fix yourself, then answer the ticket's
   concept questions and review them with Claude.
5. Concept questions go back to Claude for review after you've solved the box.

## Workflow

Two tmux panes.

```
# pane A — the guide (spaced-repetition picker + ticket/commands/questions)
./gym                       # lists today's due tickets, pick one
./gym <topic>/<scenario>    # or open one directly
                            # t/c/q switch pages · x = done → grade it

# pane B — the environment
./run.sh      # builds the image and drops you into the container
              # exit wipes the container (--rm); run again for a fresh box
```

Grading (`x` in the guide) drives a Leitner spaced-repetition schedule stored
in `.gym-ledger`; every grade is logged to `.gym-history`. When you wonder if
the scheduler needs upgrading, tell Claude to run `DIAGNOSTIC.md`.

## Topics

| Topic | Theme |
|---|---|
| `01-orientation` | You're on an unfamiliar box. Find out everything about it. |
| `02-files` | Filesystem navigation, disk usage, finding things. |
| `03-text` | Extracting answers from logs and configs. |
| `04-users-perms` | Identity, ownership, permission denied. |
| `05-processes` | What's running, what's hung, what shouldn't be there. |
| `06-services` | systemctl/journalctl — parked until we run a systemd PID 1 container. |

## Structure

See `AGENTS.md` for the full design decisions and ticket-adding rules.
