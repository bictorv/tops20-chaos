# Documentation for VTSOP% (JSYS 642)

**NOTE: new JSYS number - used to be 635, but that is the new `DOB%` JSYS in TOPS-20 v7**

## Function
Do display dependent operations.

## Calling sequence
- AC1: Terminal designator
- AC2: Flags ,, function code
- AC3: Optional argument (function dependent)
- AC4: Optional argument (function dependent)

## Returns
+1: Always.

## Flags
| Code | Description |
| --- | --- |
| 1B1 (`DP%AG1`) | First argument (in AC3) exists |
| 1B2 (`DP%AG2`) | Second argument (in AC4) exists |

## Function codes

| Code | Description | Argument(s) |
| --- | --- | --- |
| 0 (`.VTNOP`) | NOP (force update) |
| 1 (`.VTFWD`) | Cursor forward | AC3: count |
| 2 (`.VTBCK`) | Cursor back | AC3: count |
| 3 (`.VTUP`) | Cursor up |  AC3: count |
| 4 (`.VTDWN`) | Cursor down |  AC3: count |
| 5 (`.VTHRZ`) | Set horizontal pos | AC3: Position |
| 6 (`.VTVRT`) | Set vertical pos | AC3: Position |
| 7 (`.VTMOV`) | Move cursor (x and y) | AC3: Y coord ,, X coord |
| 10 (`.VTHOM`) | Home up | None |
| 11 (`.VTHMD`) | Home down | None |
| 12 (`.VTADV`) | Advance to next line | AC3: count |
| 13 (`.VTSAV`) | Save pos | None |
| 14 (`.VTRES`) | Restore pos | None |
| 15 (`.VTCLR`) | Clear window (screen) | None |
| 16 (`.VTCEW`) | Clear to end-of-window |  None |
| 17 (`.VTCEL`) | Clear to end-of-line | None |
| 20 (`.VTERA`) | Erase character ??? | None |
| 21 (`.VTBEC`) | Backspace and erase | None |
| 22 (`.VTLID`) | Line insert/delete | AC3: Repeat count;  AC4: First line,,last line |
| 23 (`.VTCID`) | Character insert/delete | AC3: Repeat count;  AC4: First line,,last line |
| 24 (`.VTESC`) | Output VTS escape | AC3: count |
| 25 (`.VTVBL`) | Visible bell | None |

## VTSOP% error mnemonics:

<dl>
<dt>VTSX01</dt><dd>Invalid function code</dd>
<dt>VTSX02</dt><dd>Terminal cannot perform function</dd>
<dt>VTSX03</dt><dd>Required argument not supplied</dd>
<dt>TTYX01</dt><dd>Line is not active</dd>
</dl>
