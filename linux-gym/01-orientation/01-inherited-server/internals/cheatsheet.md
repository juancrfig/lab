# Marta's field notes

Things I always forget on unfamiliar boxes:

- `id` — who am I *really*: uid, gid, and every group I belong to.
  `id <user>` works for other accounts too.
- `env` (or `printenv`) — dump the environment. Deployment settings love
  hiding in there.
- `last` — login history for the whole box: who, from where, when, and for
  how long. Reads `/var/log/wtmp`. `last <user>` filters to one account.

When in doubt: `man <command>`. The man pages are installed here, I checked.
