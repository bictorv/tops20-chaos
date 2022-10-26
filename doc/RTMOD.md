# Documentation for RTMOD% (JSYS 636)

## Function
Read terminal modes.

## Calling sequence
- AC1: Terminal designator

## Returns
+1: Always, with terminal modes in AC2.

## Terminal modes

| Bit | Description |
| --- | --- |
| 1B0 (`TM%DPY`) | Process `^P` codes |
| 1B1 (`TM%SCR`) | Scroll mode / Wrap mode |
| 1B2 (`TM%MOR`) | More processing enabled |
| 1B3 (`TM%MVR`) | Verbose sort of more |
| 1B4 (`TM%MSM`) | Smart about more |
| 1B5 (`TM%VBL`) | Use visible bell for `^G` |
| 1B6 (`TM%GRF`) | Perform Graphics Functions |
| 1B7 (`TM%RSU`) | ? |
| 1B17 (`TM%ITP`) | Intelligent terminal protocol in use |

## RTMOD% error mnemonics:

<dl>
<dt>TTYX01</dt>
<dd>Line is not active</dd>
</dl>
