# Chaosnet support for TOPS-20

Based on [old code](https://github.com/PDP-10/sri-nic/tree/master/files/src/mit/monitor) for TOPS-20 version 5 from MIT and SRI, ported into the [PANDA TOPS-20 version 7](https://github.com/PDP-10/panda), but in a separate tree to perhaps make it easier to port to other TOPS-20 distros/versions.

See [the Chaosnet report](https://chaosnet.net/amber.html#The-TOPS_002d20_002fTENEX-Implementation) for documentation.

For transmitting and receiving Chaosnet packets, the standard Chaos-over-IP encapsulation is used ([see description](https://github.com/bictorv/chaosnet-bridge/blob/master/README.md#chaos-over-ip)), so you need to have TCP/IP configured and working.

See [Chaosnet.net](https://chaosnet.net) for more info about Chaosnet.

## Installation
Begin by installing a Panda system and get Internet working on it.

To generate the monitor, submit `<CHAOS.MONITOR-SOURCES>MONGEN.CTL`.

To generate the exec, submit `<CHAOS.EXEC-SOURCES>EXCGEN.CTL`.

You can compile the various programs in `<CHAOS.SYSTEM>` and install them as indicated in the [`<CHAOS.SYSTEM>-READ-THIS-.TXT`](blob/master/chaos/system/-read-this-.txt) file (see [below](#server-programs)).

## Configuration

In `SYSTEM:INTERNET.ADDRESS`, add the following parameters for your IPNI#0
- `CHAOS-ADDRESS:`*nnnn* where *nnnn* is your octal Chaosnet  address
- `CHAOS-IP-GATEWAY:`*a.b.c.d* where *a.b.c.d* is the IP address of a [Chaosnet bridge program](https://github.com/bictorv/chaosnet-bridge) which is configured to accept Chaos-over-IP from the IP of your TOPS-20 system (see [below](#chaosnet-bridge)).
- `CHAOS-ADDR-DOMAIN:`*dname* to set the address DNS domain to *dname*, default `CH-ADDR.NET`.

(Note that you may want to use short-but-nonambiguous keywords, since the default buffer for parsing `INTERNET.ADDRESS` is quite short in a standard monitor (134 chars), which you may occasionally want to use.)

The Chaosnet host name is initialized from the IP host name, using `GTHST%`, which should match, of course. 

### DNS resolver

To make parsing of Chaosnet host names work, you need to edit `DOMAIN:RESOLV.CONFIG` to use a DNS server which has CHaosnet class data, such as the `DNS.Chaosnet.NET` host (look up its IPv4 address). Use the `DSERVE` directive in the config.

You may also want to include the domain `Chaosnet.NET.` in your `RSEARCH` directives, to get shorthand addresses to all ITS hosts on Chaosnet.

(Note that HOSTS.TXT is not used for Chaosnet host names, except for initializing the local host name using `GTHST%`, see above.)

### Chaosnet bridge
You need to configure your [Chaosnet bridge](https://github.com/bictorv/chaosnet-bridge/blob/master/CONFIGURATION.md) to accept Chaos-over-IP from your TOPS-20 system, e.g. using

`link chip` *x.y.z.w* `host` *nnnn* `myaddr` *mmmm*

where *x.y.z.w* is the IP of your TOPS-20 system, *nnnn* is its Chaosnet address, and *mmmm* is the Chaosnet address of your cbridge on that subnet (in case it is on more than one).

## What works

Out-of-the-box, the system responds on `STATUS` packets, e.g. sent by HOSTAT or CHATST programs (see [here](https://chaosnet.net/amber.html#Status-1)). It only sends two meters: the number of input and output packets.

Both simple RFC-ANS protocols and stream protocols seem to work.

`GTDOM%` handles the CHaosnet class (3). (There are not yet MACRO symbols for the classes.)

`CHANM%` uses `GTDOM%`, so works. See [documentation](CHANM.md).

### Server programs

If you install `CHARFC.EXE` in `SYSTEM:`, and start it in a SYSJOB, it will get all unclaimed RFC packets, and search for server programs `SYSTEM:CHAOS`.*contact* and start them.  See [the Chaosnet report](https://chaosnet.net/amber.html#Server-Programs-1) for documentation. 

There are simple server programs for the `TIME`, `UPTIME`, `NAME`, `LIMERICK`, and `FILE` contacts, see [`<CHAOS.SYSTEM>-READ-THIS-.TXT`](blob/master/chaos/system/-read-this-.txt).

The `FINGER` program has been fixed to finger Chaosnet hosts. You will need to recompile it (in `<CHAOS.FINGER>`) and install it (in `<SUBSYS>`).

## Notes on programming
Some notes in addition to  [the Chaosnet report](https://chaosnet.net/amber.html#The-TOPS_002d20_002fTENEX-Implementation) documentation.

- To open a connection to a host, open `CHA:`*host*`.`*contact* as the documentation says. Here *host* can be an octal Chaosnet address or a host name whose address can be found in DNS (using the `GTDOM%` system call). If the name contains dots (.), make sure to quote them with `^V` since the file name parsing will otherwise complain.
- If the *contact* contains arguments, similarly quote special characters with `^V`. You can/may/should use underscore (`_`) for space (they will become spaces again on the net).
- Before closing the connection with `CLOSF%`, you may want to make sure your output has reached the other end. This can be done using `SOUTR` or the `.MOSND` operation for `MTOPR`, possibly followed by `.MOEOF` (to send an EOF) and `.MONOP` (to wait for it to get acked). This is silly, but as it is, needed/useful. See e.g. `<CHAOS.SYSTEM>CHAFIN.MAC`.

## What does not work yet

- NVTs (Network Virtual Terminals) don't work, so no Supdup yet. I'm working on it!
- DECnet is disabled for now, so that doesn't work.
- SDDT isn't updated with new symbols.

## What should be done later

- RESOLV should (be able to) use separate DNS servers for IN and CH classes, since CH can often be served by DNS servers which don't provide IN to just anyone, and IN servers in general have no clue about CH.
- SYSDPY should do things (show conns, windows, whatnot - like PEEK in ITS.)
- MMAILR support would be nice!

## Bugs

Of course! Please report them to me.

Known things:
- `BUGINF FLKINT` when creating outgoing connections.
- `BUGCHK IPIBLP` when lots of input coming in a connection.