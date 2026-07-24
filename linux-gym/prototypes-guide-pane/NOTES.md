# Prototype — guide-pane feel

**Throwaway.** Delete once decided. Pure bash, no deps.

## Question
Real friction = content sprawl (4 files) + no daily on-ramp. tmux handles the
split. So: what should the ONE guide pane feel like?

## Run
```
./1-flat.sh        # static consolidated page, zero interaction
./2-paged.sh       # ticket first, [c] toggles concepts — minimal start
./3-stepped.sh     # vimtutor: ticket + [n] reveals one hint at a time
./4-dashboard.sh   # streak + "today" home screen, Enter → launches brief
```

## Verdict
- [x] chosen: **variant 2 (paged)**
- pages: Ticket / Commands (names only) / Questions (theory + hands-on)
- live key-toggle, no quit (Ctrl-C / close pane), no title, no day number
- next: fold into real `gym` launcher (reads today's scenario + ledger), delete 1/3/4
