# HANDOFF — Linux Gym build session

**For:** the Claude session on Juanes' Linux machine (Docker available there).
**From:** the design session on the Windows work machine, 2026-07-13.
**State:** design fully agreed with Juanes. `README.md` and `.gitattributes` in this
folder already written. Everything else needs building — and **test-building the
Docker image is the first priority**, since the design session had no Docker.

Delete this file once the scenario is built, tested, and the vault tasks are done.

---

## 1. Context (read once, then build)

Juanes is studying KubeCraft "DevOps OS 1" (Mischa van den Burg). Twice before,
his Linux command notes died from retrieval decay → course collapse. This gym is
attempt 3's fix: scenario-based Docker containers instead of passive notes.

Agreed design (do not relitigate — he was grilled on each point):

- **Fixed problems, no regeneration.** He explicitly rejected mutation-on-replay
  for now — anti-overplanning. Revisit only when practice exceeds ~1 hr/day.
- **Topics = folders** (see `README.md` table). Scenarios exercise a 3–5 command
  cluster **plus a "+1 stretch"**: 1–2 commands NOT in his notes that he must
  discover via `man`/searching.
- **Never tell him which command to run.** Tickets are symptom reports and
  questions only. He calls this "not being a monkey typer."
- **He never reads `internals/` before solving** (honor system). Post-solve he
  reviews those scripts as shell practice.
- **Cadence floor:** each foundational topic every ~4 days, integration every
  7–10. Ledger in the vault drives rotation.
- His notes source: vault `0 - Inbox/DevOps OS 1 - Technical Notes.md`.
- `06-services` (systemctl/journalctl) is **parked** until a systemd VM exists.

## 2. Scenario to build: `01-orientation/01-inherited-server/`

### Fiction
Company absorbed a contractor's box, `vetusto-prod-03`. Contractor ("R. Ortiz",
unreachable) claimed in handover: (a) he never used the root account,
(b) he never installed network-scanning tools. **Both are lies** — the evidence
in the box refutes them. Team lead Marta needs an audit report (`~/report.md`)
filled in before migration. Root password from the handover email: `hunter2`.

Login lands the user as `dev` in `/home/dev` with:
- `~/brief.md` — Marta's ticket. Fiction, the two claims to verify, the root
  password, pointer to cheatsheet, instruction to fill `~/report.md` then run `check`.
