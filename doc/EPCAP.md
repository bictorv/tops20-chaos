# Supplemental documentation for RPCAP%/EPCAP% (JSYS 150/151)

A new capability: Chaosnet access, `SC%CHA` (1B34) is defined. 

If Chaosnet access control is enabled using the `.SFCHA` function code (110) of [SMON%](SMON.md), the Chaosnet access capability is required to allow opening the `CHA:` device. If access is denied, `OPENF%` will return `CHAOX5` (Not allowed to use Chaosnet).

If Chaosnet access control is not enabled, the capability is not needed for `CHA:` access.
