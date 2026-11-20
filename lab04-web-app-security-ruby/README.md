# Lab 4 - Web App Security and Intro to Ruby

## Goal
Exploit a command-injection flaw in a classroom web app, automate the attack,
patch the vulnerable C program so the attack fails, and complete a set of Ruby
exercises.

## Tools and techniques
HTTP command injection, `netcat`, Python (`urllib`, `subprocess`, `crypt`),
C input validation, and Ruby (loops, arrays, hashes, regular expressions).

## What I did
- Exploited the vulnerable page manually by injecting shell commands through a
  request parameter.
- Wrote `hack.py` to automate the same attack with netcat: it URL-encodes an
  injected command and sends a crafted HTTP request, looping to create ten user
  accounts in one run and then reading back the account file to confirm.
- Patched the vulnerable C program (`myexec.c`): it now rejects input containing
  shell metacharacters (`; & | > < $ ` \`) before calling `system()`, so the
  injection that worked before now fails.
- Ruby exercises:
  - `ruby1.rb` - prints the first 100 odd numbers.
  - `ruby2.rb` - builds an array 1..1000 and prints it three ways (for loop,
    while loop, and iterator).
  - `ruby3.rb` - word-frequency counter for a text file using a hash.
  - `ruby4.rb` - lowercases HTML tag names only, using a regex so attribute
    values and URLs keep their original case.

## Result
All tasks completed. The automated attack created the accounts, and after the
patch the same injection is detected and rejected.

## Note on the patched C file
The assignment asked for the patched file as `new_myexec.c`; it is kept here as
`myexec.c`. It is the hardened version (it contains the metacharacter check), not
the original vulnerable program.

## Files
`hack.py`, `myexec.c` (patched), `ruby1.rb`, `ruby2.rb`, `ruby3.rb`, `ruby4.rb`
