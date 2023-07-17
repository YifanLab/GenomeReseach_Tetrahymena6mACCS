#!/usr/bin/perl

open FA,$ARGV[0];
while(<FA>){
	chomp;
	if($_=~/>(\S+)/){
		$tag=$1;
	}else{
		$hs_seq{$tag}.=$_;
	}
}


open ID,$ARGV[1];
while(<ID>){
	chomp;
	$hs_id{$_}=1;
	#if($hs_seq{$_}){
	#	print ">$_\n$hs_seq{$_}\n";
	#}
}


foreach(keys %hs_seq){
	if($hs_id{$_}){
	}else{
		print ">$_\n$hs_seq{$_}\n";
	}
}
