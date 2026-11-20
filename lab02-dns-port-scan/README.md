# Lab 2 - DNS Setup and Port Scan

## Goal
Troubleshoot and configure a partially working DNS server for a lab network
segment, compare DNS and host-discovery tools, scan for open ports and running
services, and fingerprint a host's OS.

## Tools and techniques
BIND9 (named), DNS enumeration tools (Dnsdict6, Dnsmap, Fierce, ReverseRaider),
host-discovery tools (alive6, netdiscover, nmap, netifera), `nslookup`,
`lsof`, and OS fingerprinting with Xprobe2, Nmap and Zenmap.

## What I did
- Enumerated the names and aliases in the lab domain with four different DNS
  tools and recorded which tool found which record. Noted that the tool that
  attempts a zone transfer first recovered every record, while the
  dictionary-based tools missed names not in their wordlists.
- Added a new A record to the BIND9 zone, mapping a hostname to an IP, and
  verified it with `nslookup` against the domain server.
- Disabled DNS zone transfer, restarted the BIND9 service (without rebooting),
  and confirmed the change by re-running the zone-transfer tool.
- Discovered live hosts on the subnet with four discovery tools and compared
  their coverage.
- Scanned a host with nmap for open ports, then logged in and used `lsof` to map
  each public port to the absolute path of the process listening on it
  (Apache, sshd, inetd, named, gmetad).
- Fingerprinted the host OS with three tools and compared their kernel-version
  guesses.

## Ethics question
The lab included a written question on the legal exposure of a penetration
tester who discloses a vulnerability against a software vendor's wishes. I
worked through it under anti-circumvention rules, the CFAA, and contract/EULA
terms, distinguishing black-box fuzzing of a licensed copy from unauthorized
access to the vendor's own systems.

## Result
All tasks completed. DNS records resolved after the edit, zone transfer was
confirmed disabled, port-to-process mapping was produced, and the three
fingerprinting tools returned close kernel-version estimates.

## Files
Code: none for this lab. The report held the
answers and screenshots.
