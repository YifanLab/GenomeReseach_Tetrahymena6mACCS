#!/usr/bin/perl

open ID,$ARGV[0];
while(<ID>){
	chomp;
	@ar=split(/\t/,$_);
	$tag="$ar[0]\t$ar[1]";
	$hs_stat{$tag}=$ar[6];
}


open FL,$ARGV[1];
while(<FL>){
	chomp;
	@all=split(/\t/,$_);
	$tmp="$all[0]\t$all[1]";
	if($hs_stat{$tmp}){
		print "$_\t$hs_stat{$tmp}\n";
	}
}
