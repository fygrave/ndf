// Roll your rules here

rule Chinese_exploit_pack_sample
{
    strings:
        $sample0 = "mailto:hjy@hjy9.cn"
    condition:
        $sample0
}
	
rule ObfuscatedJS
{
    strings:
        $s = "fromCharCode"
    condition:
        all of them
}

rule MSIEUseAfterFree: decodedOnly
{
	meta:
		ref = "CVE-2010-0249"
		hide = true
        impact = 5
	strings:
		$cve20100249_1 = "createEventObject" nocase fullword
		$cve20100249_2 = "getElementById" nocase fullword
		$cve20100249_3 = "onload" nocase fullword
		$cve20100249_4 = "srcElement" nocase fullword
	condition:
		all of them
}

rule ObfuscationPattern
{ 
	meta:
		impact = 0
	strings:
		$eval = "eval" nocase fullword
		$charcode = ".fromCharCode" nocase fullword
		$loc = "location" nocase fullword
	condition:
		2 of them
}

