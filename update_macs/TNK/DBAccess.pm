package TNK::DBAccess;
##
## Provide access to DB (tested on MSSQL)		svsoldatov march, 2003
##

#############
# functions #
#############
# get_password($password_file) - return password to connect to DB  from specified file
# connect2MSSQL($host, $user, $pwfile, $param) - connect to MSSQL Server
# connect2MSSQL_odbc($dsn, $user, $pwfile, $param) - connects to MSSQL via ODBC
# disconnect - disconnects (and for ODBC too)
# execSQL($query) - executes SQL query that doesn't return any values, returns statement handler
# execDO($query) - executes SQL query that doesn't return any values, returns result of execute()
# execSELECT($query) - exec SQL query that returns values
# execSELECT_prepared($sth,$bind_params) - executes SQL query of dynamic SQL (with ?) already prepared, returns results in execSELECT way
# execSELECT_last($query, $return_fields_number) - return last cortage from select
# get_identity($str,$ch) - returns quoted $str, if $ch - returns quoted by $ch
# procBeforeInsert(@arr) - returns quoted @arr, if $arr[$i] = '', subst it into NULL

use strict;
use DBI;

sub new {
  shift;
  my $server = shift;
  my $separator = shift;

  my $self = {
	DBH => undef,
  };

  bless($self);

  return $self;
}
 
##################################################################################
sub get_password {
  my $self = shift;
  my $password_file = shift;

  #open PW, "<$password_file" ||  sys_log("cannot open $password_file: $!",'error');
  #chomp (my $pw = <PW>);
  #close PW;
  unless( defined( do "$password_file" ) ){
    die "cannot open $password_file: $!\n";
  }
  my $pw = $connect::data::p;
  return $pw;
}
##################################################################################
sub connect2MSSQL {
  my $self = shift;
  my ($host, $user, $pwfile, $param) =@_;
  my $pw = $self->get_password($pwfile);

  my $dbh = DBI->connect("dbi:Sybase:server=$host", $user, $pw, $param) || die $DBI::errstr,"\n";
  $self->{DBH} = $dbh;
}
##################################################################################
sub connect2MSSQL_odbc {
  my $self = shift;
  my ($dsn, $user, $pwfile, $param) =@_;
  my $pw = $self->get_password($pwfile);

  my $dbh = DBI->connect("dbi:ODBC:$dsn", $user, $pw, $param) || die $DBI::errstr,"\n";
  $dbh->{LongReadLen} = 2000000;
  $self->{DBH} = $dbh;
}
##################################################################################
sub disconnect {
  my $self = shift;
  $self->{DBH}->disconnect;
}

##################################################################################
sub execSQL {
  my $self = shift;
  my $q = shift;

  my $sth = $self->{DBH}->prepare($q);
  if ($DBI::errstr || $self->{DBH}->errstr){
  	$self->_riseERROR($DBI::errstr." (".$self->{DBH}->errstr.") \nQUERY(execSQL prepare): \"$q\"\n"); 
	return undef;
  }
  $sth->execute(); 
  if ($DBI::errstr || $self->{DBH}->errstr){
  	$self->_riseERROR($DBI::errstr." (".$self->{DBH}->errstr.") \nQUERY(execSQL execute): \"$q\"\n"); 
	return undef;
  }
  return $sth;
}
##################################################################################
sub execDO {
  my $self = shift;
  my $q = shift;

  my $sth = $self->{DBH}->prepare($q);
  my $rv = $sth->execute(); 
  if ($DBI::errstr || $self->{DBH}->errstr){
  	$self->_riseERROR($DBI::errstr." (".$self->{DBH}->errstr.") \nQUERY(execDO execute): \"$q\"\n"); 
	return undef;
  }
  return $rv;
}

##################################################################################
#this function special by DATECOMP to find latest data
sub execSELECT_last {
  my $self = shift;
  my $q = shift;
  my @key = ();
  ##print "<BR><b>execSELECT_last:</b><BR>\n";

  my $sth = $self->execSQL($q);
  while(my @r = $sth->fetchrow_array){
	@key = reload(\@key, \@r);
	##print "<BR><b>\@key='@key'; \@r='@r'</b><BR>\n";
  }
  return @key;
}
##################################################################################
sub reload {
	my $old = shift;
	my $new = shift;
	
	for (@{$new}) {
		if (! defined($_)) {
			return @{$old};
		}
	}
	return @{$new};
}
##################################################################################
sub execSELECT {
  my $self = shift;
  my $q = shift;
  my @ret = ();
  my $sth;
    
  $sth =  $self->{DBH}->prepare($q); 
  if ($DBI::errstr || $self->{DBH}->errstr){
  	$self->_riseERROR($DBI::errstr." (".$self->{DBH}->errstr.") \nQUERY(execSELECT prepare): \"$q\"\n"); 
	return undef;
  }
  
  $sth->execute(); 
  if ($DBI::errstr || $self->{DBH}->errstr){
  	$self->_riseERROR($DBI::errstr." (".$self->{DBH}->errstr.") \nQUERY(execSELECT execute): \"$q\"\n");
	return undef;
  }
  
  while(my @row_array = $sth->fetchrow_array){
    push(@ret,@row_array);
  }
  return @ret;
}

sub execSELECT_prepared {
	my ($self,$sth,$bp) = @_;
	my @ret = ();
	
	return undef unless $sth;

	$sth->execute(@{$bp});
	if ($DBI::errstr || $self->{DBH}->errstr){
		$self->_riseERROR($DBI::errstr." (".$self->{DBH}->errstr.") \n");
		return undef;
	}
	while(my @row_array = $sth->fetchrow_array){
		push(@ret,@row_array);
	}
	return @ret;
}
##################################################################################
sub get_identity {
  my $self = shift;
  my ($ret) = $self->execSELECT('SELECT @@IDENTITY');
  return $ret;
}

##################################################################################
sub quote {
	my $self = shift;
	my $str = shift;
	my $ch = shift;
	
	if ($ch){
		$str =~ s/'/$ch'/g;
		return $str;
	}

	return  $self->{DBH}->quote($str);
}

##################################################################################
sub procBeforeInsert {
	my ($self, @arr) = @_;
	
	my @ret = ();

	foreach my $f (@arr){
		if ( length($f) == 0 ){ # empty
			push @ret, 'NULL';
		}
		else {
			push @ret, $self->quote($f);
		}
	}

	return @ret;
}
##################################################################################
sub _printErrorHTML {
	my $str = shift;

	print "<br><p><FONT SIZE=\"3\" FACE=\"Courier\" COLOR=\"Red\"><center><b>$str</b></center></FONT></p><br>\n";
}
##################################################################################
sub _riseERROR {
	my $self = shift;
	my $str = shift;

	_printErrorHTML($str);

	$self->{DBH}->rollback();
	print STDERR $str;
}

1;

