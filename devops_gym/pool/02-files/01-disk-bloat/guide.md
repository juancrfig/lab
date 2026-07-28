# Disk Bloat

## TICKET
Monitoring fired: the root filesystem crossed its usage threshold overnight.
The app team swears they "only write small session files" under
`/var/appdata`. Nobody knows where the space went.

Produce evidence, then clean up:
1. Find the three files actually eating the space — prove it with numbers,
   largest first, written to `~/bloat-report.txt`.
2. One file in there looks enormous in a directory listing but barely
   occupies disk. Explain the discrepancy in one appended line.
3. The tree is littered with stale `.tmp` session files and empty `.csv`
   exports. Delete all of them in bulk — no manual one-by-one deletion —
   but nothing else. Count what you deleted first.
4. `releases/v1/backup.log` refuses to open as text. Determine what it
   really is before deciding its fate.
5. There's a file whose name contains spaces. Remove it without renaming it.

## COMMANDS
df du find file stat ls wc rm touch

## QUESTIONS
1. Hands-on: rebuild the "top 3 largest files under /var/appdata" evidence as a single pipeline, biggest first.
2. Interview: `df` says the disk is 90% full, but `du` on every top-level directory adds up to half that. Give two distinct explanations and how you'd confirm each one.
3. Interview: you deleted a 30G log file but the disk usage didn't drop. Why, and how do you actually reclaim the space without restarting the service?
4. Interview: what does an inode store, and what two pieces of information does a directory entry actually map together? Why can a filesystem run out of space with `df` showing space free?
