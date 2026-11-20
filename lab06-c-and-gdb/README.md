# Lab 6 - C Pointers and GDB

## Goal
Practice low-level C (formatted output, pointers, pointers-to-pointers) and learn
to inspect a running program with GDB: reading variables, addresses, registers,
and the disassembly behind a source line.

## Tools and techniques
C, `printf` format specifiers (including `%n`), pointer and double-pointer
addressing, g++, and GDB (breakpoints, variable and register inspection,
disassembly).

## What I did
- Wrote `Problem1.cc` to print every integer from -65536 to 65535 with its value
  and its 8-digit zero-padded hexadecimal form.
- Completed a short program using `%n` so a counted-output format writes the
  value 200 back into a variable.
- Worked through pointer and pointer-to-pointer questions by reasoning about
  stack addresses, then confirmed the addresses of each variable, `&p`, `&q` and
  `q` under GDB.
- Used GDB on a bubble-sort program (without editing it): found loop-counter
  values at a given breakpoint and array state, dumped variable values and their
  addresses in hex, read the start address of an array and the EIP register, and
  listed the assembly instructions a specific source line compiled to.

## Result
All tasks completed. GDB-observed addresses and the disassembly matched the
expected layout for each source line.

## Files
`Problem1.cc` - the hex-printing program I wrote. The other programs in this lab
(setvar.cc, pointer1.cc, bubble_sort.cc) were course-provided files I only
analyzed in GDB and are not included.
