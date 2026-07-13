# Ticket #4211 — Pre-migration audit of vetusto-prod-03

From: Marta (team lead)
To:   dev

We absorbed this box from R. Ortiz's outfit last week. He's not answering
email anymore, so what's on the machine is all we have. Before we migrate
services off it and wipe it, I need a proper audit on file.

Two claims from his handover email that I frankly don't believe:

1. "I never used the root account on this machine."
2. "I never installed any network-scanning tools."

Verify or refute both. Whatever verdict you reach, I want the evidence
written down — the auditors won't take "trust me".

The handover email included the root password: `hunter2`. Use it if you need
to; the box gets wiped after migration anyway.

Fill in every field of `~/report.md` (Part 1). My field notes are in
`~/cheatsheet.md` if you get stuck on something unfamiliar. When you think
Part 1 is complete, run `check`.

— M.
