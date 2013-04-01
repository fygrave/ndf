package TNK::AcademUtils;
##
## usefull academic utils		svsoldatov april, 2005
##

#############
# functions #
#############
# indexOf - return index of element in array

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

sub indexOf {
	my $self = shift;
	my $s = shift;
	my $ar = shift;
	
	for(my $i = 0; $i < @{$ar}; $i++){
		return $i if $s eq $ar->[$i];
	}
	return undef;

}

sub maxLenIndex {
	my ($self, $a) = @_;
	my $l = 0;
	foreach (@{$a}){
		my $li = length;
		$l = $li if $l < $li;
	}
	return $l;
}

sub firstKeyOf {
	my ($self, $val, $h ) = @_;
	
	foreach (keys %{$h} ){
		return $_ if $val eq $h->{$_};
	}
	return undef;
}

sub keysValues {
	my ($self, $h) = @_;
	
	my @ret = ();
	foreach (keys %{$h} ){
		push @ret, $h->{$_};
	}
	return @ret;
}

sub __debug {
	my $self = shift;
	my $msg = shift;

	print "\n<p>",$msg,"</p>\n";
}

1;

