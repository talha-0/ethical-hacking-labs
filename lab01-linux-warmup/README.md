# Lab 1 - Linux Warmup

## Goal
Get comfortable administering a Linux (Ubuntu) host: editing files, finding
things on the filesystem, basic network inspection, capturing and replaying
HTTP traffic, and managing services and processes.

## Tools and techniques
vim, `find`, `grep`, `chmod`, `ifconfig`/`ip`, `route -n`, `netstat`, `lsof`,
`wget`, `tcpdump`, `netcat`, `ps`, `service`, and a small Python script.

## What I did
- Used vim scripted edits on a 100-line file: jump to a line, substitute across
  the file, and delete on a specific line.
- Located a hidden file with `find` and searched `/etc` with recursive `grep`
  to find where a certificate file was referenced.
- Turned off Apache directory listing for a web folder and its subfolders using
  `chmod 711` applied recursively with `find -exec`.
- Listed the host's IP addresses, network adapters and MAC addresses, read the
  routing table to see which adapter reaches an external host, and listed open
  ports with `netstat` and mapped them to the services behind them.
- Downloaded a page's HTML with `wget`, captured a login over loopback with
  `tcpdump`, then rebuilt the raw HTTP POST and replayed it with `netcat`
  (`req.txt`) to reproduce the authenticated request.
- Restarted the Apache service and counted its running worker processes.

## Bonus - savepasswd.py
A file-integrity script for a contest scenario. On start it makes a one-time
backup of `/etc/passwd`, then loops forever restoring the file from that backup
every 30 seconds and appending a timestamped line to a log. I set it to run at
boot from `rc.local` and confirmed it was running and reverting test changes.

## Result
All tasks completed. The replay request returned HTTP 200 and set the expected
session cookie; the boot script restored a planted test marker on its next
interval.

## Files
- `vim.txt`, `req.txt` - artifacts produced during the lab
- `savepasswd.py` - the integrity-restore script
