# Processing raw Pacbio subread.bam

python3.8 pacbiomethy_withoutref.py raw.subreads.bam -t 16

# extract all IPD ratio values for base A

## obtain effect coverage(ec) for each reads

samtools view subread.hifi.bam|perl -ne 'chomp;@ar=split(/\t/,$\_);for($i=0;$i<=$#ar;$i++){if($ar\[$i\]=~/ec:f:(\S+)/){$cov=int($1+1);print "$ar\[0\]\t$ar\[$i\]\t$cov\n"}}' >sb210.subreadextractec.xls 

## Extract the IPD ratio values for reads with ec>=30

cat sb210.subreadextractec.xls |perl -ne 'chomp;@ar=split(/\t/,$\_);if($ar\[1\]>=30){print "$ar\[0\]\n"}' > ecgt30.id

cat sb210.subreadextractec.xls |perl -ne 'chomp;@ar=split(/\t/,$\_);if($ar\[1\]>=30){$ar\[0\]=~s#/#_#g;print "cat ipd_csv/$ar\[0\].csv\n" >cat_ecgt30x_files.sh

sh cat_ecgt30_files.sh >subreads.gt30x.all.csv

cat subreads.gt30x.all.csv|grep ',A,' > subreads.gt30x.allA.csv


## Obtain dinucleotide sequence

perl adddinucleotidebase.pl ccs2genome.fasta subreads.gt30x.allA.csv > subreads.gt30x.allAX.csv

cat subreads.gt30x.allAX.csv |grep AT > subreads.gt30x.allAT.csv


# Calculate the SD for a single molecule

cat sb210.subreadextractec.xls |perl -ne 'chomp;@ar=split(/\t/,$\_);if($ar\[1\]>=30){$ar[0]=~s#/#_#g;print "perl sdcal_foreachzmw.pl ipd_csv/$ar\[0\].csv >allipdsd.xls\n" >ipdsd_ecgt30x_files.sh

sh ipdsd_ecgt30x_files.sh

cat allipdsd.xls |egrep 'A|T'|grep -v all|perl -ne 'chomp;@ar=split(/\t/,$\_);if($ar\[6\]>=0.35){print "$_\n"}' >allipdsdgt3.5.all.id

# Determine N cluster in a single molecule

cat subreads.gt30x.allAX.csv | grep -v ',A,'|perl -ne 'chomp;@ar=split(/,/,$_);if($ar\[2\]==0 and $ar\[8\]>=2.8){print "$\_\n"}' > subreads.gt30x.Nclu_s0.csv

cat subreads.gt30x.allAX.csv | grep -v ',A,'|perl -ne 'chomp;@ar=split(/,/,$_);if($ar\[2\]==1 and $ar\[8\]>=2.8){print "$\_\n"}' > subreads.gt30x.Nclu_s1.csv

cat subreads.gt30x.Nclu_s0.csv | sed 's/,/\t/g'|perl detectcluster_inlimted_totaldis.pl - >subreads.gt30_allipd_Nstar_s0.xls

cat subreads.gt30x.Nclu_s1.csv | sed 's/,/\t/g'|perl detectcluster_inlimted_totaldis.pl - >subreads.gt30_allipd_Nstar_s1.xls

cat subreads.gt30_allid_Nstar_s0.xls subreads.gt30_allipd_Nstar_s1.xls |cut -f 1|sort|uniq > subreads.gt30_allid_Nstar_all.id

# fiter Nstar and sd<=0.35 reads

cat subreads.gt30_allid_Nstar_all.id sb210_sdlt0.35.30x.id |sed 's/"//g'|sort|uniq |cat ecgt30.id -|sort |uniq -c|grep '      1 '|sed 's/      1 //' >sb210_sdlt0.35.30x.Nstar.final.id

perl ../../mll1_seq2/gettargetccs.pl  ccs2genome.fasta >sb210.sd0.35Nclu.fasta

# Chimerica reads detection with blastn

blastn  -query sb210.sd0.35Nclu.fasta -num_threads 40  -db alltetraseq.fa  -word_size 50 -outfmt "6 qacc sacc length nident  mismatch gaps qstart qend sstart send qlen slen bitscore score evalue" >sb210To_alltetra.bnout

