// Roll your rules here

rule Chinese_exploit_pack_sample
{
    strings:
        $sample0 = "mailto:hjy@hjy9.cn"
    condition:
        $sample0
}
	
