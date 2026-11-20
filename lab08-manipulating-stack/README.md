# Lab 8 - Manipulating the Stack

## Goal
Understand the layout of a function's stack frame in detail and use that
knowledge to overwrite the saved return address and control where a vulnerable
program jumps when it returns.

## Tools and techniques
C, g++ (compiled with `-fno-stack-protector`), GDB (breakpoints, memory and
register dumps, reading saved EBP and return address), stack-frame analysis, and
crafted input built with Perl.

## What I did
- Compiled a small recursive program with stack protection off, broke at a chosen
  line, and recorded the local variables, their addresses, EIP, EBP, ESP, the
  saved previous EBP, and the saved return address. Drew the stack-frame diagram
  from those values.
- Built a Perl-generated input string to overflow a buffer in a vulnerable
  program so that, when it crashes, it is about to return to a controlled address
  (`0x41414141`), and confirmed the overwrite with GDB's stack and register dumps.
- Sized the attack string precisely so that instead of crashing, the program
  returns into a function repeatedly, producing a loop of its output - showing
  control of the return address rather than just a crash.

## Result
All tasks completed. GDB confirmed the return address was overwritten with the
intended value, and the second attack produced the repeated-call behavior.

## Files
Code: none for this lab. The target programs (fib.cc, meet.cc) were
course-provided; the work was the GDB analysis and the crafted input strings,
which are in the report.
