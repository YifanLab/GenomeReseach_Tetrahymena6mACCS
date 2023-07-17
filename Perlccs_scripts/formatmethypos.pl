#!/usr/bin/perl

open FL,$ARGV[0];
while(<FL>){
	chomp;
	@ar=split(/\t/,$_);
	$hs_ele{$ar[3]}="$ar[0]\t$ar[1]\t$ar[2]";
	$hs_tag{$ar[3]}.="$ar[5],";
}




foreach(keys %hs_tag){
	if($hs_tag{$_}){
		$hs_tag{$_}=~s/,$//;
		@ele=split(/,/,$hs_tag{$_});
		@ele = sort{$a <=> $b} @ele;
		print "$hs_ele{$_}\t$_\t$ele[0]\t$ele[-1]\n";
		}
	}
