#!/usr/bin/perl 

open ID,$ARGV[0];
while(<ID>){
	chomp;
	#@all=split(/\t/,$_);
	#$all[0]=~s/\s+$//;
	$hs_id{$_}=$_;
}

open FL,$ARGV[1];
while(<FL>){
	chomp;
	@ar=split(/,/,$_);
	$ar[0]=~s/\s+$//;
	$ar[0]=~s/"//g;
	if($hs_id{$ar[0]}){
		print "$_\n";
		}
	}
