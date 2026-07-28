# Permission Meltdown

## TICKET
A junior "fixed" a deploy problem on the app server last night by running a
recursive ownership-and-mode change across `/srv/app`. Now everything under
it belongs to root and is wide open to the world — secrets included — and
to top it off, the service account `appuser` can't get into its own `data`
directory, so the service crash-loops.

Restore sanity, then prove it:
1. First, capture the damage: a listing of the whole tree with owners and
   modes goes to `~/perm-audit.txt` before you touch anything.
2. Hand the whole tree back to `appuser` and the `app` group in one move.
3. Set correct modes: secrets dir and its contents readable by owner only;
   config readable by owner and group, nobody else; the two operational
   scripts executable by owner and group only; `data` writable by the
   service again. Where files share a pattern, fix them with one command,
   not one-by-one.
4. Verify as the service account itself: become `appuser` and demonstrate
   it can read its config, execute its start script, write into `data` —
   and that a random other user can read none of the secrets.

## COMMANDS
ls stat chmod chown chgrp su id find groups

## QUESTIONS
1. Hands-on: express the final mode of `secrets/db.yml` in both symbolic and octal form, and show a way to verify a mode numerically rather than reading `rwx` strings by eye.
2. Interview: for a *directory*, what exactly do r, w, and x each allow? Why does `x` without `r` on a directory still work if you know a filename inside?
3. Interview: a file is mode 777 but its parent directory is 700 and owned by root — can a normal user read the file? Walk me through how the kernel evaluates the path.
4. Interview: why is a recursive 777 a security incident and not just sloppiness? Name two concrete attacks it enables on this exact app layout.
5. Interview: what is umask, and why did the junior's "fix" work at all — what was probably the original problem?
