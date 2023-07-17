#!/usr/bin/perl
#
open FL,$ARGV[0];
while(<FL>){
	chomp;
	@ar=split(/\t/,$_);
	$hs_region{$ar[0]}.="$ar[2]:$ar[3],";
	$tmp="$ar[0]\t$ar[2]:$ar[3]";
	$hs_id{$tmp}=$_;
}

foreach(keys %hs_region){
	$hs_region{$_}=~s/,$//;
	@interval=split(/,/,$hs_region{$_});
	if($#interval==0){
		$hs_filter{"$_\t$interval[0]"}=$hs_id{"$_\t$interval[0]"};
	}
	if($#interval >0){
		for($i=0;$i<=$#interval-1;$i++){
			for($j=$i+1;$j<=$#interval;$j++){
				@region1=split(/:/,$interval[$i]);
				@region2=split(/:/,$interval[$j]);
				if($region1[0] <= $region2[0] and $region1[1] >= $region2[1]){
					$interval[$j] = undef;
				}elsif($region1[0] >= $region2[0] and $region1[1] <= $region2[1]){
					$interval[$i] = undef;
				}
			}
		}
		for($k =0; $k<=$#interval; $k++){
			$hs_filter{"$_\t$interval[$k]"} = $hs_id{"$_\t$interval[$k]"};
		}
	}
}

foreach(keys %hs_filter){
	print "$hs_filter{$_}\n";
}
