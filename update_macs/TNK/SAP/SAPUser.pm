package TNK::SAP::SAPUser;
##
## SAPUser Object		svsoldatov July, 2004
##

use TNK::DBAccess;
use TNK::SAP::SAPUtils;
use TNK::CGIx;

%SAPUserInfo = (
	ID => { 
		TEXT => 'ID',
		DBFIELD => 'su_id',
	},
	FIO => { 
		TEXT => 'ФИО',
		DBFIELD => 'su_fio',
	},
	LOGIN => { 
		TEXT => 'Логин',
		DBFIELD => 'su_login',
	},
	PHONE => { 
		TEXT => 'Телефон',
		DBFIELD => 'su_phone',
	},
	ROOM => { 
		TEXT => 'Номер комнаты',
		DBFIELD => 'su_room',
	},
	FUNCTION => { 
		TEXT => 'Должность',
		DBFIELD => 'su_position',
	},
	GROUP => { 
		TEXT => 'Группа',
		DBFIELD => 'su_group',
	},
	COMPANY => { 
		TEXT => 'Компания',
		DBFIELD => 'su_company',
	},
	DISABLED => { 
		TEXT => 'Статус в системе',
		DBFIELD => 'su_disabled',
	},
	DATEOSN => { 
		TEXT => 'Дата основания',
		DBFIELD => 'su_dateosn',
	},
	OSN => { 
		TEXT => 'Основание для заведения',
		DBFIELD => 'su_osn',
	},
	CREATED => { 
		TEXT => 'Дата создания',
		DBFIELD => 'su_autodate',
	},
	WHO => { 
		TEXT => 'Кто создал',
		DBFIELD => 'su_whocreated',
	},
	COMMENTS => { 
		TEXT => 'Комментарий',
		DBFIELD => 'su_comments',
	},
	SYSTEM => { 
		TEXT => 'Система',
		DBFIELD => 'su_system',
	},
	MANDANT => { 
		TEXT => 'Мандант',
		DBFIELD => 'su_mandant',
	},
	SECTION => { 
		TEXT => 'Подразделение',
		DBFIELD => 'su_section',
	},
);
#@OrderQuery = keys %SAPUserInfo;
@OrderQuery = ('FIO','LOGIN','GROUP','PHONE','ROOM','FUNCTION','SECTION','COMPANY','DISABLED','DATEOSN','OSN','COMMENTS','SYSTEM','MANDANT');
$DB_TABLE = 'SAPUSER';


#sub new {
#	shift;
#	my $db = shift;   #database handler
#	my $info = shift; #any information
#	my $what = shift; #what kind of information
#	my $DEBUG = shift;
#
#	return undef unless ($info && $what);
#	my $ut = new TNK::SAP::SAPUtils;
#
#	
#	$ut->_debug("\$info='$info' \$what='$what'") if $DEBUG;
#	
#	my @fields = $ut->_getFieldsArray(\%SAPUserInfo, "DBFIELD");
#	my @fields_names = keys %SAPUserInfo;
#
#	my @result = ();
#	if ($what =~ /^ID$/) {
#		@result = $db->execSELECT("SELECT ".join(',',@fields)." FROM SAPUsers WHERE su_id = $info");
#	}
#	
#	my @ar_self = $ut->_mergeArrays(\@fields_names, \@fields);
#	my $self = \@ar_self;
#	$self->{DEBUG} = $DEBUG;
#	
#	bless($self);
#	
#	return $self;
#}

sub new {
	shift;
	my $USER_ID = shift;
	my $DEBUG = shift;
	my $self = {};
	$self->{DEBUG} = $DEBUG;
	$self->{USER_ID} = $USER_ID;
	
	bless($self);
	
	return $self;
}
#################################################################################
sub getID {
	my $self = shift;
	return $self->{USER_ID};
}
sub setID {
	my $self = shift;
	my $id = shift;

	if ($id =~ /^\d+$/){
		$self->{USER_ID} = $id;
		return $id;
	}
	else {
		return undef;
	}
}
#################################################################################
sub printQueryHTML {
	my $self = shift;
	my $id = shift;

	print "<TABLE BORDER=\"1\" CELLSPACING=\"0\">\n";
	foreach my $key (@OrderQuery){
		print "<TR><TD>".$SAPUserInfo{$key}->{TEXT}.
			"<TD><input type=\"text\" name=\"${key}_$id\" size=\"100\"></TR>\n";
	}
	print "</TABLE>\n";
}
#################################################################################
sub insertUserQuery {
	my $self = shift;
	my $id = shift;
	my $params = shift;
	my $db = shift;
	my (@dbfields, @dbvalues) = ();

	for my $key (@OrderQuery){
		push @dbfields, $SAPUserInfo{$key}->{DBFIELD};
		push @dbvalues, "'".$params->{"${key}_$id"}."'";
	}
	my $dbfieldsstr = join ',',@dbfields;
	my $dbvaluesstr = join ',',@dbvalues;
	
	$db->execDO("INSERT INTO $DB_TABLE($dbfieldsstr) VALUES ($dbvaluesstr)");
	my $identity = $db->execSELECT('SELECT @@IDENTITY');
	return $identity;
}
#################################################################################
sub build {
	shift;
	my $self = shift;

	bless($self);
	return $self;
}
#################################################################################
sub getSelf {
	my $self = shift;
	return $self;
}
#################################################################################
sub getFields{
	my $self = shift;
	my $db = shift;
	my @fl = @_;
	my @ret = ();
	
	for my $f (@fl) {
		$f = uc $f;
		my $dbfl = $SAPUserInfo{$f}->{DBFIELD};
		my ($r) = $db->execSELECT("SELECT $dbfl FROM $DB_TABLE WHERE su_id = ".$self->{USER_ID});
		push @ret, $r;
	}

	return @ret;
}
#################################################################################
sub printHTML {
	my $self = shift;
	my $qx = new TNK::CGIx();
}

#################################################################################

1;

