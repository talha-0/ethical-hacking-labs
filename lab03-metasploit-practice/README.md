# Lab 3 - Metasploit Practice

## Goal
Learn the Metasploit workflow against a known-vulnerable target: gain a remote
shell, use Meterpreter for post-exploitation, try the one-click attack tooling,
and then write a practical defense proposal.

## Tools and techniques
Metasploit Framework, the `ms08_067_netapi` exploit, Meterpreter (file upload,
remote execution, `ps`), Armitage (Hail Mary), and defensive tooling named in
the proposal (firewalls, vulnerability scanners, IDS, EDR).

## What I did
- Got a remote shell on a Windows XP target by exploiting `ms08_067_netapi`.
- Used Meterpreter to upload a one-line batch file and execute it on the target,
  then confirmed the spawned process with Meterpreter's `ps` even though it was
  not visible on the target desktop.
- Explored Armitage and its Hail Mary one-click attack against both the Windows
  and Linux targets.
- Tried additional Meterpreter payloads and documented what they do.
- Wrote a layered defense proposal against Metasploit-style attacks: network and
  host firewalls (inbound filtering of SMB/RPC, outbound egress filtering to kill
  reverse callbacks), automated vulnerability scanning, network IDS with current
  rulesets, and EDR for in-memory/behavioral detection.

## Result
All tasks completed. Remote shell and remote execution were demonstrated, and
the defense proposal maps each layer to the specific Metasploit behavior it
counters.

## Files
Code: none for this lab. The report held the
answers and screenshots.
