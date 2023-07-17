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
	$tag="$ele[0]\t$ele[1]";
	if($hs_id{$tag}){
		}else{
			print "$_\n";
		}
	}
