#!/usr/bin/perl

open ID,$ARGV[0];
while(<ID>){
	chomp;
	$hs_id{$_}=1;
}


open FL,$ARGV[1];
while(<FL>){
	chomp;
	$_=~s/"//g;
	@ele=split(/,/,$_);
	if($hs_id{$ele[0]}){
		}else{
			print "$_\n";
		}
	}
