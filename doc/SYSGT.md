# Supplemental documentation for SYSGT% (JSYS 16) and GETAB% (JSYS 10)

The following tables can be accessed to find Chaosnet information:

  - `CHSTAT` (or `.CHSTA` for `GETAB%`) for the Chaosnet status block
  - `CHPMXT` (or `.CHPMX` for `GETAB%`) for the max number of data bytes in a Chaosnet packet
  - `MYCHAD` (or `.MYCHA` for `GETAB%`) for my Chaosnet address

Note that `CHPMXT` is typically 488 (decimal), and that `MYCHAD` can also be read using [CHANM%](CHANM.md) (function code `.CHNPH`).

The `CHSTAT` table currently contains the following:

| Index | Description |
| --- | --- |
| 0 | `CHAON` - non-zero if Chaosnet is enabled |
| 1 | Device status |
| 2 | `MYCHAD` - my Chaosnet address |
| 3 | Number of packets in from interface |
| 4 | Number of packets output to interface |
| 5 | Number of transmissions aborted |
| 6 | Number lost to busy interface |
| 7 | Number of packets with CRC errors before read in |
| 10 | Number read out as garbage |
| 11 | Number with bad bit count |
| 12 | Number of packets ignored for other reasons |

Note that for the current implementation using Chaos-over-IP, the only indices which are/can be non-zero are 0 and 2. The other counters (index 3-12) refer to packets in/out/etc of the DTE or Unibus interface, which is not currently used.

The most useful index is thus 0, which you get in AC1 by using `SYSGT%` with sixbit `CHSTAT` in AC1, or using `GETAB%` with `.CHSTA` (65) in AC1. 
