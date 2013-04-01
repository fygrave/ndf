package TNK::LDAPUtils;
##
## LDAP Utils
##

use Net::LDAPS;
use Locale::Recode;
use DateTime::Format::Epoch::ActiveDirectory;

%AD_USERACCOUNTCONTROL = (
	SCRIPT => 1,
	ACCOUNTDISABLE => 2,
	LOCKOUT => 16,
	PASSWD_NOTREQD => 32,
	PASSWD_CANT_CHANGE => 64,
	NORMAL_ACCOUNT => 512,
	DONT_EXPIRE_PASSWORD => 65536,
	PASSWORD_EXPIRED => 8388608,
);

#############
# functions #
#############
# 

sub new {
  shift;
  my $server = shift;
  my $port = shift || 636;
  my $pwfile = shift;
  my $tobind = shift;
  my $inLDAP = shift;
  my $inIf = shift;

  my $self = {
	LDAP_SERVER  => $server,
	PORT => $port,
	PWFILE => $pwfile,
	BIND => $tobind,
  };
  
  if ($inLDAP){
  	$inIf = 'Windows-1251' unless $inIf;
  	my $cd = Locale::Recode->new(from => $inIf, to => $inLDAP);
	my $cd2 = Locale::Recode->new(to => $inIf, from => $inLDAP);
	$self->{CD} = $cd;
	$self->{CD2} = $cd2;
  }
  bless($self);

  return $self;
}

##################################################################################
sub search {
	my ($self,$base,$attrs,$filter) = @_;
	
	my $ldap = Net::LDAPS->new($self->{LDAP_SERVER},
		port => $self->{PORT},
	) or die "new LDAP obj: $@";

	my $pw = __get_adpw($self->{PWFILE});
	
	my $mesg = $ldap->bind($self->{BIND}, password => $pw );
	$mesg->code && die $mesg->code.": ".$mesg->error;

	$mesg = $ldap->search(
		base => $base,
		attrs => $attrs,
		filter => $filter
	);

	return $mesg;
}

sub getCD {
	my $self = shift;
	return $self->{CD};
}
sub getCD2 {
	my $self = shift;
	return $self->{CD2};
}

sub recodeADEntry {
	my ($self,$entry,$attrs) = @_;
	return undef unless defined $entry;
	
	foreach my $att (@{$attrs}){
		for (my $i=0; $i<@{$entry->get_value($att,asref => 1)}; $i++){
			$self->{CD2}->recode($entry->get_value($att,asref => 1)->[$i]);
		}
	}
}

sub getADAccountExpires {
	##
	## Requires accountExpires as search attr!!!
	##
	my ($self,$entry) = @_;
	return undef unless defined $entry;

	my ($accountExpires_AD) = $entry->get_value("accountExpires");
	if ($accountExpires_AD > 0){
		my $dt = DateTime::Format::Epoch::ActiveDirectory->parse_datetime($accountExpires_AD);
		
		return $dt;
	}
	else {
		return undef;
	}
}

sub parseUserAccountControl {
	##
	## Requires userAccountControl as search attr!!!
	##
	my ($self,$entry) = @_;
	return undef unless defined $entry;
	
	my $ret = {};
	my ($userAccountControl_AD) = @{$entry->get_value("userAccountControl",asref => 1)};

	foreach my $param (keys %AD_USERACCOUNTCONTROL) {
		##print "<P>Check $param:".$AD_USERACCOUNTCONTROL{$param}." against $userAccountControl_AD: ".($AD_USERACCOUNTCONTROL{$param} & $userAccountControl_AD)."</P>\n"; ##DEBUG
		if ( ($AD_USERACCOUNTCONTROL{$param} & $userAccountControl_AD) == $AD_USERACCOUNTCONTROL{$param} ){
			##print "<P>Ï Î Ï À Ë Ñ ß!!!</P>\n"; ##DEBUG
			$ret->{$param} = 1;
		}
	}

	return $ret;
}

sub __get_adpw {
	my $file = shift;

	do $file || die "do $file: $!";

	return $connect::data::pad;
}

sub __debug {
	my $self = shift;
	my $msg = shift;

	print "\n<p>",$msg,"</p>\n";
}

1;

