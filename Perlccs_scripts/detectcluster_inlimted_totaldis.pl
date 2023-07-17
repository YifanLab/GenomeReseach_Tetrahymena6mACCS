#!/usr/bin/perl

#$ar="2, 7,20,30,40,89,91,112,115,143,175,312,354,378,419";
#cludis('zmw1',$ar);

open FL,$ARGV[0];
while(<FL>){
	chomp;
	@ar=split(/\t/,$_);
	#$ar[0]=~s#/#_#g;
	#$ar[0]=~s/_ccs//;
	$hs_at{$ar[0]}.="$ar[1],";
}

foreach(keys %hs_at){
	if($hs_at{$_}){
		$hs_cl{$_}=cludis($_,$hs_at{$_});
	}
}


foreach(keys %hs_cl){
	print "$hs_cl{$_}";
}

sub cludis{
	my ($id,$pos)=@_;
	my %hs_clu;
	my @final=();
	my $final;
	$pos=~s/,$//;
	@ar=split(/,/,$pos);
	$count=0;
	for($i=0;$i<=$#ar-1;$i++){
		@all=();
		$clu='';
		#$count++;
		push @all,$ar[$i];
		for($j=$i+1;$j<=$#ar;$j++){
			#print "$i\t$j\n";
			if($ar[$j]-$ar[$i]<=25){
				push @all ,$ar[$j];
				if($j==$#ar){
				#print "$j\n";
					$i=$#ar;
					last;
				}
			#print "@all\n";
			}else{
			#unshift @all, $ar[$i];
			#$i=$j;
				$i=$j-1;
				last;
			#print "@all\n";
			}
		#$i=$j;
		#print "$i\t$j\n";
		#print "@all\n";
		#last;
		}
		$clu = join ':', @all;
		$atn = scalar @all;
		if($atn>=3){
			$count++;
			$tag="$id\t$count";
			push @final, "$tag\t$clu\t$atn\n";
		}
		#$hs_clu{$tag}.="$tag\t$clu\t$atn\n";
		#print "$count\t$clu\t$atn\n";
	}
	$final=join('',@final);
	#print "$final\n";
	return $final;
}
