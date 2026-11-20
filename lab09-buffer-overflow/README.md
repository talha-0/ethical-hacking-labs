# Lab 9 - Buffer Overflow

## Goal
Study shellcode at the instruction level and carry out a full buffer-overflow
exploit on a vulnerable program, then describe how such attacks can be detected
and defended.

## Tools and techniques
GDB (debugging shellcode, finding system-call arguments, offsets and sizes),
the `int 0x80` system-call convention (`setuid`, `execve`), position-independent
shellcode (JMP/CALL/POP), Perl-crafted payloads, and an exploit generator
(exploit.cc).

## What I did
- Debugged the shellcode in GDB and read out the arguments to its system calls:
  the `setuid` argument, and the three `execve` arguments, confirming the argv
  array held a pointer to `/bin/sh` followed by NULL and the envp array was empty.
- Explained the JMP/CALL/POP ("zigzag") trick: the call pushes the address of the
  following `/bin/sh` data onto the stack and `pop` retrieves it, so the shellcode
  locates its own strings by offset and runs correctly wherever it is loaded.
- Replicated the three-section Perl-command overflow attack on the vulnerable
  program and captured the exploit screen.
- Used an exploit generator to produce a working payload (using GDB to find the
  correct buffer size and offset) and demonstrated a successful exploit.
- Described a firewall/IPS defense with deep-packet inspection: enforce input
  length limits and flag long NOP sleds, repeated return addresses, shellcode
  signatures and suspicious non-printable bytes, as one layer alongside bounds
  checking, stack canaries, ASLR and non-executable memory.

## Result
All tasks completed. The shellcode's system-call arguments were recovered in GDB,
and both the Perl and generated-payload attacks produced a working exploit.

## Files
Code: none for this lab. The target (meet.cc), shellcode.cc and exploit.cc were
course-provided; the work was the GDB analysis and crafted payloads, which are in
the report.
