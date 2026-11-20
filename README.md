# Ethical Hacking Labs (CSC 215)

Lab work from CSC 215, Secure Systems / Ethical Hacking, a graduate course at
Hofstra University. Each folder is one lab: a short write-up of what the task
was, how I approached it, and the result, plus the code I wrote for that lab.

The write-ups are in my own words. Code I wrote is included; files that were
provided by the course and that I only analyzed are named but not included.

## Labs

| Lab | Folder | Skills |
| --- | --- | --- |
| 1 | `lab01-linux-warmup` | Linux admin: find/grep, permissions, networking, tcpdump + netcat replay, a Python integrity-restore script |
| 2 | `lab02-dns-port-scan` | BIND9/DNS config and troubleshooting, DNS enumeration, host discovery, nmap port/service mapping, OS fingerprinting |
| 3 | `lab03-metasploit-practice` | Metasploit exploitation, Meterpreter post-exploitation, Armitage, layered defense design |
| 4 | `lab04-web-app-security-ruby` | HTTP command injection, netcat automation in Python, patching a C program against injection, Ruby basics |
| 5 | `lab05-metasploit-exploit-development` | Reading and writing Metasploit Ruby modules, debugging with ruby-debug, payload/handler internals |
| 5.5 | `lab05b-ictf` | Attack/defense CTF, cookie manipulation, PHP file inclusion, multi-step exploit automation in Ruby |
| 6 | `lab06-c-and-gdb` | C pointers, printf internals, GDB inspection of memory/registers/disassembly |
| 7 | `lab07-x86-assembly` | x86 assembly, execve, mapping C to assembly, machine-code extraction |
| 8 | `lab08-manipulating-stack` | Stack-frame analysis, overwriting the saved return address, controlled redirection |
| 9 | `lab09-buffer-overflow` | Shellcode analysis, position-independent shellcode, full buffer-overflow exploitation, IPS defense |

## Lab environment

The labs ran on a self-contained virtual network described in the course
materials: a Linux (Ubuntu) image as the main target and DNS/web host, a
Windows XP image, and BackTrack 5 as the attacker machine, on a private
link-local segment with no internet access. Targets were intentionally
vulnerable services set up for the course (a classroom web app, and an image
based on the UCSB iCTF 2007 game). Tooling included Metasploit, nmap, GDB, g++,
Wireshark/tcpdump, netcat and standard Linux utilities.

## Credentials in the code

Any usernames and passwords in these files (for example `stu1` / `abc123`) are the default test accounts of the classroom targets. They are not real accounts and exist only inside the lab images.

## Ethics

All of this work was done inside an isolated course lab environment, against
targets that were intentionally vulnerable and set up for the class. No system
outside that lab was touched. The exploit code here only makes sense against
those specific lab targets and is published to show the techniques I learned,
not to attack real systems. Finding and exploiting vulnerabilities on systems
you do not own or have explicit permission to test is illegal.