cat sb210To_alltetra.bnout |grep mac|sort -k1,1 -k3,3nr|sort -k1,1 -u --merge|perl -ne 'chomp;@ar=split(/\t/,$_);if($ar[2]/$ar[10]>=0.95){print "$_\n"}' >fullen_2allmac.toplen.xls 

cat sb210To_alltetra.bnout |grep mic|sort -k1,1 -k3,3nr|sort -k1,1 -u --merge|perl -ne 'chomp;@ar=split(/\t/,$_);if($ar[2]/$ar[10]>=0.95){print "$_\n"}' >fullen_2allmic.toplen.xls

cat fullen_2allmac.toplen.xls fullen_2allmic.toplen.xls|cut -f 1 |sort|uniq -c|grep '      2 '|sed 's/      2 //' >fullmacvsmic.overlap.id

cat ful.mapped2mac.id fullmacvsmic.overlap.id |cut -f 1|sort|uniq|cat fullen_2allmac.toplen.xls -|cut -f 1|sort|uniq >fulmac.id

cat sb210To_alltetra.bnout |sort -k1,1 -u --merge >sb210.ecgt30To_alltetra.best.bnout

less sb210.ecgt30To_alltetra.best.bnout |grep mic|perl -ne 'chomp;@ar=split(/\t/,$_);$per=$ar\[2\]/$ar\[10\];print "$ar\[0\l]\t$per\n"'|sort -k2,2n >sb210Tomic.per.xls

less sb210.ecgt30To_alltetra.best.bnout |grep mac|perl -ne 'chomp;@ar=split(/\t/,$_);$per=$ar\[2\]/$ar\[10\];print "$ar\[0\]\t$per\n"'|sort -k2,2n >sb210Tomac.per.xls

less sb210.ecgt30To_alltetra.best.bnout |grep mito|perl -ne 'chomp;@ar=split(/\t/,$_);$per=$ar\[2\]/$ar\[10\];print "$ar\[0\]\t$per\n"'|sort -k2,2n >sb210Tomito.per.xls

cat sb210Tomac.per.xls |perl -ne 'chomp;@ar=split(/\t/,$\_);if($ar\[-1\]<0.98){print "$ar\[0\]\n"}' >ambiguous.mappedtotetra.id

cat sb210Tomic.per.xls |perl -ne 'chomp;@ar=split(/\t/,$\_);if($ar\[-1\]<0.95){print "$ar\[0\]\n"}' >>ambiguous.mappedtotetra.id

cat sb210Tomito.per.xls |perl -ne 'chomp;@ar=split(/\t/,$\_);if($ar\[-1\]<0.95){print "$ar\[0\]\n"}' >>ambiguous.mappedtotetra.id

perl /project/yalidou_405/Pacbio_pipeline/YifanLab-main/sb210_seq2_rep2/5e318406-a881-11ec-a98e-b07b25d42266/blast_mapping/ccsanalysi_Perl/getfasta.pl sb210.sd0.35Nclu.fasta ambiguous.mappedtotetra.id >ambiguous.mappedtotetra.fa

blast -query ambiguous.mappedtotetra.fa -num_threads 40  -db alltetraseq.fa  -word_size 50 -outfmt "6 qacc sacc length nident  mismatch gaps qstart qend sstart send qlen slen bitscore score evalue" > ambiguous.mappedtotetra.all.bnout

perl splitbnoutintosingle.pl ambiguous.mappedtotetra.all.bnout

for i in `ls ambigu_smbnout/*.bnout`; do echo "perl compareintervel.pl  $i | sort -k 1,1 -k3,3n | grep -v '^$' >./ambigu_filter/`basename $i .bnout`.filter.xls";done >runsm_filterbnout.sh

sh runsm_filterbnout.sh

for i in `ls ./ambigu_filter/*.xls`; do echo "perl intro_onepoint.pl $i ";done >runintro1point.sh

sh runintro1point.sh >all.1point.xls

