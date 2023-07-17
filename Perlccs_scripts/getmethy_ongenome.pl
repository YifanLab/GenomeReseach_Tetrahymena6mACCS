#!/usr/bin/perl

open BL,$ARGV[0];
while(<BL>){
	chomp;
	@ar=split(/\t/,$_);
	$tag="$ar[0]\t$ar[1]";
	$hs_id{$tag}="$ar[-1]";
	}


open FL,$ARGV[1];
while(<FL>){
	chomp;
	@all=split(/\t/,$_);
	$all[0]=~s/\s+//;
	$tmp="$all[0]\t$all[1]";
	if($hs_id{$all[0]}){
		print "$_\t$hs_id{$tmp}\n";
		}
	}
