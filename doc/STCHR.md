# Documentation for STCHR% (JSYS 641)

## Function
Set terminal characteristics.

## Calling sequence
- AC1: Terminal designator
- AC2: Terminal characteristics

## Returns
+1: Always.

## Terminal characteristics

| Bit | Description |
| --- | --- |
| 1B0 (`TC%MOV`) | Absolute or relative cursor motion |
| 1B1 (`TC%BS`) | Cursor back at least (backspace) |
| 1B2 (`TC%HOM`) | Home to top left hand corner |
| 1B3 (`TC%CLR`) | Clear entire screen at least |
| 1B4 (`TC%SCL`) | Clear selective portions of screen |
| 1B5 (`TC%LID`) | Line insert/delete |
| 1B6 (`TC%CID`) | Character insert/delete |
| 1B7 (`TC%VBL`) | Visible bell |
| 1B8 (`TC%MET`) | Has META (8-bit) key |
| 1B9 (`TC%SCR`) | Scrolls on down from bottom line |
| 1B10 (`TC%RSC`) | Reverse-scrolls on up from top-line |
| 1B11 (`TC%OVR`) | Overwrites |
| 1B12 (`TC%FCI`) | Has full 12-bit input capability |
| 1B17 (`TC%PRT`) | Printing terminal |
| 1B18 (`TC%WRP`) | Outputting in last line pos will CRLF |

## STCHR% error mnemonics:

<dl>
<dt>TTYX01</dt>
<dd>Line is not active</dd>
</dl>