less all.1point.xls |perl -ne 'chomp;@ar=split(/\t/,$_);@ele=split(/\,/,$ar[1]);print "$ar[0]\t$ele[0]\n$ar[0]\t$ele[1]\n"'|sed 's/:/\t/g'|bedtools getfasta -fi ../ccs2genome.fasta -bed - -name >all1point.fa

blast -query all1point.fa -num_threads 40  -db alltetraseq.fa  -word_size 50 -outfmt "6 qacc sacc length nident  mismatch gaps qstart qend sstart send qlen slen bitscore score evalue" > allintro1point_2alltetra.bnout

cat allintro1point_2alltetra.bnout|grep mac|sort -k1,1 -k3,3nr|sort -k1,1 -u --merge|perl -ne 'chomp;@ar=split(/\t/,$_);if($ar[2]/$ar[10]>=0.95){print "$_\n"}' >allintro1point_2allmac.toplen.xls

cat allintro1point_2allmac.toplen.xls mic1point.mapped2mac.id |cut -f 1|sort|uniq|cat allintro1point_2allmac.toplen.xls -|cut -f 1|sort|uniq >partialmac.id


perl match_mic2mac_samid.pl fullen_2allmac.toplen.xls fullen_2allmic.toplen.xls |perl -ne 'chomp;@ar=split(/\t/,$\_);$per=$ar\[-2\]/$ar\[-1\];print "$_\t$per\n"'|sort -k4n|perl -ne 'chomp;@ar=split(/\t/,$\_);if($ar\[-1\]>=0.98){print "$\_\n"}' >ful.mapped2mac.id

cat ful.mapped2mac.id fullmacvsmic.overlap.id |cut -f 1|sort|uniq|cat fullen_2allmac.toplen.xls -|cut -f 1|sort|uniq >fulmac.id

perl /project/yalidou_405/Pacbio_pipeline/YifanLab-main/mll1_seq2/blast_mapping/filterpartial.pl ful.all.id partialmac.id >partialmac.filterfull.id

cat fulmac.id partialmac.filterfull.id >mac.final.id

perl gettargetcsv.pl mac.final.id subreads.gt30x.allA.csv >subreads.gt30.mac.allA.csv

perl gettargetcsv.pl mac.final.id subreads.gt30x.allAT.csv >subreads.gt30.mac.allAT.csv

## Obtain IPD ratio distribution for all AX

python3.8 countAarray.py

## Deconvoluted the curve and determine the cutoff for 6mA calling

python3.8 m6A_axdistribution.py #output the threshold value >=2.38 for WT

## extract all 6mA sites

cat subreads.gt30x.mac.allAT.csv | perl -ne 'chomp;@ar=split(/,/,$_);if($ar\[-3\]>=2.38){print "$\_\n"}' >subread.gt30x.mac.allAT.methyA.csv


# Determine dinucleotide AT status


cat subreads.gt30x.mac.allAT.csv | perl -ne 'chomp;@ar=split(/,/,$_);if($ar\[2\]==0){print "$\_\n"}' > subreads.gt30x.mac.allAT_s0.csv

cat subreads.gt30x.mac.allAT.csv | perl -ne 'chomp;@ar=split(/,/,$_);if($ar\[2\]==1){print "$\_\n"}' > subreads.gt30x.mac.allAT_s1.csv

perl formatAT2pointplot.pl subreads.gt30x.mac.allAT_s0.csv subreads.gt30x.mac.allAT_s1.csv >subreads.gt30x.mac.ATfor2Dplot.xls

perl getATdinuc.pl subreads.gt30x.mac.allAT_s0.csv subreads.gt30x.mac.allAT_s1.csv >Cstrand_ipdratioDis.withWmethy.csv

python3.8 countATarrayforonestrand.py 

perl getATstatus.pl subreads.gt30x.mac.allAT_s0.csv subreads.gt30x.mac.allAT_s1.csv  >subread.AT.methystat.xls









# Brdu calling 


##30xid and ec number##
samtools view subread.hifi.bam|perl -ne 'chomp;@ar=split(/\t/,$_);print "$ar[0]\t";for($i=1;$i<=$#ar;$i++){if($ar[$i]=~/^np:i/){print "$ar[$i]\t"};if($ar[$i]=~/^ec:f/){print "$ar[$i]\t"}};print "\n"'|sort|uniq >ccs.np_ec.xls
cat ccs.np_ec.xls |perl -ne 'chomp;if($_=~/np:i:(\d+)/){$cov=$1+1;if($cov>=30){print "$_\n"}}' |cut -d '/' -f 2|perl -ne 'chomp;print "m_$_\n"' >ccs.30xall.id

