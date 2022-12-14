# Chaosnet support for TOPS-20

Based on [old code](https://github.com/PDP-10/sri-nic/tree/master/files/src/mit/monitor) for TOPS-20 version 5 from MIT and SRI, ported into the [PANDA TOPS-20 version 7](https://github.com/PDP-10/panda), but in a separate tree to perhaps make it easier to port to other TOPS-20 distros/versions.

See [the Chaosnet report](https://chaosnet.net/amber.html#The-TOPS_002d20_002fTENEX-Implementation) for documentation.

For transmitting and receiving Chaosnet packets, the standard Chaos-over-IP encapsulation is used ([see description](https://github.com/bictorv/chaosnet-bridge/blob/master/README.md#chaos-over-ip)), so you need to have TCP/IP configured and working. (It pays off to specify the FQDN of your system in `HOSTS.TXT`.)

See [Chaosnet.net](https://chaosnet.net) for more info about Chaosnet.

## Installation

Begin by installing a Panda system and get Internet working on it. For this, you probably need to be running on a KL (emulator). The Chaosnet code has only been tried on a KL.

Then restore the tape file `chaos.tpr` using `DUMPER`.

To generate the monitor, connect to `<CHAOS.MONITOR-SOURCES>` and submit `MONGEN.CTL`. Install `MONITR.EXE` in `SYSTEM:`, and `CHAFDS.UNV` and `MONSYM.UNV`in `SYS:` (e.g. `<CHAOS.SUBSYS>`, see [below](#client-programs)).

To generate the exec, connect to `<CHAOS.EXEC-SOURCES>` and submit `EXCGEN.CTL`. Install `EXEC.EXE` in `SYSTEM:`.

Then compile a new MIDAS with Chaosnet definitions, see `<CHAOS.MIDAS>-READ-ME-.TXT`.

You can compile the various programs in `<CHAOS.SYSTEM>` and install them as indicated in the [`<CHAOS.SYSTEM>-READ-THIS-.TXT`](chaos/system/-read-this-.txt) file (see [below](#server-programs)).

You may then want to compile and install `TELNET`, `FINGER` and the MM mailsystem, see [below](#client-programs).

## Configuration

In `SYSTEM:INTERNET.ADDRESS`, add the following parameters for your IPNI#0
- `CHAOS-ADDRESS:`*nnnn* where *nnnn* is your octal Chaosnet  address
- `CHAOS-IP-GATEWAY:`*a.b.c.d* where *a.b.c.d* is the IP address of a [Chaosnet bridge program](https://github.com/bictorv/chaosnet-bridge) which is configured to accept Chaos-over-IP from the IP of your TOPS-20 system (see [below](#chaosnet-bridge)).
- `CHAOS-ADDR-DOMAIN:`*dname* to set the address DNS domain to *dname*, default `CH-ADDR.NET`, max len 50. (The default *dname* is coded in `STG.MAC`, at `CHADDN`.)

**Example:** the IP address of the TOPS-20 system is 10.0.1.11/24, the Chaosnet bridge has IP 10.0.1.1, and the TOPS-20 Chaosnet address is 3412 (octal).
```
IPNI#0,10.0.1.11,PACKET-SIZE:1500,LOGICAL-HOST-MASK:255.255.255.0,CHAOS-ADDRESS:3412,CHAOS-IP-GATEWAY:10.0.1.1
```

Note that since the default buffer for parsing `INTERNET.ADDRESS` is quite short in a standard monitor (134 chars), you might want to keep the contents short, which you can do in two ways:
  - If you only define one network, it is taken as default, so you can skip the `DEFAULT` keyword.
  - If you have a default network, it is also (by default) the `PREFERRED` one, so you can skip that keyword too.
  - Since the file is parsed with `TBLUK%`, you can used short-but-nonambiguous keywords (e.g. `LOG` would be sufficient for the mask).

The Chaosnet host name is initialized from the IP host name, using `GTHST%`, so they need to match, of course. 

### DNS resolver

To make parsing of Chaosnet host names work, you need to edit `DOMAIN:RESOLV.CONFIG` to use a DNS server which has CHaosnet class data, such as the `DNS.Chaosnet.NET` host (look up its IPv4 address and use it, but *note that it does not handle the INternet class* - **see [below](#resolv)**). Use the `DSERVE` directive in the config. 

You may also want to include the domain `Chaosnet.NET.` in your `RSEARCH` directives, to get shorthand addresses to all ITS hosts on Chaosnet.

**Example:**
```
DSERVE 158.174.114.186    ;This is the current address of DNS.Chaosnet.NET
RSEARCH .                 ;Try fully qualified first
RSEARCH my.local.dom.ain. ; then my local domain
RSEARCH Chaosnet.NET.     ; then Chaosnet.NET
```

(Note that HOSTS.TXT is not used for Chaosnet host names, except for initializing the local host name using `GTHST%`, see above.)

### Chaosnet bridge

You need to configure your [Chaosnet bridge](https://github.com/bictorv/chaosnet-bridge/blob/master/CONFIGURATION.md) to accept Chaos-over-IP from your TOPS-20 system, e.g. using

`link chip` *x.y.z.w* `host` *nnnn* `myaddr` *mmmm*

where *x.y.z.w* is the IP of your TOPS-20 system, *nnnn* is its Chaosnet address, and *mmmm* is the Chaosnet address of your cbridge on that subnet (in case it is on more than one).

### Greetings (optional)

The contents of `SYSTEM:CHAOSNET-LOGIN-MESSAGE.TXT`, if it exists, is printed on new Chaosnet TELNET connections, just like `SYSTEM:INTERNET-LOGIN-MESSAGE.TXT` is printed on new TCP TELNET connections.

## What works

Out-of-the-box, the system responds on `STATUS` packets, e.g. sent by HOSTAT or CHATST programs (see [here](https://chaosnet.net/amber.html#Status-1)). It only sends two meters: the number of input and output packets.

Both simple RFC-ANS protocols and stream protocols seem to work.

`GTDOM%` handles the CHaosnet class (3). (There are not yet MACRO symbols for the classes.)

`CHANM%` uses `GTDOM%`, so works. See [documentation](doc/CHANM.md).

Surprisingly, the `TELNET` and `MMAILR` programs of the Panda distribution already handled Chaosnet! Both have been fixed to change the priority order between TCP/Internet and Chaosnet, to prefer Chaosnet. A new `SMTCHA` program which implements an SMTP server for Chaosnet has been added (see below).

Sending and receiving "SEND" messages and mail works, if you install the modified MM mailsystem (see below) and the server for the `SEND` contact (see below). 

### Server programs

If you install `CHARFC.EXE` in `SYSTEM:`, and start it in a SYSJOB, it will get all unclaimed RFC packets, and search for server programs `SYSTEM:CHAOS`.*contact* and start them.  See [the Chaosnet report](https://chaosnet.net/amber.html#Server-Programs-1) for documentation of `CHARFC`. 

There are simple server programs for the `TIME`, `UPTIME`, `NAME`, `LIMERICK`, `FILE`, `LOAD`, `TELNET`, and `SEND` contacts, see [`<CHAOS.SYSTEM>-READ-THIS-.TXT`](chaos/system/-read-this-.txt).

### Client programs

I suggest installing client programs in `PS:<CHAOS.SUBSYS>` and put that on the system-wide definition of `SYS:` (by editing `SYSTEM:7-1-CONFIG.CMD`, and putting it before `PS:<SUBSYS>`).

The `FINGER` program has been fixed to finger Chaosnet hosts and accept a `/CHAOSNET` switch (to show only Chaosnet connections). You will need to compile it (see `<CHAOS.FINGER>-READ-THIS-.TXT`) and install it (in `<CHAOS.SUBSYS>`).

Although `TELNET` already could make Chaosnet connections, I have changed the priority order between TCP and Chaos to prefer Chaos. Connect to `<CHAOS.TELNET>`, submit `TELNET.CTL`, and install `TELNET.EXE` in `<CHAOS.SUBSYS>`.

The MM mailsystem has modifications (in `<CHAOS.MM>`) to prefer Chaos over Internet/TCP connections. Connect to `<CHAOS.MM>` and submit `BUILD-MM.CTL`, and read `<CHAOS.MM>-READ-ME-.TXT`.
A `<CHAOS.SUBSYS>` directory with pre-compiled binaries is provided for your convenience, but the binaries for `MAISER` and `MAPSER` live in `SYSTEM:` and are not included.
The `SMTCHA` program should be started in SYSJOB/SYSJB1 (similarly to `SMTJFN`), not as `SYSTEM:CHAOS.SMTP`.

### EXEC modifications

Support for the following has been added:
  - The Chaosnet-access privilege can be given and checked (`BUILD` and `INFORMATION (ABOUT) DIRECTORY` commands) (see [RPCAP%/EPCAP%](doc/EPCAP.md)).
  - `INFORMATION (ABOUT) SYSTEM-STATUS` shows whether Chaosnet access control is enabled (see [SMON%/TMON%](doc/SMON.md)).
  - `^ESET `[no] `CHAOSNET-ACCESS-CONTROL` to enable/disable that.
  - `INFORMATION (ABOUT) CHAOSNET` shows some info about the Chaosnet configuration (whether it's enabled, whether access control is enabled, what host address and name you have)
  - `SYSTAT`, `LOGIN`, and `INFORMATION (ABOUT) JOB-STATUS` commands show the remote Chaosnet host suffixed with "(Chaos)".

Also, the `FINGER` command is allowed when not-logged-in, and takes a `/CHAOSNET` switch (to show only Chaosnet connections).

## Notes on programming

Some notes in addition to  [the Chaosnet report](https://chaosnet.net/amber.html#The-TOPS_002d20_002fTENEX-Implementation) documentation.

- To open a connection to a host, open `CHA:`*host*`.`*contact* as the documentation says. Here *host* can be an octal Chaosnet address or a host name whose address can be found in DNS (using the `GTDOM%` system call). If the name contains dots (.), make sure to quote them with `^V` since the file name parsing will otherwise complain.
- If the *contact* contains arguments, similarly quote special characters with `^V`. You can/may/should use underscore (`_`) for space (they will become spaces again on the net).
- Before closing the connection with `CLOSF%`, you may want to make sure your output has reached the other end. This can be done using `SOUTR` or the `.MOSND` operation for `MTOPR`, possibly followed by `.MOEOF` (to send an EOF) and `.MONOP` (to wait for it to get acked). This should arguably be default behaviour of a normal `CLOSF%` without `CZ%ABT` (or with `CO%WCL`?), but as it is, it is needed/useful. See e.g. `<CHAOS.SYSTEM>CHAFIN.MAC`.

### New JSYSes

- [CHANM%](doc/CHANM.md) (JSYS 460), to obtain information about Chaosnet hosts. (You can also use `GTDOM%`.)
- [VTSOP%](doc/VTSOP.md) (JSYS 635), to do display dependent operations (**NYI**)
- [RTMOD%](doc/RTMOD.md) (JSYS 636), to read terminal modes.
- [STMOD%](doc/STMOD.md) (JSYS 637), to set terminal modes.
- [RTCHR%](doc/RTCHR.md) (JSYS 640), to read terminal characteristics.
- [STCHR%](doc/STCHR.md) (JSYS 641), to set terminal characteristics.

Some supplemental documentation for JSYSes with extended functionality: 

  - [RPCAP%/EPCAP%](doc/EPCAP.md),
  - [SMON%/TMON%](doc/SMON.md), 
  - [SYSGT%/GETAB%](doc/SYSGT.md),
  - [NTINF%](doc/NTINF.md),
  - [OPENF%](doc/OPENF.md),
  - [MTOPR%](doc/MTOPR.md)


## What does not work yet

- Supdup NVTs (Network Virtual Terminals) don't work (but regular TELNET NVTs do work)
- DECnet is disabled for now, so that doesn't work.
- SDDT isn't updated with new symbols.

## What should be done later

- SYSDPY should do things (show conns, windows, whatnot - like PEEK in ITS.)

### RESOLV

RESOLV should (be able to) use separate DNS servers for IN and CH classes, since CH can often be served by DNS servers which don't provide IN to just anyone  (e.g. `DNS.Chaosnet.NET`), and IN servers in general have no clue about CH.

The **workaround** is to set up your own caching server to handle both IN and CH ([see here](https://chaosnet.net/chaos-dns)).

## Limitations

A number of them.

### LITES

The code in `KLHSRV.MAC` (to support `LITES%` in KLH10 when it is compiled with `KLH10_DEV_LITES=1`) is disabled. The LITES hack requires one of the rare [Panda](https://github.com/DavidGriffith/panda-display) [displays](http://www.sparetimegizmos.com/Hardware/Panda.htm), but if you have one of those displays you need to enable the `KLHSRV.MAC` code again.

## Bugs

Of course! Please report them to me.

Known things:
- `BUGINF FLKINT` when creating outgoing connections.
	- This seems not to cause problems, but indicates some bug of course.
- `BUGCHK IPIBLP` when lots of input coming in a connection.
	- This was related to a Chaosnet window handling bug in the [Chaosnet bridge program](https://github.com/bictorv/chaosnet-bridge) but could still appear as the result of a DoS attack.
- Filename parsing for `CHA:` only checks if the name *begins* with a digit and then uses that as address, so parsing "3com" will just return 3. (See `HSTN$1` in `CHAOS.MAC`).
- Here and there, 50 (decimal) is used as max host/domain name length.
