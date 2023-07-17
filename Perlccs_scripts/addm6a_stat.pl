#!/usr/bin/perl 

open FL,$ARGV[0];
while(<FL>){
	chomp;
	@ar=split(/\t/,$_);
	$tag="$ar[0]\t$ar[1]";
	$hs_stat{$tag}=$ar[-1];
}

open ID,$ARGV[1];
while(<ID>){
	chomp;
	@all=split(/\t/,$_);
	$tmp="$all[0]\t$all[1]";
	if($hs_stat{$tmp}){
		print "$_\t$hs_stat{$tmp}\n";
	}
}