- `~/report.md` — the template (Part 1 facts, Part 2 concepts; format below).
- `~/cheatsheet.md` — framed as Marta's field notes: one-liners for the three
  stretch commands **`id`**, **`env`/`printenv`**, **`last`** (first exposure;
  Juanes asked for a reference so he isn't stranded). Include "when in doubt: `man`".

### Commands the scenario must force (from his notes)
`whoami`, `who`, `w`, `hostname`, `uname -a`, `uptime`, `date`, `lscpu`,
`free -h`, `cat /etc/os-release`, `echo $SHELL`, `history` (reading others'
`.bash_history` files), `command -v`, `su`. Stretches: `id`, `env`, `last`.

### Evidence chain (what setup.sh fabricates)
- Users: `dev` (groups `developers`, `ops`), `contractor`, `marta`. Root pw `hunter2`.
- `/home/contractor/.bash_history`: normal work, then `su -`, an
  `nmap -sn 10.0.0.0/24` run. `/root/.bash_history`: `apt-get install -y nmap`,
  a failed cover-up `history -c` as last line (irony intended).
- `chmod 700 /home/contractor` (and `/root` is 700 already) → reading the
  histories REQUIRES `su` with the handover password. This is deliberate.
- `nmap` installed (refutes claim b via `command -v nmap` + root history).
  Docker NOT installed (report asks, answer "no").
- `export DEPLOY_ENV=prod-eu-1` in `/etc/profile.d/deploy-env.sh` → forces `env`.
- Fabricated login records (see §3): `/var/log/wtmp` shows root login from
  pts/1 on **2026-07-10 09:14 UTC**, logout 09:52 (refutes claim a; found via
  `last`); plus an older marta session. `/var/run/utmp` shows **marta currently
  logged in** on pts/0 → `who`/`w` show her ("who else is on this box?").

### `~/report.md` template — Part 1 fields (machine-checked)
One per line, exactly `- key: ` so `check` can parse (`grep '^- key:'`, take
everything after the first colon, trim):

`hostname`, `distro` (name+version), `kernel`, `user`, `uid`, `user-groups`,
`cpu-count`, `memory-gb` (integer GiB), `login-shell`, `nmap-installed` (yes/no),
`docker-installed` (yes/no), `deploy-env`, `others-logged-in`,
`contractor-claim-verdict` (confirmed/refuted), `last-root-login` (date),
`evidence` (free text, ≥1 line).

### `check` (install as `/usr/local/bin/check`, runs as dev, bash)
Computes expected values LIVE (no hardcoded spoilers): hostname↔`hostname`,
distro contains "debian" AND "12", kernel contains `uname -r`, user=dev,
uid=`id -u`, user-groups contains "developers" AND "ops", cpu-count=`nproc`,
memory-gb within ±1 of `free -g` Mem total, login-shell contains "bash",
nmap-installed contains "yes", docker-installed contains "no",
deploy-env contains "prod-eu-1", others-logged-in contains "marta",
verdict contains "refut", last-root-login contains "Jul 10" OR "07-10",
evidence non-empty. Per-field OK/FAIL lines, summary, and on all-pass:
"Facts verified. Now take Part 2 to Claude for review — that's the real exam."

### Part 2 — concept questions (Claude-graded, not scripted)
- **C1:** "`uname -r` reports kernel X, but look inside `/boot`. Explain the
  mismatch. What kind of 'machine' is this really?" (containers share host kernel)
- **C2:** "`uptime` says this box has been up N days, but you know it started
  minutes ago. What is uptime actually measuring here, and why?"
- **C3:** "You read three different `.bash_history` files. Why does each user
  have their own? When does a command actually get written there?"

### Files
```
01-orientation/01-inherited-server/
  README.md    # ticket teaser + run instructions + spoiler warning. Never names commands.
  run.sh       # if container gym-orient-01 exists: docker start -ai; else
               # docker build -t gym/orient-01 internals/ && docker run -it \
               #   --name gym-orient-01 --hostname vetusto-prod-03 gym/orient-01
  reset.sh     # docker rm -f gym-orient-01 (confirm prompt optional)
  internals/   # Dockerfile, setup.sh, mkutmp.pl, brief.md, report.md, cheatsheet.md, check.sh
```

## 3. Implementation notes (hard-won, don't rediscover)

- **Base:** `debian:bookworm`. Packages: `procps` (w, free, ps), `util-linux`
  (lscpu, last, utmpdump), `man-db`, `manpages`, `less`, `nano`, `vim-tiny`, `nmap`.
  `hostname`, `login` (su), `passwd` (chpasswd, useradd) are in the base image.
- **Man pages:** Debian Docker images block them via
  `/etc/dpkg/dpkg.cfg.d/docker*` path-excludes. `rm` that config FIRST, then
  `apt-get install --reinstall -y coreutils util-linux` so `man id`, `man env`,
  `man last` exist — they're the stretch commands' docs; without this the
  scenario's "discover via man" mechanic is broken.
- **wtmp/utmp fabrication:** DON'T hand-write `utmpdump -r` input — its parser
  is rigid and undocumented. Write `mkutmp.pl` (perl-base is in the image) that
  `pack`s x86_64 `struct utmp` records (384 bytes):
  `pack("s x2 l a32 a4 a32 a256 s s l l l l4 a20", type, pid, line, id, user, host, 0,0, session, tv_sec, tv_usec, 0,0,0,0, "")`.
  Records: wtmp = USER_PROCESS(7)+DEAD_PROCESS(8) pairs for root
  (tv_sec 1783674862 → 2026-07-10 09:14:22 UTC; logout 1783677130) and marta
  (1783843200/1783846800); utmp = one USER_PROCESS marta pts/0 (1783927800).
  chmod 644 both files. **Verify tv_sec math against `date -d @…` when testing.**
- **Build-time asserts in Dockerfile (critical — nothing was testable at design
  time):** `last -f /var/log/wtmp root | grep -q root` and
  `who /var/run/utmp | grep -q marta` — build must FAIL if fabrication is wrong.
  Also assert `su` works non-interactively? (skip — just test manually once).
- **Container runs as `USER dev`, `CMD ["bash","-l"]`** (login shell so
  `/etc/profile.d/` loads DEPLOY_ENV).
- **Test protocol before handing over:** build; run; confirm `who` shows marta,
  `last` shows the Jul 10 root session, `su -` accepts hunter2, `man last`
  works; fill a correct report and run `check` (all pass), then break one field
  (expect that FAIL). THEN tell Juanes it's ready.

## 4. Vault tasks (vault repo, may need pulling on the Linux machine)

1. `0 - Inbox/DevOps OS 1 - Technical Notes.md`: fix `/prod` → `/proc`
   (typo, already flagged to him — he agreed). Add a small "Stretch commands
   (met in the gym)" section: `id`, `env`/`printenv`, `last`, one line each.
2. Create `0 - Inbox/Linux Gym - Ledger.md`: table
   `command | topic | scenario | last exercised`, seeded with all commands from
   his Technical Notes grouped by the topic table in `README.md`. Orientation
   rows point at `01-inherited-server`, last-exercised blank until he solves it.
   This ledger drives scenario rotation (stalest topic gets the next scenario).

## 5. Voice & guardrails for working with Juanes

- He asked to be grilled and pushed back well — treat him as a peer, correct
  him explicitly (his `# Insights` convention: confirm or correct, never nod along).
- Fundamentals-first: when a task involves searching/navigating, show the
  portable-tool way (grep/find/man), not editor features.
- Don't overbuild. He deferred spaced-repetition tooling and scenario
  regeneration ON PURPOSE. One tested scenario beats three untested ones.