##generate blasr cmd#
cat ccs.np_ec.xls |perl -ne 'chomp;if($_=~/np:i:(\d+)/){$cov=$1+1;if($cov>=20){print "$_\n"}}'|cut -d '/' -f 2 |perl -ne 'chomp; print "blasr ./bam_sm/m_${_}.bam  ./ref_fasta/m_${_}.fasta --bestn 10 --minMatch 12 --maxMatch 30 --nproc 24 --minSubreadLength 50 --minAlnLength 50 --minPctSimilarity 75 --minPctAccuracy 75 --printSAMQV --hitPolicy randombest --concordant --randomSeed 1 --refineConcordantAlignments --bam --out ./bam_align/m_${_}.blasr.bam\n"' >runblasrmapping.sh

##generate bam index##
cat ccs.np_ec.xls |perl -ne 'chomp;if($_=~/np:i:(\d+)/){$cov=$1+1;if($cov>=20){print "$_\n"}}'|cut -d '/' -f 2 |perl -ne 'chomp;print "pbindex ./bam_align/m_${_}.blasr.bam\n"' >runbamindex.sh

##generate ipdsummary cmd#
cat ccs.np_ec.xls |perl -ne 'chomp;if($_=~/np:i:(\d+)/){$cov=$1+1;if($cov>=20){print "$_\n"}}'|cut -d '/' -f 2 |perl -ne 'chomp;print "ipdSummary ./bam_align/m_${_}.blasr.bam  --reference ./ref_fasta/m_${_}.fasta --identify m6A --csv ./ipd_csv/m_${_}.csv\n"' >runipdsummary.sh


#/project/yalidou_405/Pacbio_pipeline/YifanLab-main/PG3683HMMmouse_batch2/PBG11905/demultiplexing_files/c967c354-7665-11ed-a0ac-9cb654aa842c/distrifasta.pl

##extract all >=30x molecules##

sh  /project/yalidou_405/Pacbio_pipeline/YifanLab-main/Brdu_CCS/brdu_syn4h/filecat.sh >sbatchcatallcsv.sh

sh /project/yalidou_405/Pacbio_pipeline/YifanLab-main/Brdu_CCS/brdu_syn1.5h/splitandcatfile.sh batchcatallcsv.sh

less brdu2.allT_ar10.Tstargt15.csv|perl -ne 'chomp;@ar=split(/,/,$_);if($ar[-3]>=2.5){print "$_\n"}'|perl /project/yalidou_405/Pacbio_pipeline/YifanLab-main/Brdu_CCS/07a5af0a-439e-11ed-904b-b07b25d42266/getbrduTsite.pl - >brdu2.allTbrdusitecount.xls

for i in `ls ipd30x*.xls`;do echo "nohup perl /project/yalidou_405/Pacbio_pipeline/YifanLab-main/Brdu_CCS/brdu_syn4h/sdcal_foreachzmw.pl $i >`basename $i .xls`.sd.xls 2>err.log&";done >runsdcal.sh


##detect Nstar sites#


for i in `ls ipd30x.*.xls`;do echo "nohup cat $i |grep -v ',A,'|perl -ne 'chomp;@ar=split(/,/,\$_);if(\$ar[2]==0 and \$ar[8]>=2.8){print \"\$_\n\"}' >`basename $i  .xls`.s0.Nstar.xls 2>err.log&";done >runNsite_s0.sh
for i in `ls ipd30x.*.xls`;do echo "nohup cat $i |grep -v ',A,'|perl -ne 'chomp;@ar=split(/,/,\$_);if(\$ar[2]==1 and \$ar[8]>=2.8){print \"\$_\n\"}' >`basename $i  .xls`.s1.Nstar.xls 2>err.log&";done >runNsite_s1.sh




##

