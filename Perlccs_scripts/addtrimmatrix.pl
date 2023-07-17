#!/usr/bin/perl

open FL,$ARGV[0];
while(<FL>){
	chomp;
	@ar=split(/\t/,$_);
	$hs_pos{$ar[3]}="$ar[4]\t$ar[5]";
}


open ID,$ARGV[1];
while(<ID>){
	chomp;
	@all=split(/\t/,$_);
	if($hs_pos{$all[8]}){
		print "$_\t$hs_pos{$all[8]}\n";
		}
	}
