# Some tips about running TOPS-20

## Enable capabilities

Make `<OPERATOR>COMAND.CMD` enable capabilities. OPERATOR always needs them.

## Avoid filling SPOOL:
In `7-1-SYSJOB.RUN`, for subjob 0, after doing `TAKE SYSTEM:SYSTEM.CMD`, it could be a good idea to do `push`, then `rename spool:operator-system-log.* (to) spool:operator-system.old.-1`, and `pop`.  That way, you avoid filling `SPOOL:` with a lot of old log files which you would need to manually delete. Now, you can use generation retention to keep a nice number, and/or use `PURGE`.

## Maximize PID quota
In `SYSJB1.RUN` it is a good idea to first run a little program which sets maximal pid quota for this job. This avoids the problems with other programs crashing with "PID quota exceeded" errors.  Such a little program can be foundon BV20:<BV>PIDMAX.MAC - it uses the .MUSPQ function code for MUTIL% to set a huge pid quota. Compile it, install it in `SYSTEM:`, and add (as a **first** line of `SYSJB1.RUN`)

	ERUN SYSTEM:PIDMAX

## If your monitor build hangs

Sometimes linking the monitor seems to hang after a LNKRLC message (showing the PSECT starts, values, and limits), typically after complaing about PSECT overlaps before.

If you abort and restart the linking, the same thing will happen again. The way out is to edit LNKNEW.CCL to manually adjust PSEC starts to avoid the overlaps, before trying again. This is normally done by the monitor linking, but sometimes fails.