cat x*.cmb.Nclu_s0.csv|sed 's/,/\t/g'|perl /project/xwang787_650/PB_000352_human/WG_AMT1/detectcluster_inlimted_totaldis.pl - >brdu0.Nclu_s0.xls
cat x*.cmb.Nclu_s1.csv|sed 's/,/\t/g'|perl /project/xwang787_650/PB_000352_human/WG_AMT1/detectcluster_inlimted_totaldis.pl - >brdu0.Nclu_s1.xls

cat brdu1.5.Nclu_s[01].xls|cut -f 1|sort|uniq|sed 's/"//g'|sort|uniq >brdu1.5.Nclu_both.id


cat *.sd.xls|egrep 'A|T'|grep -v all|perl -ne 'chomp;@ar=split(/\t/,$_);if($ar[6]>=0.35){print "$ar[0]\n"}'|sort|uniq -c|grep '      4 '|sed 's/      4 //' |sed 's/"//g' >sm.atbothgt3.5.id
cat *.sd.xls|egrep 'A|T'|grep -v all|perl -ne 'chomp;@ar=split(/\t/,$_);if($ar[6]>=0.35){print "$ar[0]\n"}'|sort|uniq  |sed 's/"//g' >sm.ateithergt3.5.id

nohup cat ipd30x.xa*.addinc.xls |grep ',T,' >brdu1.5.allT.raw.csv 2>err.log&
nohup cat ipd30x.xa*.addinc.xls |grep ',A,' >brdu1.5.allA.raw.csv 2>err.log&


for i in `ls ipd30x.xa[abcdefghij].xls`;do echo "nohup cat $i|grep -v refName|  perl /project/xwang787_650/PB_000352_human/WG_AMT1/adddinucleotidebase.pl ccs2genome.fasta  - >`basename $i .xls`.adddinuc.csv 2>err.log&";done >runadddinucfinal.sh

##path of scripts##
/project/xwang787_650/PB_000352_human/WG_AMT1/detectcluster_inlimted_totaldis.pl
/project/xwang787_675/MLL_Seq2/sdcal_foreachzmw.pl

for i in `ls x*.adddinc.csv`;do echo "nohup perl /project/xwang787_675/MLL_Seq2/sdcal_foreachzmw.pl $i >`basename $i .csv`.sd.xls 2>err.log&";done >runsdcal.sh
less brdu2.allTbrdusitecount.xls|perl -ne 'chomp;@ar=split(/\t/,$_);if($ar[3]>=$ar[4]){print "$ar[0]\t$ar[1]\tW\n$ar[0]\t$ar[2]\tC\n"}else{print "$ar[0]\t$ar[1]\tC\n$ar[0]\t$ar[2]\tW\n"}' |grep C|perl gettargetsiteipd.pl - brdu2.allT_ar10gt15.Tstarsite.xls >brdu2.allT.newstrandWipd.xls

nohup less brdu2.allT.newstrandCipd.xls|cut -d ',' -f 1,3|sort|uniq |perl getstrandTdistri.pl - brdu2.allT_ar10.Tstargt15.csv >brdu2plus.allT.newstrandCipd.xls 2>err.log&

nohup cat sm.ateithergt3.5.id  brdu0.Nclu_both.id | sort |uniq |perl ../filtersm.pl - brdu0.allA.raw.csv  >brdu0.allA.filterstrict.csv 2>err.log&

nohup python3.8 /project/yalidou_405/Pacbio_pipeline/YifanLab-main/Brdu_CCS/countAarray.py brdu0.allA.filterstrict.csv brdu0filter 2>err.log&

parallel -j 60  -a ./runipdsd_all.sh



##Hemi count#
cat brdu0.CmethyWstat.xls |grep Hemi|perl -ne 'chomp;@ar=split(/\t/,$_);if($ar[4]>=1.569){$_=~s/\t/,/g;print "$_\n"}'|perl ../../Brdu_CCS/brdu_syn2h/getbrduTsite.pl - >brdu0.CmethyW.count.xls



