package TNK::ArrayAcademUtils;
##
## usefull academic utils 4 Arrays		svsoldatov August, 2005
##

#############
# functions #
#############
# uniun - return union of 2 arrays
# isect - intersection
# isEqual - return 1 if (@a) == (@b)
# grepArr - return 1 if all @a is in @b

sub new {
  shift;
  my $tag = shift;
  
  my $self = {
	TAG => $tag,
  };

  bless($self);

  return $self;
}

##################################################################################
sub MIN {
	my ($self, $a) = @_;
	if ( @{$a} > 0 ){
		my $ret = $a->[0];
		foreach my $t (@{$a}){
			if($t < $ret){
				$ret = $t;
			}
		}
		return $ret;
	}
	else {
		return undef;
	}
}

sub MAX {
	my ($self, $a) = @_;
	if ( @{$a} > 0 ){
		my $ret = $a->[0];
		foreach my $t (@{$a}){
			if($t > $ret){
				$ret = $t;
			}
		}
		return $ret;
	}
	else {
		return undef;
	}
}

sub uniq_diff {
	my ($self,$a,$b) = @_;
	
	my @ret = ();
	my %tt = ();
	foreach my $e (@{$a}, @{$b}){
		$tt{$e}++;
	}
	foreach my $k (keys %tt){
		push @ret, $k if $tt{$e} == 1;
	}

	return \@ret;
}

sub uniun {
	my $self = shift;
	my $a = shift;
	my $b = shift;
	
	my @r = $self->__ui($a,$b);
	return $r[0];
}
sub isect {
	my $self = shift;
	my $a = shift;
	my $b = shift;
	
	my @r = $self->__ui($a,$b);
	return $r[1];
}

sub isEqual {
	my $self = shift;
	my $a = shift;
	my $b = shift;
	my @as = sort @{$a};
	my @bs = sort @{$b};
	##print "<P>".join(', ',@{$a})."(".join(', ',@as).") <> ".join(', ',@{$b})."(".join(', ',@bs).")</P>\n"; #DEBUG
	
	if(scalar(@{$a}) != scalar(@{$b})){
		return 0;
	}
	
	for(my $i=0; $i<@as; $i++){
		##print "<P>$as[$i] <> $bs[$i]</P>\n"; #DEBUG
		unless ($as[$i] eq $bs[$i]){
			return 0;
		}
	}
	return 1;
}

sub grepArr {
	my $self = shift;
	my $a = shift;
	my $b = shift;
	
	my $inters = $self->isect($a,$b);

	return $self->isEqual($a,$inters);
}

sub __ui {
	my $self = shift;
	my $a = shift;
	my $b = shift;
	
	# lieve uniq
	my %t = ();
	foreach my $e (@{$a}){
		$t{$e}++;
	}
	my @as = keys %t;
	my %t = ();
	foreach my $e (@{$b}){
		$t{$e}++;
	}
	my @bs = keys %t;
	
	
	my %union = ();
	my %isect = ();
	foreach my $ee (@as,@bs) {$union{$ee}++ && $isect{$ee}++}

	my @ua = sort keys %union;
	my @ia = sort keys %isect;

	return (\@ua, \@ia);
}

sub __debug {
	my $self = shift;
	my $msg = shift;

	print "\n<p>",$msg,"</p>\n";
}

1;

