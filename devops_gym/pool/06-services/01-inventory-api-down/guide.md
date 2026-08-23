# Inventory API Down

## TICKET
The inventory API disappeared after last night's configuration deployment.
It should be enabled at boot and listening on port 8088, but clients cannot
reach it. Operations says it briefly starts, vanishes, and repeats.

Diagnose and restore it without running the program by hand:
1. Establish the service's current state, whether it is enabled, and its
   recent failure history.
2. Follow its live logs through at least one failed restart and identify the
   exact startup complaint.
3. Inspect the unit definition and its referenced configuration. Correct the
   smallest broken piece, reload manager configuration if required, and
   restart the service through its supervisor.
4. Prove the repair: it remains active across several heartbeats, reports the
   expected port, and has no new failed starts. Save the evidence in
   `~/inventory-recovery.txt` using redirection rather than an editor.

## COMMANDS
systemctl journalctl cat ls stat grep tail

## QUESTIONS
1. Interview: what is systemd's role as PID 1, and what is the difference between a service unit, a target, and a timer?
2. Interview: distinguish `start`, `restart`, `reload`, `enable`, and `daemon-reload`. Which change requires each, and which operations affect boot versus the current process?
3. Interview: how do unit-level journal filters, boot filters, priority filters, and follow mode narrow an incident timeline? Why is the journal often better evidence than rerunning a failing command manually?
4. Interview: why does killing a supervised process not stop its service? Explain restart policy and the correct operational stop path.