#!/usr/bin/perl
#use strict;

open IPD,$ARGV[0];
while(<IPD>){
	chomp;
	if($_!~/^ref/){
		@ar=split(/,/,$_);
		$tmp="$ar[0]\t$ar[2]\t$ar[3]";
		$all="$ar[0]\tall\t$ar[3]";
		if($ar[-3]<=2.8 and $ar[3] eq 'A'){
			$hs_ipd{$tmp}.="$ar[-3],";
			$hs_ipd{$all}.="$ar[-3],";
		}
		if($ar[-3]<=2.5 and $ar[3] eq 'T'){
			$hs_ipd{$tmp}.="$ar[-3],";
			$hs_ipd{$all}.="$ar[-3],";
		}
		if($ar[3]=~'C|G'){
			$hs_ipd{$tmp}.="$ar[-3],";
			$hs_ipd{$all}.="$ar[-3],";
		}
		$hs_cov{$ar[0]}.="$ar[-2],";
	}
}

foreach(sort keys %hs_ipd){
	if($hs_ipd{$_}){
		@allid=split(/\t/,$_);
		$sta= statis($hs_ipd{$_});
		#push @allcov,$hs_cov{$_};
		#$allec = join(',',@allcov);
		@cov_sta=split(/\t/,statis($hs_cov{$allid[0]}));
		$avg_cov=int($cov_sta[2]+0.5)*2;
		print "$_\t$sta\t$avg_cov\n";
	}
}




sub statis{
	my($all)=@_;
	my (@allipd,@min,$max,$ave,$sd);
	$all=~s/\,$//;
	#print "$all\n";
	@allipd=split(/,/,$all);
	($min,$max,$ave) = minmax(@allipd);
	($sd,$cv)= std_dev($ave,@allipd);
	return ("$min\t$max\t$ave\t$sd\t$cv");
}

sub minmax{
	my (@array)=@_;
	my ($min,$max,$ave)=(0,0,0);
	my @sorted = sort { $a <=> $b } @array;
	$min=$sorted[0];
	$max=$sorted[-1];
	my $count = scalar @sorted;
	my $total = 0; 
	$total += $_ for @sorted;
	if($count){
		$ave=$total/$count;
	}
	return ($min,$max,$ave);
}

sub std_dev {
	my ($average, @values) = @_;
	my ($std_ev,$cv)=(0,0);
	my $count = scalar @values;
	my $std_dev_sum = 0;
	$std_dev_sum += ($_ - $average) ** 2 for @values;
	if($count){
		$std_ev = sqrt($std_dev_sum / $count);
		$cv = $std_ev / $average;
	}
	return ($std_ev, $cv);
}
