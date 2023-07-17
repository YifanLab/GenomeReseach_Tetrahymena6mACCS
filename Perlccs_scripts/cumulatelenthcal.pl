#!/usr/bin/perl

open FL,$ARGV[0];
while(<FL>){
	chomp;
	@ar=split(/\t/,$_);
	$hs_id{$ar[0]}+=$ar[2]-$ar[1]+1;
	$hs_que{$ar[0]}.="$ar[1]:$ar[2],";
	$hs_tar{$ar[0]}.="$ar[3],";
	if($_=~/:(\d+)/){
		$hs_len{$ar[0]}=$1;
		}
}

foreach(keys %hs_id){
	if($hs_id{$_}){
		$hs_que{$_} =~ s/,$//;
		$hs_tar{$_} =~ s/,$//;
		$per = $hs_id{$_}/$hs_len{$_};
		print "$_\t$hs_que{$_}\t$hs_tar{$_}\t$hs_id{$_}\t$per\n";
	}
}
