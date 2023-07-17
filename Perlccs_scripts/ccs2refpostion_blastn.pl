#!/usr/bin/perl

open FL,$ARGV[0];
while(<FL>){
	chomp;
	@ar=split(/\t/,$_);
	$hs_dir{$ar[0]}="$ar[-1]";
	$hs_target{$ar[0]}=$ar[1];
	#$tag="$ar[0]$ar[2]";
	if($ar[-1] eq '+'){
		$hs_pos{$ar[0]}="$ar[2]\t$ar[4]";
	}else{
		$hs_pos{$ar[0]}="$ar[2]\t$ar[5]";
	}
}

open CSV,$ARGV[1];
while(<CSV>){
	chomp;
	if($_!~/ref/){
		@ar=split(/,/,$_);
		$ar[0]=~s/"//g;
		#$ar[0]=~s/\/ccs//;
		#@idfmt = split(/\//,$ar[0]);
		#$ar[0]="m_$idfmt[1]";
		#$ar[0]=~s/\//_/g;
		$tag="$ar[0]\t$ar[1]";
		#print "$tag\n";
		if($hs_dir{$ar[0]}  eq '+'){
			$_=~s/,/\t/g;
			@cor_p=split(/\t/,$hs_pos{$ar[0]});
			$genome_p=$ar[1]-$cor_p[0]+$cor_p[1];
				if($ar[2]==0){
					#$genome_p=$ar[1]-$cor_p[0]+$cor_p[1];
					print "$ar[0]\t$ar[1]\t$ar[2]\t$ar[3]\t$ar[8]\t$genome_p\t$hs_target{$ar[0]}\tW\n";
					}else{
					print "$ar[0]\t$ar[1]\t$ar[2]\t$ar[3]\t$ar[8]\t$genome_p\t$hs_target{$ar[0]}\tC\n";
				}
		}
		if($hs_dir{$ar[0]} eq '-'){
			$_=~s/,/\t/g;
			@cor_p=split(/\t/,$hs_pos{$ar[0]});
			$genome_p=$cor_p[1]-($ar[1]-$cor_p[0]);
			if($ar[2]==0){
				print "$ar[0]\t$ar[1]\t$ar[2]\t$ar[3]\t$ar[8]\t$genome_p\t$hs_target{$ar[0]}\tC\n";
			}else{
				print "$ar[0]\t$ar[1]\t$ar[2]\t$ar[3]\t$ar[8]\t$genome_p\t$hs_target{$ar[0]}\tW\n";
			}
		}


	}
}

