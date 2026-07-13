# Audit report — vetusto-prod-03

Requested by: Marta · Ticket #4211

## Part 1 — Facts

Machine-checked by `check`. Keep each line exactly in the `- key: value`
format. Conventions: yes/no answers where the question is yes/no;
`memory-gb` as a whole number of GiB; `contractor-claim-verdict` as
confirmed or refuted; `last-root-login` as a date.

- hostname: 
- distro: 
- kernel: 
- user: 
- uid: 
- user-groups: 
- cpu-count: 
- memory-gb: 
- login-shell: 
- nmap-installed: 
- docker-installed: 
- deploy-env: 
- others-logged-in: 
- contractor-claim-verdict: 
- last-root-login: 
- evidence: 

## Part 2 — Concepts

No script can grade these. Answer in your own words, then take them to
Claude for review after Part 1 passes — that's the real exam.

### C1
`uname -r` reports a kernel version — but look inside `/boot`. Explain the
mismatch. What kind of "machine" is this really?

### C2
Compare what `uptime` reports against when this box actually started (you
watched it start minutes ago). What is uptime actually measuring here, and
why?

### C3
You read three different `.bash_history` files during this audit. Why does
each user have their own? When does a command actually get written to it?
