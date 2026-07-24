# Pre-migration audit of an inherited box

## TICKET
You absorbed `vetusto-prod-03` from a contractor who's gone dark. Before it's
migrated and wiped, your lead needs an audit on file. She distrusts two claims
from his handover:

  1. "I never used the root account on this machine."
  2. "I never installed any network-scanning tools."

Verify or refute both, with evidence — auditors won't take "trust me". Root
password `hunter2` is fair game; the box gets wiped anyway.

Fill in Part 1 of `~/report.md` inside the box, then run `check`.

## COMMANDS
id env printenv last man grep

## QUESTIONS
1. Which log does `last` actually read, and what happens to your audit if that file was rotated or truncated?
2. `id` vs the contents of `/etc/passwd` — which tells you what a user *can* do right now, and why?
3. How would you prove a network-scanning tool was installed even if the binary was already deleted?
4. Root left traces in login history — name two independent places the root login shows up.
5. Why is "I never used root" nearly impossible to prove *true*, only to refute?
