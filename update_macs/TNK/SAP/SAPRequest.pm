package TNK::SAP::SAPRequest;
##
## SAP Request Object		svsoldatov July, 2004
##

use TNK::DBAccess;
use TNK::SAP::SAPUtils;


%SAPRequestInfo = (
	ID => { 
		TEXT => 'ID',
		DBFIELD => 'srq_id',
	},
	TYPE => { 
		TEXT => 'Тип запроса',
		DBFIELD => 'srq_type',
	},
	INITIATOR => {
		TEXT => 'Инициатор изменения от бизнеса',
		DBFIELD => 'srq_initiator',             #fk from SAPUsers
	},
	DUTY => {
		TEXT => 'Ответственный',
		DBFIELD => 'srq_duty',                  #fk from SAPUsers
	},
	CHIEF => {
		TEXT => 'Начальник',
		DBFIELD => 'srq_chief',                 #fk from SAPUsers
	},
	REQBASIS => {
		TEXT => 'Основание',
		DBFIELD => 'srq_basis',
	},
	REQBASISDATE => {
		TEXT => 'Дата основания',
		DBFIELD => 'srq_basis_date',
	},
	CHANGESINFO => {
		TEXT => 'Описание изменений',
		DBFIELD => 'srq_changes_info',
	},
	AUTODATE => {
		TEXT => 'Дата ввода заявки',
		DBFIELD => 'srq_autodate',
	},
	WHO => {
		TEXT => 'Запрос ввел',
		DBFIELD => 'srq_who',
	},
);

Order = keys %SAPRequestInfo;

sub new {
	shift;
	my $db = shift;   #database handler
	my $info = shift; #any information
	my $what = shift; #what kind of information
	my $DEBUG = shift;

	return undef unless ($info && $what);
	my $ut = new TNK::SAP::SAPUtils;

	
	$ut->_debug("\$info='$info' \$what='$what'") if $DEBUG;
	
	my @fields = $ut->_getFieldsArray(\%SAPRoleInfo, "DBFIELD");
	my @fields_names = keys %SAPRoleInfo;

	my @result = ();
	if ($what =~ /^ID$/) {
		@result = $db->execSELECT("SELECT ".join(',',@fields)." FROM SAPRole WHERE sp_id = $info");
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
		print "<TR><TD>".$SAPRoleInfo{$key}->{TEXT}.
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