nohup cat brdu0.Tstarcount.xls |perl -ne 'chomp;@ar=split(/\t/,$_);if($ar[-1]+$ar[-2]>=15){print "$_\n"}'|cut -f 1 |perl /project/yalidou_405/Pacbio_pipeline/YifanLab-main/Brdu_CCS/brdu_syn2h/gettargetsm.pl - brdu0.allT.filterstrict.ar10removeadddinuc.csv > brdu0.Tplussm.allT.xls 2>err.log&
nohup cat brdu0.Tstarcount.xls |perl -ne 'chomp;@ar=split(/\t/,$_);if($ar[-1]+$ar[-2]>=15){print "$_\n"}' |perl -ne 'chomp;@ar=split(/\t/,$_);if($ar[-1] >= $ar[-2]){print "$ar[0],0\n"}else{print "$ar[0],1\n"}' |perl /project/yalidou_405/Pacbio_pipeline/YifanLab-main/Brdu_CCS/brdu_syn2h/getstrandTdistri.pl - brdu0.Tplussm.allT.xls >brdu0.oldstrand.allT.xls 2>err.log&
nohup cat brdu0.Tstarcount.xls |perl -ne 'chomp;@ar=split(/\t/,$_);if($ar[-1]+$ar[-2]>=15){print "$_\n"}' |perl -ne 'chomp;@ar=split(/\t/,$_);if($ar[-1] >= $ar[-2]){print "$ar[0],1\n"}else{print "$ar[0],0\n"}' |perl /project/yalidou_405/Pacbio_pipeline/YifanLab-main/Brdu_CCS/brdu_syn2h/getstrandTdistri.pl - brdu0.Tplussm.allT.xls >brdu0.newstrand.allT.xls 2>err.log&



nohup cat ccs.np_ec.xls |perl -ne 'chomp;if($_=~/np:i:(\d+)/){$cov=$1+1;if($cov>=30){print "$_\n"}}'|cut -f 1|cat  brdu0.Nclu_both.id sm.ateithergt3.5.id  -|sort|uniq -c|grep '      1 '|sed 's/      1 //'|perl /project/yalidou_405/Pacbio_pipeline/YifanLab-main/sb210_seq2_rep2/5e318406-a881-11ec-a98e-b07b25d42266/blast_mapping/ccsanalysi_Perl/getfasta.pl ccs2genome.fasta - >ccsec30sdclufilter.fasta 2>err.log&
nohup blastn -max_target_seqs 1  -max_hsps 1   -query ccsec30sdclufilter.fasta -num_threads 6  -db /project/xwang787_675/wentao_tmic/Tetrahymena_Mac/tmac.genome.fasta  -word_size 50 -outfmt "6 qacc sacc length nident  mismatch gaps qstart qend sstart send qlen slen bitscore score evalue" >brdu4r2ccs2mac.bnout 2>err.log&

cat brdu1.5r1ccs2mac.bnout|perl -ne 'chomp;@ar=split(/\t/,$_);if($ar[2]/$ar[10]>=0.98){if($ar[8] > $ar[9]){print "$ar[0]\t-1\n"}else{print "$ar[0]\t1\n"}}' |perl /project/yalidou_405/Pacbio_pipeline/YifanLab-main/brdu_synchonized/sb210brdu_0h/fmtstrand_hemi.pl - brdu1.5.CmethyW.count.xls |perl -ne 'chomp;@ar=split(/\t/,$_);if($ar[-1]  +  $ar[-2]>=11){print "$_\n"}'|wc -l
cat brdu1.5r1ccs2mac.bnout|perl -ne 'chomp;@ar=split(/\t/,$_);if($ar[2]/$ar[10]>=0.98){if($ar[8] > $ar[9]){print "$ar[0]\t-1\n"}else{print "$ar[0]\t1\n"}}' |perl /project/yalidou_405/Pacbio_pipeline/YifanLab-main/brdu_synchonized/sb210brdu_0h/fmtstrand_hemi.pl - brdu1.5.CmethyW.count.xls |perl -ne 'chomp;@ar=split(/\t/,$_);if($ar[-1] >= 11 or  $ar[-2]>=11){print "$_\n"}'|wc -l


