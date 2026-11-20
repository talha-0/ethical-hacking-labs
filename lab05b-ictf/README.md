# Lab 5.5 - iCTF (UCSB iCTF 2007)

## Goal
Work through an attack/defense CTF setup based on the UCSB iCTF 2007 game:
stand up the grading server and vulnerable services, study how the game is
scored, and develop Metasploit modules that steal and submit flags from the
intentionally vulnerable services.

## Tools and techniques
The iCTF 2007 game image and grading server, BIND/Apache hosting, Metasploit
Ruby exploit modules, HTTP cookie manipulation, PHP local/remote file inclusion,
source-IP spoofing with `ifconfig`, flag forwarding through a proxy service, and
Wireshark/tcpdump for diagnosis.

## What I did
- Installed and ran the grading server, brought up the "Make Amends" and
  "Sound of Music" services, and read the game config to see how teams, services
  and the network are defined.
- Added my own team to the config, pointed at the attacker host, and confirmed it
  on the scoreboard.
- Traced the scoring flow for "Sound of Music": where the flag enters (as the
  registration first name), which PHP file processes it, and where it is stored.
- Ran the provided `amends.rb` module against the Make Amends service to recover a
  credit-card number, then extended it for the "big data" scenario: duplicated
  the image, re-IP'd the copy, registered two teams, and modified the module so
  it attacks one team (EvilTeam2) but submits the flag through a forwarding
  service on the other (EvilTeam1). The module walks the service's multi-step
  flow (amends.php, ltr.php, settlement.php, payoff.php), carrying the session
  cookie between steps and base64-encoding the forward URL into a cookie to
  trigger the inclusion.
- Attacked the "Sound of Music" service through its cookie weakness and wrote
  `music.rb` to automate it end to end.

## The "Sound of Music" vulnerability
The service copies cookie names and values straight into environment variables
and validates its auth cookie against the client IP. `music.rb` logs in from one
IP, switches the attacker's source IP, and replays the same auth cookie so the
host check behaves differently, then injects a `travelscripts` cookie pointing at
a remote PHP file (`ltr3.inc`) hosted on the attacker. The service includes and
runs that file, which reads the flag on the target and writes it where it can be
retrieved. The module then fetches the flag and submits it through the forwarding
server.

## Result
All parts attempted and demonstrated in the report: team creation, the amends
attack recovering the card number, the forwarded-flag scenario, and the cookie
file-inclusion attack recovering and submitting a flag.

## Files
- `amends.rb` - Make Amends exploit module, modified for the forwarding scenario.
- `music.rb` - Sound of Music cookie/file-inclusion exploit module.
- `ltr3.inc` - the remote PHP include dropped on the attacker host to read the
  flag on the target.

## Note on authorship
`amends.rb` carries the upstream author handle `egypt` and was provided by the
course to download and run; my work on it is the big-data modification (targeting
EvilTeam2 while forwarding through EvilTeam1). `ltr3.inc` and `music.rb` are my
own, built on the provided `ltr2.inc` pattern.