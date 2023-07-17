#!/usr/bin/perl
#
open MAC,$ARGV[0];
while(<MAC>){
	chomp;
	@ar=split(/\t/,$_);
	$hs_mac{$ar[0]}=$ar[3];
}

open MIC,$ARGV[1];
while(<MIC>){
	chomp;
	@all=split(/\t/,$_);
	$hs_mic{$all[0]}=$all[3];
}

foreach(keys %hs_mic){
	if($hs_mac{$_}){
		print "$_\t$hs_mac{$_}\t$hs_mic{$_}\n";
	}
}
