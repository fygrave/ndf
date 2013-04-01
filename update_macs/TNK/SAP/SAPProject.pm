package TNK::SAP::SAPProject;
##
## SAP Project Object		svsoldatov July, 2004
##

use TNK::DBAccess;
use TNK::SAP::SAPUtils;


%SAPProjectInfo = (
	ID => { 
		TEXT => 'ID',
		DBFIELD => 'sp_id',
	},
	NAME => { 
		TEXT => 'Название проекта',
		DBFIELD => 'sp_name',
	},
	DESCR => { 
		TEXT => 'Краткое описание проекта',
		DBFIELD => 'sp_descr',
	},
);

Order = ('ID', 'NAME', 'DESCR');

sub new {
	shift;
	my $db = shift;   #database handler
	my $info = shift; #any information
	my $what = shift; #what kind of information
	my $DEBUG = shift;

	return undef unless ($info && $what);
	my $ut = new TNK::SAP::SAPUtils;

	
	$ut->_debug("\$info='$info' \$what='$what'") if $DEBUG;
	
	my @fields = $ut->_getFieldsArray(\%SAPProjectInfo, "DBFIELD");
	my @fields_names = keys %SAPProjectInfo;

	my @result = ();
	if ($what =~ /^ID$/) {
		@result = $db->execSELECT("SELECT ".join(',',@fields)." FROM SAPProjects WHERE sp_id = $info");
	}
	
	my @ar_self = $ut->_mergeArrays(\@fields_names, \@fields);
	my $self = \@ar_self;
	$self->{DEBUG} = $DEBUG;
	
	bless($self);
	
	return $self;
}
#################################################################################
sub printQueryHTML {
	shift;
	my $id = shift;

	print "<TABLE BORDER=\"1\" CELLSPACING=\"0\">\n";
	foreach my $key (@Order){
		print "<TR><TD>".$SAPProjectInfo{$key}->{TEXT}.
			"<TD><input type=\"text\" name=\"${key}_$id\" size=\"100\"></TR>\n";
	}
	print "</TABLE>\n";
}
#################################################################################
sub build {
	shift;
	my $self = shift;

	bless($self);
	return $self;
}
#################################################################################
sub getFields{
	my $self = shift;
	my @fl = @_;
	my @ret = ();
	
	for my $f (@fl) {
		$f = uc $f;
		push @ret, $self->{$f};
	}

	return @ret;
}
#################################################################################
sub getFieldsStr {
	my $self = shift;
	my $delim = shift;
	my @fl = @_;
	my @ret = ();
	
	for my $f (@fl) {
		$f = uc $f;
		push @ret, $self->{$f};
	}

	return join("$delim", @ret);
}
#################################################################################
sub getField{
	my $self = shift;
	my $f = shift;
	$f = uc $f;

	return $self->{$f};
}
#################################################################################
sub toString {
	my $self = shift;

	print join(":", values %{$self}),"\n";
}
#################################################################################
sub print {
	my $self = shift;
	for (keys %{$self}) {
		printf "%15s: %s\n", $_, $self->{$_};
	}
	print "================\n";
}
#################################################################################
sub getSelf {
	my $self = shift;
	return $self;
}
#################################################################################

1;

