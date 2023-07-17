#!/usr/bin/perl

open FL,$ARGV[0];
while(<FL>){
	chomp;
	@ar=split(/\t/,$_);
	$hs_dir{$ar[0]}="$ar[-1]";
	$hs_q2r{$ar[0]}=$ar[3];
	$end=$ar[4];
	#$file=$ar[0];
	for($i=$ar[1];$i<$ar[2];$i++){
		#$file=~s#/#_#g;
		#$file=~s/_ccs//;
		#$q_tmp="$ar[0]\t$i";
		#$r_tmp="$ar[3]\t$end";
		$hs_ref{$ar[0]}.="$i:";
		$hs_target{$ar[3]}.="$end:";
		$end++;

		#open POS,">>ccs2genome_Pos/$file.pos";
		#print "$q_tmp\t$r_tmp\n";
	}
}

foreach(keys %hs_dir){
	if($hs_q2r{$_}){
		$hs_ref{$_}=~s/:$//;
		$hs_target{$hs_q2r{$_}}=~s/:$//;
		@ar1=split(/:/,$hs_ref{$_});
		@ar2=split(/:/,$hs_target{$hs_q2r{$_}});
		if($hs_dir{$_} eq '-'){
			@ar2 = reverse(@ar2);
			#shift @ar2;
			#pop @ar1;
		}else{
			@ar2 = @ar2;
		}
		for($i=0;$i<=$#ar1;$i++){
			$q_tmp="$_\t$ar1[$i]";
			#$q_tmp=~s#/#_#g;
			#$q_tmp=~s/_ccs//;
			$r_tmp="$hs_q2r{$_}\t$ar2[$i]\t$hs_dir{$_}";
			$hs_pos{$q_tmp}=$r_tmp;
		}
	}
}

open CSV,$ARGV[1];
while(<CSV>){
	chomp;
	if($_!~/ref/){
		@ar=split(/,/,$_);
		$ar[0]=~s/"//g;
		$tag="$ar[0]\t$ar[1]";
		#print "$tag\n";
		if($hs_pos{$tag}){
			$_=~s/,/\t/g;
			if($hs_pos{$tag}=~/\+/){
				if($ar[2]==0){
					print "$ar[0]\t$ar[1]\t$ar[2]\t$ar[3]\t$ar[8]\t$hs_pos{$tag}\tW\n";
					}else{
					print "$ar[0]\t$ar[1]\t$ar[2]\t$ar[3]\t$ar[8]\t$hs_pos{$tag}\tC\n";
				}
			}else{
				if($ar[2]==0){
					print "$ar[0]\t$ar[1]\t$ar[2]\t$ar[3]\t$ar[8]\t$hs_pos{$tag}\tC\n";
				}else{
					print "$ar[0]\t$ar[1]\t$ar[2]\t$ar[3]\t$ar[8]\t$hs_pos{$tag}\tW\n";
				}
			}
		}
	}
}

