#!/usr/bin/perl -w

use strict;
my (%hs_p,%hs_m);
my @id;
my $tmp;
my $npos;
my (@ctrand, @mtrand);

%hs_p=getAT($ARGV[0]);
%hs_m=getAT($ARGV[1]);

foreach (keys %hs_p){
	#print "$_\t$hs_p{$_}\n";
	@id=split(/\t/,$_);
	$npos=$id[1]+1;
	$tmp="$id[0]\t$npos";
	@ctrand="";
	@mtrand="";
	if($hs_m{$tmp}){
		@ctrand=split(/\t/,$hs_p{$_});
		@mtrand=split(/\t/,$hs_m{$tmp});
		if($ctrand[-2] >=2.549){
			print "$hs_m{$tmp}\n";
		}
		#if(($ctrand[-2] >=2.8 and $mtrand[-2] <=1.6) or ($ctrand[-2] <=1.6 and $mtrand[-2]>=2.8)){
		#	print "$hs_p{$_}\tHemi\n$hs_m{$tmp}\tHemi\n";
		#}
	}
}




sub getAT{
	my ($file)=@_;
	my @ar;
	my %hs_id;
	open FL,$file;
	while(<FL>){
		chomp;
		@ar=split(/,/,$_);
		#if($ar[-1] eq 'AT'){
			$hs_id{"$ar[0]\t$ar[1]"}="$ar[0]\t$ar[1]\t$ar[2]\t$ar[3]\t$ar[-3]\tAT";
			#}
	}
	return %hs_id;
}
