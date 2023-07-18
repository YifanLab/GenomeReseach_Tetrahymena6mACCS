# Pre-requisites:

	. SMRT LINK v10.1
	. samtools
	. perl
	. Python (>=3.8) with pysam (>=0.15.4), numpy(>=1.18.1), pandas, statsmodel, and statistics libraries.


# How to use it?
The command lines for each step were recorded in the cmd_reference.sh. Please refer to this file.
## calculate IPD ratio from raw subread
	Usage: python3.8 pacbiomethy_withoutref.py raw.subreads.bam -t 16
 		input: raw.subreads.bam
   		-t: thread

## calculate SD and Nstar for each single molecule
	cat sb210.subreadextractec.xls |perl -ne 'chomp;@ar=split(/\t/,$\_);if($ar\[1\]>=30){$ar[0]=~s#/#_#g;print "perl sdcal_foreachzmw.pl ipd_csv/$ar\[0\].csv >allipdsd.xls\n" >ipdsd_ecgt30x_files.sh

	sh ipdsd_ecgt30x_files.sh

	 cat subreads.gt30_allid_Nstar_all.id sb210_sdlt0.35.30x.id |sed 's/"//g'|sort|uniq |cat ecgt30.id -|sort |uniq -c|grep '      1 '|sed 's/      1 //' >sb210_sdlt0.35.30x.Nstar.final.id

	
