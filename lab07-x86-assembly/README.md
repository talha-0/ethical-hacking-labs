# Lab 7 - x86 Assembly

## Goal
Connect C source to the x86 assembly it compiles to, understand how `execve` is
set up at the instruction level, and extract a function's machine code as a byte
array.

## Tools and techniques
C, the `execve` system call, g++ with static linking, GDB (`x/16i`,
disassembly, register inspection), x86 stack-argument layout, and machine-code
extraction.

## What I did
- Read the `execve` man page and explained what it does, what the argument array
  is for, and why that array must end with NULL (there is no length argument, so
  NULL terminates the list).
- Wrote `cat.cc`, which uses `execve` to run `/bin/cat /etc/passwd` and print the
  file's contents.
- Correlated each line of a sample program with its assembly: identified the
  addresses of the constant strings, listed the instructions that build the
  argument array on the stack, and computed the ESP value at a given breakpoint
  from the known address of a local variable.
- Extracted the machine code of the `main` function and expressed it as a C
  `char` array of hex byte escapes.

## Result
All tasks completed. The assembly was mapped back to the source statements, the
ESP calculation matched, and `cat.cc` executes `/bin/cat` through `execve`.

## Files
`cat.cc` - the execve-based program I wrote. The sample `ls.cc` analyzed in this
lab was course-provided and is not included.
