# 2026-11-19
## [Implemented the STATUS Telnet option.](4bbd450)
The implementation utilizes [the JFFO instruction](https://www.inwap.com/pdp10/hbaker/pdp-10/Shifting.html), and [HAKMEM item 169](https://www.inwap.com/pdp10/hbaker/hakmem/hacks.html#item169), see NVSBTS and ITM169 in `TVTSRV.MAC`. in TVTSRV.MAC.

# 2026-11-17
## [Workaround for FLKINT problem.](a3a6891)
The problem was previously described as related to making outgoing connections, but turned out to be happening when FINGER was run (even locally) if a job exists that connects (in) over Chaosnet. The FLKINT BUGINF happened when `GTDOM%` was called internally (in CVRRH in TTCHDV.MAC) when `NTINF%` is called in `<FINGER>GETLOC` which is linked with FINGER. The workaround was to use `GTHST%` instead of `GTDOM%` in `NTINF%` (CVRRH), but the real cause (in GTDOM) should be found at some point.

# 2026-11-10
## [Avoid BUGHLT if Internet is not up](254ce29)
When booting a Chaosnet system where Internet is not up (e.g. due to `DBUGSW` being 2), you got `BUGHLT CHIQ`. This is because `ASNIQ%` fails, since no IP queue can be assigned with Internet being down. The fix is to use similar logic as `INTBP0` (the Internet Fork), by waiting for `NETSUP` to become non-zero (and then allow Internet to come up).

Also avoid setting CHAON (whether Chaosnet is up) in CHARLD, and instead setting it after Chaosnet is actually up.

Also moved the initialization of MYHNAM and MYPNAM to separate procedure

## [Fix .GTHNS function](dd543ca)

The .GTHNS function of GTHST% didn't work due to one typo, and masking the address when normalizing the input host number even if it was an "UNternet" Chaosnet address.

Also allow lowercase "c" when parsing `CHAOS NNNN` entries in HOSTS.TXT.

# 2026-11-04
## [Add support for CHAOS addresses in SYSTEM:HOSTS.TXT](2728f1a)

Allow "`CHAOS` *nnnn*" in HOST entries in HOSTS.TXT (just like the HOSTS3 file on ITS). This lets you avoid the complications of relying on DNS for parsing Chaosnet hosts. Also, this might make it easier for "home Chaosnets" like the PiDP-10 (which normally use non-routed Chaosnet addresses, which are typically not in DNS).

This is done by using the "bit is not used for now" in the HOSTN table, which is now a flag that this entry is for an UNternet (non-Internet) address. (The HSTUNT bit is defined in ANAUNV.MAC.)

In `MNETDV.MAC`, 
when a line in HOSTS.TXT is parsed, any CHAOS addresses (which are 16 bits) are saved as UNternet addresses, with the `NE%UNT` flag (1B3) and on network 7.0.0.0 (so CHAOS 3424 becomes UN 7.0.7.20, or 40700,,3424 octal). In a post-processing step, if the host had both IP and Chaos addresses, all HOSTN entries for the host are copied, now with HSTUNT set, and pointing to the HOSTNN entry for the (primary/first) Chaosnet address. Also a new HOSTPN entry is made, pointing to the primary-name HOSTN entry. (If the host had only CHAOS addresses, nothing extra is needed.)

When looking up a host name in HSTLUK, be aware if looking for a Chaos or Internet host, and only check HOSTN entries with matching HSTUNT flag. The awareness comes from getting a "class" flag in the call from routines calling HSTLUK, which is set up by the various `GTHST%` functions which translate from name to address. This is set up by the user by setting `GH%QCL` in AC1, and the class in AC3 (if the flag is set). A Chaosnet address is returned as a 16-bit number, and the UNternet format is not visible to the user.

When translating from address to name (e.g. the `.GTHNS` function of `GTHST%`), the `GH%QCL` flag is also used, and a 16-bit Chaosnet address is supplied by the user.

Also, now that `GTHST%` can handle Chaosnet hosts/addresses, make [`CHANM%`](CHANM.md) first try `GTHST%` and then `GTDOM%` (rather than only the latter).

The UNternet format is used in ITS, and was (at MIT) also used in TOPS-20, where it also supported other non-Internet addresses. See `SYSHST;HOSTS3 >` (e.g. [here](https://github.com/PDP-10/its/blob/f2d00b83d7405c647547eb82e284aa66f3e3da69/src/syshst/hosts3.337#L268) and [here](https://github.com/PDP-10/its/blob/f2d00b83d7405c647547eb82e284aa66f3e3da69/src/syshst/hosts3.337#L373)).

# 2026-10-11
## [Fixes for Telnet server](916d8b6)
- Implement the LOGOUT option (RFC 727).
- Handle client WILL TRMTYP.
- Fix numerous errors for handling option negotiation, where the wrong fields were read/written.
- Do not allow NAWS or TRMTYP until after the terminal has been set up with defaults.

The LOGOUT option does not use subnegotiation, but the implementation uses the mechanisms developed for handling those. This is because the basic option handling is done in scheduler context, where `LGOUT%` can not be called (it causes a BUGHLT). Instead the `LGOUT%` is done in the subnegotiation handler fork.

There were a lot of errors in option negotiation code, where the wrong fields were read/written. Sorry about that, but nwo it is fixed.

If a client sent subnegotiations for window size (NAWS) or terminal type (TRMTYP), the settings were handled, but were overwritten by the terminal initialization code (ASNTVT in TVTSRV, ASNCVT in TTCHDV). This is fixed by introducing a new flag in the terminal state block, which is set when the terminal has been setup (after SYSINP in MEXEC). Until hat flag is set, the NAWS and TRMTYP options are refused, but after it has been set, the options are explicitly asked for (see TVTRDY in TVTSRV).

## [Add missing TDCALL entries for Chaosnet NVTs](0c64276)
Some generic terminal functions failed to call the appropriate routines for Chaosnet NVTs (in TTYSRV.MAC).



## [Add an alias for CHAOSNET-ADDRESS](de1f713)
When parsing SYSTEM:CHAOSNET.ADDRESS, allow the alias ADDRESS for the more verbose CHAOSNET-ADDRESS keyword.

(Note: the obvious other aliases, ADDR-DOMAIN for CHAOS-ADDR-DOMAIN, and IP-GATEWAY for CHAOS-IP-GATEWAY, were not added, but should at some point be.)

## [Avoid changing window size by accident](29ede69)
The MTOPR function codes for reading terminal width, and for setting the Chaosnet window size, coincided. This had the effect that when FINGER was run by the Chaosnet NAME server (SYSTEM:CHAOS.NAME), and it wanted to check the terminal width, it instead tried to set the Chaosnet window size of the connection to 0.

Fixes (two):
- Change the .MOSWS function code to avoid the coincidence - **note** that this means any program using .MOSWS need to be recompiled, such as `<CHAOS.SYSTEM>FILE.MID`.
- Change FINGER to check that .PRIOU is actually a terminal before trying to read its width.

# 2026-08-14
## [Add support for sending window size, ttytype, and location in TELNET](5604297)

When TELNET is used (for making outgoing connections), it attempts to send the options to the server end.

The hairy part was getting the location setting from GETLOC without any hostname or protocol prefix. This required adding some PSECTs for compatibility with GETLOC.

## [Improve telnet subnegotiation support](cbfcacd)

This includes supporting the SEND-LOCATION option (RFC779), updating the TTYLOC database compatibly with FINGER/TTYLOC.

Subnegotiation is done in a separate monitor fork, since the IAC SE
is detected in code at TTCH7 scheduler context, and can't even do simple things
like GTJFN - plus it's bad to do too much at scheduler level.
So when the IAC SE (subnegotiation end) sequence is detected, an entry on a circular list is enqueued, which are handled separately by the new monitor fork.

The SEND-LOCATION option was implemented by updating the `FINGER:TTYLOC.BIN` file in a way compatible with `TTYLOC` and `FINGER`. The file is opened, mapped in, updated, unmapped and closed. **Note** that some definitions from FNGDEF are copied to TVTDEF and must match.

## [Improve format of TTYLOC database](8b6a475)
Previously, record headers consisted of job# and user#, but this is insufficient if the same user happens to get the same job# on a later login. (They would then inherit the location from the previous session, which may be incorrect.)

Instead, use job# and (the low 27 bits of) job start time (GETJI .JISTM). This ensures (quite well) that TTYLOC records are not reused, but are tied to a specific login session.

Note that FINGER and TTYLOC need to be recompiled and installed, using the updated FNGDEF and GETLOC libraries.

(Later realization: One issue remains: if you set the location when connecting with Telnet, and instead of logging in (which uses the same job number and start time), you attach to an old job, the job number and start time changes, and the initial location setting is invalidated. Workaround: use TTYLOC or have your Telnet client set the location again.)

# 2026-06-14
## [Implement Telnet TTYTYPE negotiations](3f5a20c)
ANSI, DEC-VT100, VT100, XTERM, XTERM-256COLOR are recognized and all map to the VT100 terminal type.

Unfortunately there is no central table of terminal-name-to-terminal-typecode translations, so this introduces yet another.

**Note** that this required changes to TVTLEN/CVTLEN, which are defined in TVTSRV but used in TTYDEF and TTYSRV, which thus need recompiling.
