# Documentation for CHANM% (JSYS 460)

## Function
Obtains information about Chaosnet hosts.

## Restrictions
For Chaosnet systems only.

## Calling sequence
- AC1: Function code
- AC2: Function-specific argument
- AC3: Function-specific argument

## Returns
+1: Always.

## Function codes

0. `.CHNPH` Return local primary name and number.

    Accepts in AC2: Destination BP

    Returns: 
	- AC1: Host number (local Chaosnet address)
	- AC2: Updated dest BP
	
1. `.CHNSN` Translate host name to number (address)

	Accepts in AC2: Source BP (to host name)
	
	Returns:
	- AC1: Host number (Chaosnet address)
	- AC2: Updated source BP
	
2. `.CHNNS` Translate host number (address) to name

	Accepts:
	- AC2: Destination BP
	- AC3: Host number (address)

	Returns:
	- AC2: Updated destination BP

## CHANM% error mnemonics:

<dl>
<dt>ARGX09</dt>
<dd>Invalid byte size (of pointer argument)</dd>
<dt>CHNX01</dt>
<dd>Invalid or Unknown Chaosnet Host Name</dd>
<dt>CHNX02</dt>
<dd>Invalid or Unknown Chaosnet Host Number</dd>
<dt>CHNX03</dt>
<dd>Local Chaosnet host information not set</dd>
</dl>
