# Amnesia Shift

## TICKET
You're paged onto a server you've never touched. The previous admin, dana,
left for vacation and is unreachable. Their handover note (it greets you at
login) claims: CentOS 7, 64 cores, 128G RAM, rebooted an hour ago, everyone
uses zsh, "nothing weird in my session history."

Trust nothing. Verify every single claim against the box itself, and dig
through the session history dana left behind — decide if anything in it
deserves escalation. Build a corrected handover file at `~/handover.txt`:
start it with a title line, then append each verified fact one at a time as
you confirm it (do not retype the file each time). Finish by appending who
is logged in right now and what identity you are working as.

## COMMANDS
whoami who w hostname uname uptime date free lscpu cat echo history command -v

## QUESTIONS
1. Hands-on: without opening the file in an editor, show only the last 3 lines you appended to `~/handover.txt`, then show how many lines the whole report has.
2. Hands-on: one line in dana's history is a genuine security incident. Which one, and what exactly makes it dangerous?
3. Interview: you SSH into a box during an outage. What are the first five things you check before changing anything, and why in that order?
4. Interview: `uptime` shows load average `12.0, 3.0, 0.5` on a 4-core machine. Walk me through what that tells you and what you'd look at next.
5. Interview: what's the difference between the kernel and the distribution? Where did each of your verification commands get its answer from?
