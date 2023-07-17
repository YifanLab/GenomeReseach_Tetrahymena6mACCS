#!/usr/bin/perl

open FL,$ARGV[0];
while(<FL>){
	chomp;
	@ar=split(/\t/,$_);
	$hs_id{$ar[0]}=$_;
}

open ID,$ARGV[1];
while(<ID>){
	chomp;
	@all=split(/\t/,$_);
	if($hs_id{$all[8]}){
		print "$_\t$hs_id{$all[8]}\n";
	}
}
