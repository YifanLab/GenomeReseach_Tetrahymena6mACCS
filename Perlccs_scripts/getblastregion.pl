#!/usr/bin/perl

open BL,$ARGV[0];
while(<BL>){
	chomp;
	@ar=split(/\t/,$_);
	$hs_id{$ar[0]}="$ar[1]\t$ar[4]\t$ar[5]";
	}


open FL,$ARGV[1];
while(<FL>){
	chomp;
	@all=split(/\t/,$_);
	$all[0]=~s/\s+//;
	if($hs_id{$all[0]}){
		print "$_\t$hs_id{$all[0]}\n";
		}
	}
