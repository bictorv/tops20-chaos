# Monitor source edits (summary)

Summary of monitor edits for Chaosnet. Might not always be up-to-date or complete.

A recent fix was to introduce VTSSW (set in SITE.MAC), default 0, to disable all code related to the Virtual Terminal Support. This code should be moved to the VTS subdirectory, be enabled there, and worked on to make it actually work properly.

## New modules:
- CHSDFS (definitions for Chaosnet packets, MTOPR codes, etc)
- CHAOS.MAC (the actual implementation)
- TTCHDV (Chaosnet NVT code)

TVTDEF.MAC contains definitions for NVT code, separated from TVTSRV so TTCHDV can share it. 

## COMND.MAC
Make RDCBP global, for use in CHAOS.MAC.

## FREE.MAC

Add routine to free STKCD5 resources (cf PROLOG.MAC)

## GLOBS.MAC

Add Chaosnet globals. :warning: Also RTMOD/STMOD, RTCHR/STCHR globals.

## GTDOM.MAC

Enable support for Chaosnet class data (CH). Uses the Chaosnet address domain at CHADDN (cf. STG.MAC).

Tentative code to test "goodness" value of a Chaosnet host address (not enabled).

## JSYSA.MAC

SMON/TMON support for Chaosnet protection (.SFCHA)

**General bug fix:** at GTDSTF, call DSTCHK in the correct section (to check if DST method type is valid), for TMON.

## JSYSM.MAC

Add some Chaosnet entries for (SYSGT/GETAB)[SYSGT.md].

## KLHSRV.MAC

Disable support for LITES% (which requires a Panda Display, cf (note here)[../README.md]).

## MEXEC.MAC

Add support for Chaosnet NVTs, and call CHAINI (cf CHAOS.MAC) to initialize Chaosnet in system initialization.

## MNETDV.MAC

Read SYSTEM:CHAOSNET.ADDRESS to initialize my address, the Chaos-to-IP gateway, and the Chaosnet address domain name (default CH-ADDR.NET, cf STG.MAC).

Handle Chaosnet NVTs in ATNVT%.

## MONSYM.MAC

New JSYS (CHANM)[CHANM.md] and its function codes.

New function codes, bit definitions, and error codes for various Chaosnet(-extended) JSYSes.

## NAMMON.MAC

Add "Chaotic" to default monitor name.
Change VWHO (who edited the monitor last) from 4 (MRC) to 6 (BV).

## PARMON.MAC

Swap the order of blocks for system configuration and parameters for storage configuration, to be able to disable DECnet (using `DCN==:0`) and lower the storage. (DECnet was disabled during the port, to keep things simpler, but is now enabled by default again.)

## PROLOG.MAC

New JSB space entry type STKCD5 for Chaosnet conns.

New TTY line type for Chaos NVTs.

## SITE.MAC

New parameters:
- `CHAOS` (to enable Chaosnet code), 
- `CHINET` (to use Chaos-over-IP in CHAOS.MAC),
- `VTSSW` (to enable, default disable, the VTS support), and
- `NTTCVT` (number of Chaosnet NVTs).

## STG.MAC

Default CHAOS enabled, NETDTE disabled (use IP instead), CHA: device, storage for Chaosnet, default Chaosnet address domain CH-ADDR.NET, add Chaosnet NVT handling to scheduler device-dependent code (LV8CHK).

## TTYDEF.MAC

Length of Chaos NVT block (CVTLEN).

## TTYSRV.MAC

Chaosnet NVT support. Extend TDCALL macro with CN (Chaosnet) case. Chaos NVT initialization.

## TVTSRV.MAC

Print SYSTEM:CHAOSNET-LOGIN-MESSAGE.TXT on Chaosnet NVTs (like SYSTEM:INTERNET-LOGIN-MESSAGE.TXT is printed on TCP NVTs).
