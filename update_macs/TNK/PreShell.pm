package TNK::PreShell;
##
## modifies strings for sell commands	svsoldatov, August,2005
##

sub new {
	shift;
	my $self = { };
	bless($self);
	return $self;
}

#
# preGrep
#
sub preGrep {
	my ($self,$str) = @_;

	$str =~ s/\\/\\\\\\/g;
	$str =~ s/\./\\./g;
	$str =~ s/ /\\ /g;
	$str =~ s/&/\\&/g;
	$str =~ s/\$/\\\$/g;

	return $str;

}

1;

