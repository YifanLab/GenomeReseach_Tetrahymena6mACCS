#!/usr/bin/perl
#
open ID,$ARGV[0];
while(<ID>){
	chomp;
	@ar=split(/:/,$_);
	if($ar[1]){
		$hs_id{$ar[0]}=$ar[1];
	}else{
		$hs_id{$ar[0]}='full';
	}
}


open CSV,$ARGV[1];
while(<CSV>){
	chomp;
	$_=~s/"//g;
	@all=split(/,/,$_);
	if($hs_id{$all[0]} eq 'full'){
		print "$_\n";
	}
	if($hs_id{$all[0]} and $hs_id{$all[0]} ne 'full'){
		($start, $end)= split(/-/,$hs_id{$all[0]});
		if($all[1]>= $start and $all[1]<=$end){
			print "$all[0]:${start}-${end},$all[1],$all[2],$all[3],$all[4],$all[5],$all[6],$all[7],$all[8],$all[9],$all[10]\n";
		}
	}
}
