#!/usr/bin/perl

open FL,$ARGV[0];
while(<FL>){
	chomp;
	@ar=split(/\t/,$_);
	$len=$ar[3]-$ar[2];
	$hs_interval{$ar[0]}.="$ar[2]:$ar[3],";
	$hs_len{$ar[0]}.="$len,";
	$hs_tar{$ar[0]}.="$ar[1],";
	$hs_score{$ar[0]}.="$ar[-1],";
	$hs_tollen{$ar[0]}=$ar[6];
}

foreach(keys %hs_len){
	$hs_len{$_}=~s/,$//;
	@reg_len=split(/,/,$hs_len{$_});
	if($#reg_len==0){
	}else{
	#print "@reg_len";
	$hs_interval{$_}=~s/,$//;
	$hs_tar{$_}=~s/,$//;
	$hs_score{$_}=~s/,$//;
	@reg_int=split(/,/,$hs_interval{$_});
	@reg_tar=split(/,/,$hs_tar{$_});
	@reg_score=split(/,/,$hs_score{$_});
	for($i=0;$i<=$#reg_len-1;$i++){
		for($j=$i+1;$j<=$#reg_len;$j++){
			$tolscore=$reg_score[$i]+$reg_score[$j];
			@region_1=split(/:/,$reg_int[$i]);
			@region_2=split(/:/,$reg_int[$j]);
			#print "$region_1[0]\t$region_1[1]\t$region_2[0]\t$region_2[1]\n";
			if($region_2[0]>=$region_1[0] and $region_2[0]<=$region_1[1]){
				$totallen=$region_2[1]-$region_1[0];
			}else{
				$totallen = $reg_len[$i]+ $reg_len[$j];
			}
			if($totallen/$hs_tollen{$_}>=0.98){

				print "$_\t$reg_int[$i],$reg_int[$j]\t$reg_tar[$i],$reg_tar[$j]\t$hs_tollen{$_}\t$tolscore\t$totallen\n";
				}
			}
		}
	}
}
