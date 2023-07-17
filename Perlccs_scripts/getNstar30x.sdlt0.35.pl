#!/usr/bin/perl

open FA,$ARGV[0];
while(<FA>){
	chomp;
	if($_=~/m\S+\/(\d+)\/ccs/){
		$tag="m_$1";
	}else{
		$hs_seq{$tag}.="$_";
	}
}



open ID,$ARGV[1];
while(<ID>){
	chomp;
	if($hs_seq{$_}){
		print ">$_\n$hs_seq{$_}\n";
	}
}
