#!/usr/bin/perl
#
open FL,$ARGV[0];
while(<FL>){
	chomp;
	@ar=split(/\t/,$_);
	$hs_tag{$ar[0]}=$_;
}

open ID,$ARGV[1];
while(<ID>){
	chomp;
	$_=~s/\r//;
	@all=split(/\t/,$_);
	if($hs_tag{$all[0]}){
		print "$_\t$hs_tag{$all[0]}\n";
	}else{
		print "$_\t0\t0\t0\t0\t0\n";
	}
}
