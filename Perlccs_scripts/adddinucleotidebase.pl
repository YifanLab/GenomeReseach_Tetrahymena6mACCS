#!/usr/bin/perl -w
use strict;

my $id;
my %hs_seq;
my @ipd;
my $dinuc;

open FL,$ARGV[0];
while(<FL>){
	chomp;
	if($_=~/^>(\S+)/){
		$id=$1;
		#$id=~s/\//_/g;
		#$id=~s/_ccs$//;
		#print "$id\n";
	}else{
		$hs_seq{$id}.=$_;
	}
}

open IPD,$ARGV[1];
while(<IPD>){
	chomp;
	@ipd=split(/,/,$_);
	$ipd[0]=~s/"//g;
	if($hs_seq{$ipd[0]}){
		if($ipd[2]==0){
			$dinuc = substr($hs_seq{$ipd[0]},$ipd[1]-1,2);
			print "$_,$dinuc\n";
		}else{
			my $start=$ipd[1]-2;
			if($start<0){
				$dinuc = substr($hs_seq{$ipd[0]},0,1);
				$dinuc=~tr/ATCG/TAGC/;
				$dinuc=reverse($dinuc);
			}else{
				$dinuc = substr($hs_seq{$ipd[0]},$start,2);
				$dinuc=~tr/ATCG/TAGC/;
				$dinuc=reverse($dinuc);
			}
			print "$_,$dinuc\n";
		}
	}
}
			
	

