#!/usr/bin/perl

open ID,$ARGV[0];
while(<ID>){
	chomp;
	@ar=split(/\t/,$_);
	$tag="$ar[0]\t$ar[1]\t$ar[2]";
	$hs_tag{$tag}=$_;
}


open FL,$ARGV[1];
while(<FL>){
	chomp;
	@all=split(/\t/,$_);
	$tmp="$all[0]\t$all[1]\t$all[2]";
	if($hs_tag{$tmp}){
		print "$_\t$hs_tag{$tmp}\n";
		}
	}
