# DevOps Gym

Scenario-based DevOps practice. Each scenario is a Docker container or local environment with a broken or misconfigured state, plus a ticket. You investigate, fix, or answer using only the shell and documentation. No scenario ever tells you which command to run.

## Rules

1. **Read only the scenario's `README.md` before solving.** Everything under `internals/` is spoilers (the scripts that fabricate the broken state). Read them *after* solving — that post-mortem is shell-scripting practice.
2. Inside the container/environment, start at `~/brief.md` or the scenario's guide.
3. `man`, `--help`, and online docs are always fair game. That's not cheating; that's the job.
4. When you think you're done, run `check` inside the environment.
5. Concept questions (the ones a script can't grade) go back to Claude for review after `check` passes.

## Workflow

Two tmux panes. Guide on one, the box on the other.

```
# pane A — the guide (spaced-repetition picker + ticket/commands/questions)
./gym                       # lists today's due tickets, you pick one
./gym <topic>/<scenario>    # or open one directly
                            # t/c/q switch pages · x = done → grade it

# pane B — the environment
cd <topic>/<scenario>/
./run.sh      # builds the image (first time) and drops you into the environment
              # exit and ./run.sh again to resume where you left off
./reset.sh    # wipe the container and start the scenario fresh
```

Grading (`x` in the guide) drives a Leitner spaced-repetition schedule stored in `.gym-ledger`; every grade is logged to `.gym-history`. When you wonder if the scheduler needs upgrading, tell Claude to run `DIAGNOSTIC.md`.

## Topics

| Topic | Theme |
|---|---|
| `01-orientation` | You're on an unfamiliar box. Find out everything about it. |
| `02-files` | Filesystem navigation, disk usage, finding things. |
| `03-text` | Extracting answers from logs and configs. |
| `04-users-perms` | Identity, ownership, permission denied. |
| `05-processes` | What's running, what's hung, what shouldn't be there. |
| `06-docker` | Container basics, images, running containers. |
| `07-networking` | DNS, routing, connectivity troubleshooting. |
| `integration` | Multi-topic tickets. The hard ones. |
