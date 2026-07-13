# 01 — The inherited server

**Topic:** orientation · **Container:** `gym-orient-01`

Your company absorbed a contractor's production box, `vetusto-prod-03`. The
contractor is unreachable, and your team lead doesn't trust two claims he made
in his handover email. Log in, look around, and get the audit on file before
the box is migrated and wiped.

Start with `~/brief.md` inside the container.

## Run

```
./run.sh      # first run builds the image; later runs resume where you left off
./reset.sh    # wipe the container and start the scenario fresh
```

When you think Part 1 of the report is done, run `check` inside the container.
After it passes, take Part 2 of the report to Claude — that's the real exam.

## Spoilers

Everything under `internals/` fabricates the scenario state. Don't read it
until `check` passes. Afterwards, do read `internals/setup.sh` and
`internals/mkutmp.pl` — the post-mortem is the shell-scripting half of the
exercise.