##sd w vs c##
cat *.sd.xls|grep A|grep -v all >ipd20x.allA.wcsd.xls
ggplot(ipdsd, aes(x= V7.x, y = V7.y))+geom_point(size=0.1)+geom_bin_2d(bins=500)+scale_fill_gradient2(low='blue2', mid = 'navyblue',  high='red', midpoint = 80)+scale_x_continuous(expand = c(0,0), limits = c(0, 0.8))+scale_y_continuous(expand = c(0,0), limits = c(0, 0.8))+geom_vline(xintercept = 0.35, lty='dashed')+geom_hline(yintercept = 0.35, lty='dashed') +theme_bw()

##add shadow on figures##
library(ggplot2)
library(ggpattern)

df <- data.frame(timepoint = c('0h', '1.5h', '2h', '4h', '0h', '1.5h', '2h', '4h'), percentage = c(0.11, 2.50, 5.62, 9.84, 0.05, 1.94, 4.54, 7.06), gty = c('W + C >=15', 'W + C >=15', 'W + C >=15', 'W + C >=15',  'W || C >= 15', 'W || C >= 15', 'W || C >= 15', 'W || C >= 15'))
df <- data.frame(timepoint = c('0h', '1.5h', '2h', '4h', '0h', '1.5h', '2h', '4h'), percentage = c(1, 4.94, 3.75, 2.83, 1, 5.37, 3.77, 2.91), gty = c('W + C >=11', 'W + C >=11', 'W + C >=11', 'W + C >=11',  'W || C >= 11', 'W || C >= 11', 'W || C >= 11', 'W || C >= 11'))
ggplot(data = df, aes(x=timepoint, y = percentage, fill = timepoint, pattern = gty)) +geom_col_pattern(position = position_dodge(0.6), color='black', pattern_fill = 'black', width = 0.5, pattern_spacing=0.03)+scale_fill_manual(values = c("#8d8b8b","#fea040","#fe8204", "#ff6100"))+ scale_pattern_manual(values = c ('stripe', 'none'))+guides(pattern = guide_legend(override.aes = list(fill = "white")), fill = guide_legend(override.aes = list(pattern = "none", color = NA))) +scale_x_discrete(expand = c(0,0))+scale_y_continuous(expand = c(0,0))+theme_classic()


ggplot(data = df, aes(x=timepoint, y = percentage, fill = timepoint, pattern = gty)) +geom_col_pattern(position = position_dodge(0.6), color='black', pattern_fill = 'black', width = 0.5, pattern_spacing=0.06)+scale_fill_manual(values = c("#8d8b8b","#fea040","#fe8204", "#ff6100"))+ scale_pattern_manual(values = c ('stripe', 'none'))+guides(pattern = guide_legend(override.aes = list(fill = "white")), fill = guide_legend(override.aes = list(pattern = "none", color = NA))) +scale_x_discrete(expand = c(0,0))+scale_y_break(breaks = c(0.2, 1), scales = 'free', expand = c(0,0))+theme_classic()


##CCS to genome##
cat ccs2mm10.blastn.best.bnout |cut -f 1-2,7-10|perl -ne 'chomp;@ar=split(/\t/,$_);$len=$ar[3]-$ar[2];if($ar[4]>$ar[5]){$end=$ar[5]+$len;print "$ar[0]\t$ar[1]\t$ar[2]\t$ar[3]\t$ar[5]\t$end\t-\n"}else{$end=$ar[4]+$len;print "$ar[0]\t$ar[1]\t$ar[2]\t$ar[3]\t$ar[4]\t$end\t+\n"}'|perl -ne 'chomp;@ar=split(/\t/,$_);if($_!~/:/){print "$_\n"}else{if($ar[0]=~/:(\d+)\-(\d+)/){$start=$1;$tmpend=$2;$end=$tmpend-$start;print "$ar[0]\t$ar[1]\t$start\t$end\t$ar[4]\t$ar[5]\t$ar[6]\n"}}' >ccs2hg19.transwithnew.xls
perl /project/yalidou_405/Pacbio_pipeline/YifanLab-main/sb210_seq2_rep2/5e318406-a881-11ec-a98e-b07b25d42266/blast_mapping/ccsanalysi_Perl/ccs2refpostion_blastn.pl ccs2hg19.transwithnew.xls WGA_EcoGII/ecgo2_to_ec20gt1k.methy.xls
