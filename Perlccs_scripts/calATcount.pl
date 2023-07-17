#!/usr/bin/perl
#
#
open FA,$ARGV[0];
while(<FA>){
	chomp;
	if($_=~/^>(\S+)/){
		$tag=$1;
	}else{
		$hs_seq{$tag}.=$_;
	}
}

foreach (keys  %hs_seq ) {
	if($hs_seq{$_}){
		$len=length($hs_seq{$_});
		$hs_seq{$_}=~s/AT/z/g;
		$atcount=($hs_seq{$_}=~tr/z//);
		print "$_\t$atcount\t$len\n";
	}
}
