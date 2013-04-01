package TNK::Server;
##
## Server Object		svsoldatov april, 2003
##

use TNK::DBAccess;
##use TNK::User;

%DICTIONARY = (
	ID => "srv_id",
	NAME => "serverName",
	IP => "IP",
	DNS => "DNS",
	HARDWARE => "hardware",
	OS => "OS",
	OWNER => "owner",
	SERVICES => "services",
	INFO => "information",
	ADMIN_AC => "adminAccounts",
	MAC => "MAC",
	SWITCH => "switch",
	PORT => "port",
	COMMENT => "Comment",
);

sub new {
	shift;
	my $db = shift;   #database handler
	my $info = shift; #any information (IP or MAC)
	my $what = shift; #what kind of information
	return undef unless ($info && $what);
	
	my $field;
	if ($what =~ /^IP$/) {
		$field = 'IP';
	}
	elsif($what =~ /^MAC$/){
		$field = 'MAC';
	}
	elsif($what =~ /^ID$/){
		$field = 'Srv_ID';
	}
	else {
		return undef;
	}
	
	my ($srv_id, $server_name, $ip, $dns, $hardware, $os, $owner, $services, $information, $admin_accounts, $mac, $switch, $port, $comment) = 
		$db->execSELECT("SELECT srv_id, serverName, IP, DNS, hardware, OS, owner, services, information, adminAccounts, MAC, switch, port, Comment ".
			"FROM SERVERS WHERE $field = '$info'");

	return undef unless ($ip);

	($srv_id, $server_name, $ip, $dns, $hardware, $os, $owner, $services, $information, $admin_accounts, $mac, $switch, $port,$comment) = 
		_del_spaces($srv_id, $server_name, $ip, $dns, $hardware, $os, $owner, $services, $information, $admin_accounts, $mac, $switch, $port, $comment);
	
	# get admins
##	my @admins = ();
##	my @adm = $db->execSELECT("SELECT u.userName FROM USERS u, ServerAdmins sa ". 
##		" WHERE sa.srv_id = $srv_id AND sa.userid = u.p_id");
##	for my $aaa (@adm) {
##		##print "adm: $aaa\n";
##		if ($aaa) {
##			my $user = new TNK::User($db, $aaa, 'LOGIN');
##			push @admins, $user->getSelf();
##		}
##	}

	my $self = {
		ID			=> $srv_id,
		NAME			=> $server_name,
		IP			=> $ip,
		DNS			=> $dns,
		HARDWARE		=> $hardware,
		OS			=> $os,
		OWNER			=> $owner,
		SERVICES		=> $services,
		INFO			=> $information,
##		ADMIN_AC		=> $server_name,
		ADMIN_AC		=> $admin_accounts,
		MAC			=> $mac,
		SWITCH			=> $switch,
		PORT			=> $port,
		COMMENT 		=> $comment,
##		ADMINS			=> \@admins,
		CONSTRUCTED_BY	=> "$info ($what)",
	};
	
	bless($self);

	return $self;
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
sub getField{
	my $self = shift;
	my $f = shift;
	$f = uc $f;

	return $self->{$f};
}
#################################################################################
sub print {
	my $self = shift;
	for (keys %{$self}) {
		##if ($_ eq 'ADMINS') {
		##	printf("%15s:\n", 'ADMINS');
		##	for my $adm (@{$self->{ADMINS}}) {
		##		my $user = TNK::User->build($adm);
		##		if ($user->getField('FIO')) {
		##			$user->print();
		##		}
		##	}
		##}
		##else {
			printf("%15s: %s\n", $_, $self->{$_});
		##}
	}
	print "****************\n";
}
#################################################################################
sub getSelf {
	my $self = shift;
	return $self;
}
#################################################################################
sub _del_spaces {
	my @ret = ();
	for my $i (@_) {
		$i =~ s/^\s*//;
		$i =~ s/\s*$//;
		push @ret, $i;
	}
	return @ret;
}


1;

