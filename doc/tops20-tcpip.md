# Getting TCP/IP working on a Panda TOPS-20 system

This is necessary for Chaosnet to work, since it sends Chaosnet packets in IP packets.

See also [klh10/doc/klt20.txt](https://github.com/PDP-10/klh10/blob/6d733f2a47644964492fd864454cbe1331655e53/doc/klt20.txt#L536), or the official documentation in Appendix C (start at C.4) of `<DOCUMENTATION>INSTALL.MEM` on your Panda system (or at [Bitsavers](https://bitsavers.trailing-edge.com/pdf/dec/pdp10/TOPS20/V7/INSTALL.MEM.txt)).

If the instructions below are incomplete, **let me know** so I can update them! And look for the DEC documentation.

## Edit SYSTEM:INTERNET.ADDRESS

This file is read at system startup. The important thing to edit is your IP address. Also the network mask and packet-size might be useful to edit.

- The first parameter is the network interface, and should normally always be `IPNI#0` (YMMV if you have non-standard network interfaces).
- The second is the IP address of the interface, which can be in the format `nn nn nn nn` or (more standard) `nn.nn.nn.nn`
- Then you can specify some parameters for the interface:
  - `DEFAULT` - this is the "primary" address for the host (does not need to be specified if there is only one)
  - `PREFERRED` - this is the "preferred" address for the host (does not need to be specified if there is only one)
  - `PACKET-SIZE:`*nnnn* - the maximum packet size allowed (default 576 decimal, so should most likely be specified)
  - `LOGICAL-HOST-MASK:`*ipmask* - sets the "logical host mask" for this network (what we these days call network mask). **No default**, so should be specified.
  - (additionally `NCP` indicates that this network uses the Arpanet NCP protocol, and `SERIAL` that it is a serial line.)

The original Panda content is:

```
IPNI#0,10.0.0.20,PACKET-SIZE:1500,LOGICAL-HOST-MASK:255.0.0.0,DEFAULT,PREFERRED
```

My content is:

```
IPNI#0,192.168.60.20,PACKET-SIZE:1500,LOGICAL-HOST-MASK:255.255.255.0
```


## Edit SYSTEM:INTERNET.GATEWAYS

This file is read at system startup, and can be re-read by using `LOAD GATEWAY (TABLES)` in the `IPHOST` program.

Specifies the local "prime gateway"(s). I hope you have your TOPS-20 system behind a local gateway, so specify its address. More than one address can be specified. The "ANG" display in `SYSDPY` shows the status (up/down) of the gateways.

The syntax seems to be: *TYPE* *ipaddr*[,*ipaddr*,...] where *TYPE* can be one of `PRIME`, `DUMB`, `HOST` or `ALWAYS-UP`. The default is `PRIME` (and amazingly, only the first character of the keyword is checked, and must be uppercase).

The original Panda content is:

```
PRIME 10.0.0.100, 192.168.1.1
```

My content is:
```
PRIME 192.168.60.1
```

## Edit SYSTEM:HOSTS.TXT

This file is read at system startup, and can be re-read by using `LOAD HOST (TABLES)` in the `IPHOST` program.

It defines local nets and hosts we need to know about in absence of DNS (CHIVES) info. This includes your actual TOPS-20 host, which must have the address specified in your emulator config file as one of its addresses.

The original Panda content is quite self-documenting. Very few of the hosts defined there, if any, are online these days. 

The important thing is to update the following, specifying the correct address (and host name):
```
HOST : 10.0.0.51 : My-System : KLH-KL : TOPS20 : TCP/TELNET,TCP/FTP,TCP/SMTP :
```

*Note*: when booting with `DBUGSW==2`, the file `SYSTEM:HOSTS.DEBUG` is read instead of `SYSTEM:HOSTS.TXT`.

*Note*: you may later want to add CHAOS addresses to this file (see [here](../README.md#systemhoststxt)), ***BUT WAIT*** until you have installed the Chaosnet monitor, since the default Panda monitor will complain and abort reading the file if it has CHAOS addresses in it.

## Edit DOMAIN:RESOLV.CONFIG

Optionally, edit this file to specify your local DNS resolver and local domain, e.g.
```
DSERVE 192.168.0.1        ;My local DNS resolver
RSEARCH .                 ;Try fully qualified first
RSEARCH my.local.dom.ain. ; then my local domain
```

You probably want to specify a lower query timeout than the default 40 seconds, using e.g.
```
QUERY-TIMEOUT 4
```

After installing the Chaosnet monitor, see also [notes about the DNS resolver](../README.md#dns-resolver) and [some additional notes](../README.md#resolv).

## Try it

After making sure the IP address specified in your `klh10.ini` (or corresponding for `simh`) matches what you specified in `SYSTEM:INTERNET.ADDRESS` and in `SYSTEM:HOSTS.TXT`, try rebooting and see if it seems to work. You can e.g. try connecting to your TOPS-20 system using Telnet, and of course check for error messages during start-up.

## Edit non-essential files

### Edit SYSTEM:HOSTNAME.TXT

This file is not used by the monitor, but as a last resort by other programs when trying to find out the local hostname. Put the full domain name of the system here, e.g. `BOOTSTRAP.SRI.COM`.

### Edit SYSTEM:MONNAM.TXT

This file is read at system startup, and is used to construct the text 
```
<text>, TOPS-20 Monitor m.v(e)
```
that is printed when you connect to the system, or by the `INFORMATION (ABOUT) VERSION` command. 

The Panda default content is:
```
Panda Distribution
```

Where I come from, the content is used to describe not only the "monitor name", but the system as such. Examples:

```
TINA, klh10 at Update Computer Club
```

or

```
Aida, DEC-2060 at ICU, Uppsala University
```

### Edit SYSTEM:SYSTEM.CMD
These are commands for `OPR` which are read at system startup (see `SYSTEM:7-1-SYSJOB.RUN`). (*Possibly* you should un-comment the lines starting with `!` towards the end - I did, but I don't recall if it's necessary. Possibly this is DECnet-related.)

### Edit SYSTEM:SYSJB1.RUN

This starts various system programs and subjobs, including network services and `NETSRV` (see below) which can start servers on-demand.

### Edit SYSTEM:NETSRV.RUN

This file specifies which network servers are enabled and started on-demand (as opposed to those started by `SYSJB1`). See `HLP:NETSRV.HLP` for more info.

### Edit greeting messages

#### SYSTEM:INTERNET-LOGIN-MESSAGE.TXT

The message in this file is printed when someone connects using Telnet.

#### SYSTEM:BEWARE-MESSAGE.TXT

This is printed when a new job is created (for non-logged-in, non-PTY jobs).
