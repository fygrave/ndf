package TNK::Router::CryptoIpsecSa;
##
## parse sh crypto ipsec sa command		svsoldatov october,7 2003
##

use Net::Telnet;


sub new {
	shift;
	$user = shift;
	$password = shift;
	$router = shift;
	$params = shift;
	$DEBUG = shift;

	print "USER='$user' PW='$password' R='$router' TELNET_PARAM='$params' DEBUG='$DEBUG'\n" if $DEBUG;
	
	my $self = {};
	unless($user){
		bless($self);
		return $self;
	}	
	
	my $t = Net::Telnet->new( %{$params} );
	$t->open($router);
	unless ($t->login($user,$password)) {
		print STDERR "".localtime(),": telnet ",$t->errmsg,"\n";
		return undef;
	}
	$t->cmd("terminal length 0"); # do not show --More--
	my @out = $t->cmd("sh crypto ipsec sa");
	$t->close;
	
	my ($interface, $conn) = (); 
	foreach my $row (@out){
		chomp $row;
		##print "row = '$row'\n" if $DEBUG;
		if($row =~ /^\s*interface:\s+(\S+)/){
			$interface = $1;
			##print "* * * * * $row\n" if $DEBUG;
			next;
		}
		elsif ($row =~ /^\s*Crypto\s+map\s+tag:\s+(.+)$/){
			$xxx = $1;
			$xxx =~ /([^,]+)\,/;
			$self->{$interface}->{Crypto_map_tag} = $1;
			##print "* * * * * $row\n" if $DEBUG;
			next;
		}
		elsif ($row =~ /^\s*local\s+ident\s+\(addr\/mask\/prot\/port\):\s+(\(.+\))/){
			$conn->{local_ident} = $1;
			##print "* * * * * $row\n" if $DEBUG;
			next;
		}
		elsif ($row =~ /^\s*remote\s+ident\s+\(addr\/mask\/prot\/port\):\s+(\(.+\))/){
			$conn->{remote_ident} = $1;
			##print "* * * * * $row\n" if $DEBUG;
			next;
		}
		elsif ($row =~ /^\s*local\s+crypto\s+endpt\.:\s+(\S+)\,\s*remote\s+crypto\s+endpt\.:\s+(\S+)/){
			$conn->{local_endpt} = $1;
			$conn->{remote_endpt} = $2;
			##print "* * * * * $row\n" if $DEBUG;
			next;
		}
		elsif ($row =~ /^\s*current\s+outbound\s+spi:\s+(\w+)/){
			$conn->{current_outbount_spi} = $1;
			##print "* * * * * $row\n" if $DEBUG;
			if ($conn->{current_outbount_spi} ne "0"){
				push @{$self->{$interface}->{CONNS}}, $conn;
			}
			undef $conn;
			next;
		}
	}

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
sub showHTML {
	my $self = shift;
	my $ret = '';
	
	$ret .= "<TABLE BORDER=\"1\" CELLSPACING=\"0\">\n".
		"<TR><TH ROWSPAN=\"2\">Interface<TH COLSPAN=\"4\">Connections</TR>\n".
		"<TR><TH>Local Ident<TH>Local Endpt<TH>Remote Ident<TH>Remote Endpt</TR>";
	
	foreach my $if (sort {$self->{$a}->{Crypto_map_tag} cmp $self->{$b}->{Crypto_map_tag}} keys %{$self}) {
		my $ii = 0;
		foreach my $i (sort {$a->{local_endpt} cmp $b->{local_endpt}} @{$self->{$if}->{CONNS}}) {
			if ($ii == 0){
				$ret .= "<TR><TD ROWSPAN=\"".scalar(@{$self->{$if}->{CONNS}}).
					"\"><b>$if</b><BR>".$self->{$if}->{Crypto_map_tag} 
			}
			else {
				 $ret .= "<TR>";
			}
			$ret .= "<TD>".$i->{local_ident}.
				"<TD>".$i->{local_endpt}.
				"<TD>".$i->{remote_ident}.
				"<TD>".$i->{remote_endpt}."</TR>\n";
			$ii++;
		}
	}
	$ret .= "</TABLE>\n";

	return $ret;
}
#################################################################################
sub showText {
	my $self = shift;
	my $ret = '';

	foreach my $if (sort {$self->{$a}->{Crypto_map_tag} cmp $self->{$b}->{Crypto_map_tag}} keys %{$self}) {
		foreach my $i (sort {$a->{local_endpt} cmp $b->{local_endpt}} @{$self->{$if}->{CONNS}}) {
			$ret .= $i->{local_ident}."\t".
				$i->{local_endpt}."\t".
				$i->{remote_ident}."\t".
				$i->{remote_endpt}."\t".
				$self->{$if}->{Crypto_map_tag}."\n";
		}
	}

	return $ret;
}
#################################################################################
sub getSelf {
	my $self = shift;
	
	return $self;
}
#################################################################################


1;
