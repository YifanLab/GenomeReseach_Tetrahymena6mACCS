#!/usr/bin/perl

open FL,$ARGV[0];
while(<FL>){
	chomp;
	@ar=split(/\t/,$_);
	$hs_coor{$ar[0]}.="$ar[2]:$ar[3],";
	$hs_chr{$ar[0]}.="$ar[1],";
}


open ID,$ARGV[1];
while(<ID>){
	chomp;
	if($hs_coor{$_} and $hs_chr{$_}){
		print "$_\t$hs_coor{$_}\t$hs_chr{$_}\n";
	}
}
