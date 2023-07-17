#!/usr/bin/perl


($mac_chr, $mac_len, $mac_reg, $mac_tol)= hashfile("ambiguous.idtomac.bnout");
($mic_chr, $mic_len, $mic_reg, $mic_tol)= hashfile("ambiguous.idtomic.bnout");
($mito_chr, $mito_len, $mito_reg, $mito_tol) = hashfile("ambiguous.idtomito.bnout");

open ID,$ARGV[0];
while(<ID>){
	chomp;
	print "$_\t";
	if($mac_chr->{$_}){
		print "$mac_chr->{$_}\t$mac_len->{$_}\t$mac_reg->{$_}\t$mac_tol->{$_}\t";
	}else{
		print "NA\tNA\tNA\tNA\t";
	}

	if($mic_chr->{$_}){
		print "$mic_chr->{$_}\t$mic_len->{$_}\t$mic_reg->{$_}\t$mic_tol->{$_}\t";
	}else{
		print "NA\tNA\tNA\t";
	}
	
	if($mito_chr->{$_}){
		print "$mito_chr->{$_}\t$mito_len->{$_}\t$mito_reg->{$_}\t$mito_tol->{$_}\t";
	}else{
		print "NA\tNA\tNA\tNA";
	}
	print "\n";
}

sub hashfile{
($file) = @_;
my @all;
my (%hs_chr, %hs_len, %hs_reg, %hs_tol)='';
	open FL,$file;
	while(<FL>){
		chomp;
		@all=split(/\t/,$_);
		$hs_chr{$all[0]}.="$all[1],";
		$hs_len{$all[0]}.="$all[2],";
		$hs_reg{$all[0]}.="$all[6]:$all[7],";
		$hs_tol{$all[0]}=$all[10];
	}
close FL;
	return(\%hs_chr, \%hs_len, \%hs_reg, \%hs_tol);
}
