# PROTOTYPE — shared sample content. Wipe me.
# Same fake scenario for all 4 variants so you judge FEEL, not content.

DAY=14
TOPIC="03-text / 02-log-triage"
TICKET="sshd on web-prod-02 is getting hammered. Ops wants the top 3 source
IPs by failed-login count, and the total number of failures, on file
before they open a firewall ticket."
CONCEPTS=(
  "grep -c            count matching lines"
  "cut -d' ' -fN      pull a column out of a line"
  "sort | uniq -c     tally duplicates"
  "sort -rn | head    top-N by count"
  "awk '{...}'        when cut isn't enough"
)
# Commands page — NAMES ONLY (you recall what they do)
COMMANDS=(grep cut sort uniq head awk wc)
# Questions page — interview Qs mixing theory + the hands-on task
QUESTIONS=(
  "Why does 'sort | uniq -c' need the sort first?"
  "grep -c vs 'grep | wc -l' — when do they disagree?"
  "cut -d' ' breaks on runs of spaces in this log. Why, and what fixes it?"
  "What's the total-failures number, and which stage of your pipe produced it?"
  "If the log rotates to .gz mid-investigation, how do you keep grepping it?"
)
# stepped hints (variant 3) — progressive, never the full answer
STEPS=(
  "Find the log. Where do failed ssh logins land on a Debian box?"
  "Isolate only the failure lines. What word do they all share?"
  "From each failure line, extract just the source IP."
  "Tally identical IPs, then order the tally biggest-first."
  "Read the total failures off your own pipeline — no re-counting by eye."
)
