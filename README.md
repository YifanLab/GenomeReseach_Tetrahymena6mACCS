#Processing raw Pacbio subread.bam#

python3.8 pacbiomethy_withoutref.py raw.subreads.bam -t 16

###extract all IPD ratio values for base A###

#obtain effect coverage(ec) for each reads#

samtools view subread.hifi.bam|perl -ne 'chomp;@ar=split(/\t/,$_);for($i=0;$i<=$#ar;$i++){if($ar[$i]=~/ec:f:(\S+)/){$cov=int($1+1);print "$ar[0]\t$ar[$i]\t$cov\n"}}' >sb210.subreadextractec.xls 

#extract the ipd ratio values for reads with ec>=30#

cat sb210.subreadextractec.xls |perl -ne 'chomp;@ar=split(/\t/,$_);if($ar[1]>=30){$ar[0]=~s#/#_#g;print "cat ipd_csv/$ar[0].csv\n" >cat_ecgt30x_files.sh
sh cat_ecgt30_files.sh >subreads.gt30x.all.csv
cat subreads.gt30x.all.csv|grep ',A,' > subreads.gt30x.allA.csv

#obtain dinucleotide sequence#

perl adddinucleotidebase.pl ccs2genome.fasta subreads.gt30x.allA.csv > subreads.gt30x.allAX.csv
cat subreads.gt30x.allAX.csv |grep AT > subreads.gt30x.allAT.csv

#obtain IPD ratio distribution for all AX

python3.8 countAarray.py

#deconvoluted the curve and determine the cutoff for 6mA calling#

python3.8 m6A_axdistribution.py #output the threshold value >=2.38 for WT

#extract all 6mA sites#

cat subreads.gt30x.allAT.csv |perl -ne 'chomp;@ar=split(/,/,$_);if($ar[-3]>=2.38){print "$_\n"}' >subread.gt30x.allAT.methyA.csv


