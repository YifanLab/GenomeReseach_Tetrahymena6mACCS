#!/usr/bin/perl 

open ID,$ARGV[0];
while(<ID>){
	chomp;
	@all=split(/\t/,$_);
	$all[0]=~s/\s+$//;
	$hs_id{$all[3]}=$_;
}

open FL,$ARGV[1];
while(<FL>){
	chomp;
	@ar=split(/\t/,$_);
	$ar[0]=~s/\s+$//;
	if($hs_id{$ar[-1]}){
		print "$_\t$hs_id{$ar[-1]}\n";
		}
	}
