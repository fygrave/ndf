package TNK::SAP::SAPUtils;
##
## Useful Utils 		svsoldatov, July, 2004
##

sub new {
	shift;
	my $self = {};

	bless($self);
	return $self;
}
######################################################
sub _delSpaces {
	my $self = shift;
	my @ret = ();
	for my $i (@_) {
		$i =~ s/^\s*//;
		$i =~ s/\s*$//;
		push @ret, $i;
	}
	return @ret;
}
######################################################
sub _debug {
	my $self = shift;
	my $msg = shift;

	print "<p><b><i>$msg</i></b></p>\n";
}

######################################################
sub _getFieldsArray {
	my $self = shift;
	my $h = shift;
	my $f = shift;

	my @ret = ();

	foreach my $k (keys %{$h}){
		push @ret, $h->{$k}->{$f};
	}

	return @ret;
	
}
######################################################
sub _mergeArrays {
	my $self = shift;
	my $a1 = shift;
	my $a2 = shift;
	my @ret = ();

	for (my $i = 0; $i < @{$a1}; $i++) {
		push @ret, ($a1->[$i], $a2->[$i]);
	}

	return @ret;
}
######################################################


1;


