package TNK::Switch::Switch;
##
## Uses Switches.conf ($TNK::Defs::SWITCHES_CONF)!!! 
## 

# If you're going to use this module somethere in program, you don't need to
# require $TNK::Defs::SWITCHES_CONF;
# You can access all variables (%SWITCHES %ROUTERS %SSH_PARAMS_DEFAULT @DESIRED_ROUTERS_LOCAL $SWITCHESZONE)
# from program specifing fully-qualified namespace name, i.e. $SWITCHES you can access as
# %TNK::Switch::Switch::SWITCHES
# !!! Do not require $TNK::Defs::SWITCHES_CONF in program !!!
# This will not work, because " require() reads a file containing Perl code and compiles it. 
# Before attempting to load the file, it looks up the argument in %INC to see whether it has 
# already been loaded. If it has, then require() just returns without doing a thing. 
# Otherwise, an attempt will be made to load and compile the file. "
# See http://www.perl.com/pub/a/2002/05/14/mod_perl.html?page=3 
# for references


use TNK::Defs;
require $TNK::Defs::SWITCHES_CONF;
use vars qw(%SWITCHES %ROUTERS %SSH_PARAMS_DEFAULT @DESIRED_ROUTERS_LOCAL $SWITCHESZONE);

use Net::Telnet;
use Net::SSH::Perl;

##
## Switch operation
## 22.12.2003 svsoldatov
##

sub new{
	shift;
	my $sw = shift;
	my $DEBUG = shift;

	my $self = {
		SWITCH => $sw,
		DEBUG => $DEBUG,
		CON => undef,
		INF => undef,
	};

	bless($self);
	return $self;
}

sub connect2switch {
	my $self = shift;
	my $switch = shift;
	my $DEBUG = $self->{DEBUG};

	$switch = $self->{SWITCH} unless $switch;
	return (undef, undef) unless $switch;
	
	my $password_file = $TNK::Defs::SC_ETC.'/connect/auto';
	open(IN, "<$password_file") || die "cannot open $password_file: $!\n";
	my $pass = <IN>;
	close IN;
	chomp $pass;
	my $user = 'auto';
	##print "(user,pass) = ($user,$pass)\n";

	my $con;
	my $inf;
	
	print "In TNK::Switch::Switch::connect2switch: connecting to '$switch' ... \n" if $DEBUG;
	print "Switches: ".(join "\n", (sort keys %SWITCHES)).
		"\n==========\n'$switch'->CON = ".
		$SWITCHES{$switch}->{CON}."\n\n" if $DEBUG;

	if ($SWITCHES{$switch}->{CON} =~ /^telnet$/i){
		print "Connectiong to $switch via telnet...\n" if $DEBUG;
		$con =  Net::Telnet->new(%{$SWITCHES{$switch}->{'PARAMS'}});
		$con->open($switch) or  $self->{ERROR} .= join("$!\n",$@);
		$con->login($user,$pass) or $self->{ERROR} .= join("$!\n",$@);
		$con->errmode(
			sub {
				print STDERR "Switch='$host' ERROR: @_\n";
			}
		);
		$con->cmd($SWITCHES{$switch}->{'TERM_LENGTH'});
		$inf = 'telnet';
	}
	elsif ($SWITCHES{$switch}->{CON} =~ /^ssh$/i) {
		print "Connectiong to $switch via ssh...\n" if $DEBUG;
		my %params = ();
		if($SWITCHES{$switch}->{'PARAMS'}){
			%params = %{$SWITCHES{$host}->{'PARAMS'}};
		}
		else {
			%params = %SSH_PARAMS_DEFAULT;
		}
		$con = Net::SSH::Perl->new($switch, %params);
		$con->login($user, $pass);
		$con->cmd($SWITCHES{$switch}->{'TERM_LENGTH'});
		$inf = 'ssh';
	}

	$self->{CON} = $con;
	$self->{INF} = $inf;
	
	print "Done connect2switch: ($con,$inf)\n" if $DEBUG;

	return ($con,$inf);
}


sub cmdArray {
	my $self = shift;
	my $cmd = shift;
	
	my @ret = ();
	if($self->{INF} eq 'ssh'){
		my($stdout, $stderr, $exit) = $self->{CON}->cmd($cmd);
		@ret = split /\n/, $stdout;
	}
	elsif($self->{INF} eq 'telnet'){
		@ret = $self->{CON}->cmd($cmd);
	}

	return @ret;
}

sub cmdScalar {
	my $self = shift;
	my $cmd = shift;

	my $ret = '';
	if($self->{INF} eq 'ssh'){
		my($stdout, $stderr, $exit) = $self->{CON}->cmd($cmd);
		$ret = $stdout;
	}
	elsif($self->{INF} eq 'telnet'){
		my @ttt = $self->{CON}->cmd($cmd);
		$ret = join '', @ttt;
	}

	return $ret;
}

1;


