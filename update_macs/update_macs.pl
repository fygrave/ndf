#!/usr/bin/perl
# svsoldatov 04.12.2003
# Fill MACs information

## Exit codes
## 0 - all is OK
## 10 - PID-file found
##

#use lib "/perllib";
use TNK::Defs;

# This is not needed, see comments in TNK::Switch::Switch
##require $TNK::Defs::SWITCHES_CONF;
##use vars qw(%SWITCHES, %ROUTERS, %SSH_PARAMS_DEFAULT, @DESIRED_ROUTERS_LOCAL);

use Getopt::Std;
use TNK::DBAccess;
use TNK::Switch::Switch;
use Net::Ping;
use TNK::Utils;
use POSIX ":sys_wait_h";


#Configs..
$SERVER = 'SERVERNAME:3544';
##$ODBCDSN = 'MSSQLBBKSSdsn';
$USER = 'svs';
$CHANGES_LOG = $TNK::Defs::SC_VAR.'/update_macs/changes.log';
$PIDFILE = $TNK::Defs::SC_VAR.'/update_macs/update_macs.pl.pid';
$STATIC_PORTS_DIR = $TNK::Defs::SC_VAR.'/update_macs/static-ports';
$SPAN_PORTS_DIR = $TNK::Defs::SC_VAR.'/update_macs/SPAN';

$IP_LOG_DIR = $TNK::Defs::SC_VAR.'/update_macs/IP-WO-LOGIN'; # log here IP without logins

$STATIC_PORTS_CMD = 'sh port status | exc dyn';
$MAIL = "/usr/bin/mail -s 'update_macs.pl (diff prev last): SPAN conf changed' ";
$CAT = '/bin/cat';
$DIFF = '/usr/bin/diff --ignore-blank-lines';
$GZIP = '/bin/gzip --best';
$MV = '/bin/mv';
$LAST_LOG = $TNK::Defs::SC_VAR."/update_macs/last.$$.log";
$LAST_LOG_PR = $TNK::Defs::SC_VAR."/update_macs/last.$$.work";

$MAX_IDLE_TIMEOUT = 3600; #sec



# Options
getopts("DhIUP");
$DEBUG = 0;
$DEBUG = 1 if $opt_D;
if ($opt_h) {
	_usage();
	exit 0;
}

# delete old last.$$.log and delete old last.err.log
delete_old_logs();

# check if it's not running
unless ($opt_P){
	if (-f $PIDFILE) {
		open PIDF, "<$PIDFILE" || die "Can't read $PIDFILE: $!\n";
		my $pid = <PIDF>; chomp $pid;
		my $created = <PIDF>; chomp $created;
		close PIDF;
		my $now = time();
		$now -= $created;
		if ($now < $MAX_IDLE_TIMEOUT){
			print "$0 is sunning: PID=$pid, started ".localtime($created)."\n" if $DEBUG;
			exit(10);
		}
	}

	open PIDF, ">$PIDFILE" || die "Can't write $PIDFILE: $!\n";
	print PIDF $$, "\n";
	print PIDF ''.time(), "\n";
	close PIDF;
}

my $utils = new TNK::Utils();

my $password_file = $TNK::Defs::SC_ETC.'/connect/auto';
open(IN, "<$password_file") || die "cannot open $password_file: $!\n";
my $pass = <IN>;
close IN;
chomp $pass;
my $user = 'auto';
@DESIRED_ROUTERS = @TNK::Switch::Switch::DESIRED_ROUTERS_LOCAL;

# flush print buffer as soon as possible
$| = 1;

my $timedelta = time();

##print "SWITCHES, DESIRED_ROUTERS\n";		##DEBUG
##foreach (keys %TNK::Switch::Switch::SWITCHES, 
##	@DESIRED_ROUTERS) { 	##DEBUG
##	print "$_\n";				##DEBUG
##}						##DEBUG
##print "==========================\n"; 	##DEBUG
##exit(0);					##DEBUG


## routers
%ARP = ();
foreach my $router (@DESIRED_ROUTERS){
	my $t_router = Net::Telnet->new(%{$TNK::Switch::Switch::ROUTERS{$router}->{'PARAMS'}});
	
	print "$$: going to connect to $router!\n" if $DEBUG;
	$t_router->open($router);
	$t_router->login($user,$pass) || die "".localtime().": telnet ".$t_router->errmsg."\n";
	$t_router->errmode(
		sub {
			print STDERR "Router='$router' ERROR: @_\n" if @_;
		}
	);
	print "$$: connected to $router!\n" if $DEBUG;
	
	$t_router->cmd($TNK::Switch::Switch::ROUTERS{$router}->{TERM_LENGTH});
	print "$$: Done ".$TNK::Switch::Switch::ROUTERS{$router}->{TERM_LENGTH}."\n" if $DEBUG;
	
	my @router_rows = ();
	push @router_rows, ($t_router->cmd($TNK::Switch::Switch::ROUTERS{$router}->{SH_ARP}));
	##print "$$: Done ".$TNK::Switch::Switch::ROUTERS{$router}->{SH_ARP}."\n" if $DEBUG;
	push @router_rows, ($t_router->cmd($TNK::Switch::Switch::ROUTERS{$router}->{SH_ARP2})) if $TNK::Switch::Switch::ROUTERS{$router}->{SH_ARP2};
	##print "$$: Done ".$TNK::Switch::Switch::ROUTERS{$router}->{SH_ARP2}."\n" if $DEBUG;
	
	foreach my $row (@router_rows) {
		##print $TNK::Switch::Switch::ROUTERS{$router}->{SH_ARP_TEMPL}."\n"; ##DEBUG
		if ($row =~ /$TNK::Switch::Switch::ROUTERS{$router}->{SH_ARP_TEMPL}/){
			my ($ip,$mac,$age) = ($1,uc($3),$2);
			unless ($ARP{$mac}->{AGE}){
				$ARP{$mac}->{IP} = $ip;
				$ARP{$mac}->{AGE} = $age;
				##print "$router $$ : $ip \t $mac \t $age \n" if $DEBUG;
			}
			else {
				if($ARP{$mac}->{AGE} > $age){
					$ARP{$mac}->{IP} = $ip;
					$ARP{$mac}->{AGE} = $age;
					##print "$router $$ : $ip \t $mac \t $age \n" if $DEBUG;
				}
			}
		}
	}
	writeLastLog("Router $router\t\t\t\t...OK\n");
}
#for my $mac (keys %ARP) {						##DEBUG
#	print "$mac\t".$ARP{$mac}->{IP}."\t".$ARP{$mac}->{AGE}."\n";	##DEBUG
#}									##DEBUG
#exit 0;								##DEBUG



my $ping = Net::Ping->new("icmp");

if (-f "$IP_LOG_DIR/ip_wo_login.txt"){
	my @st = stat "$IP_LOG_DIR/ip_wo_login.txt";
	if ( $st[7] > 1000000 ) {
		rename "$IP_LOG_DIR/ip_wo_login.txt", "$IP_LOG_DIR/ip_wo_login.txt.old";
	}
}

open IP_WO_LOGIN, ">>$IP_LOG_DIR/ip_wo_login.txt" || die "cannot open $IP_LOG_DIR/ip_wo_login.txt : $!\n";

my $pid;
$SIG{CHLD} = \&child_handler;
@CHILDREN  = ();

## Switches
foreach my $host (sort keys %TNK::Switch::Switch::SWITCHES){
	if ($pid = fork()){
		# papa
		push @CHILDREN, $pid;
	}
	else {
	# child
	die "cannot fork: $!\n" unless defined $pid;

	##exit(0); ##DEBUG
	# connect to DB
	my $d = new TNK::DBAccess();
	$d->connect2MSSQL($SERVER, $USER,  $TNK::Defs::SC_ETC.'/connect/security_svs');
	
	
	if(!$ping->ping($host)){
		print STDERR "error to connect to '$host': ping was not passed\n";
		goto DONE_SWITCH;
	}
	my @ret_gm = ();
	my @trunk = ();
	my @span = ();
	##my $st_cmd = $STATIC_PORTS_CMD; # static ports
	##my @static_ports = ();          # static ports
	
	my $sw = new TNK::Switch::Switch();
	eval { $sw->connect2switch($host) };  # if any problems were occured
	if ($@) {
		print STDERR "error to connect to '$host': $@\n";
		goto DONE_SWITCH;
	}
	print "$$: connected to $host\n" if $DEBUG;

	$sw->cmdArray($TNK::Switch::Switch::SWITCHES{$host}->{'TERM_LENGTH'});
	print "$$: done ".$TNK::Switch::Switch::SWITCHES{$host}->{'TERM_LENGTH'}."\n" if $DEBUG;
	
	@ret_gm = $sw->cmdArray($TNK::Switch::Switch::SWITCHES{$host}->{'SH_MAC'});
	##print "done ".$TNK::Switch::Switch::SWITCHES{$host}->{'SH_MAC'}."\n @ret_gm\n=========\n"; ##DEBUG

	if ($TNK::Switch::Switch::SWITCHES{$host}->{TYPE} eq 'AP1220-IOS') {
		@trunk = ();
		@span = ();
	}
	else {
		@trunk = $sw->cmdArray($TNK::Switch::Switch::SWITCHES{$host}->{'SH_TRUNK'});
		##print "done ".$TNK::Switch::Switch::SWITCHES{$host}->{'SH_TRUNK'}."\n @trunk\n=========\n"; ##DEBUG
		if ($TNK::Switch::Switch::SWITCHES{$host}->{'SH_SPAN'}){
			@span = $sw->cmdArray($TNK::Switch::Switch::SWITCHES{$host}->{'SH_SPAN'});  # SPAN ports
			##print "done ".$TNK::Switch::Switch::SWITCHES{$host}->{'SH_SPAN'}." @span\n=========\n"; ##DEBUG
		}
	}

	#
	# SPAN ports
	#
	my $SPANmsg = '';
	my $span_var = join '',@span;
	if ( !grep {$span_var =~ /$_/} ('\s+dot1q\s+trunking\s+') ) {
		foreach my $rr (@span) {
			next if $rr =~ /$TNK::Switch::Switch::SWITCHES{$host}->{'SH_SPAN'}/;
			if ($TNK::Switch::Switch::SWITCHES{$host}->{'SH_SPAN_TEMPL'}){
				if ($rr =~ /$TNK::Switch::Switch::SWITCHES{$host}->{'SH_SPAN_TEMPL'}/){
					$SPANmsg .= "$host: $rr";
				}
			}
			elsif ($TNK::Switch::Switch::SWITCHES{$host}->{'NOT_SH_SPAN_TEMPL'}){
				if ($rr !~ /$TNK::Switch::Switch::SWITCHES{$host}->{'NOT_SH_SPAN_TEMPL'}/){
					$SPANmsg .= "$host: $rr";
				}
			}
		}
	}
	if ($SPANmsg) {
		open TTTSPAN, ">$SPAN_PORTS_DIR/$host.last.txt" || die "open for write $SPAN_PORTS_DIR/$host.last.txt: $!\n"; # SPAN ports
		print TTTSPAN $SPANmsg;
		close TTTSPAN;

		if (-f "$SPAN_PORTS_DIR/$host.prev.txt") {
			my $diff_res = `$DIFF $SPAN_PORTS_DIR/$host.prev.txt $SPAN_PORTS_DIR/$host.last.txt > $SPAN_PORTS_DIR/$host.diff.txt`;
			my @st = stat "$SPAN_PORTS_DIR/$host.diff.txt";
			if ($st[7] == 0){ #size
				unlink "$SPAN_PORTS_DIR/$host.diff.txt";
			}
		}
		else {
			open SPANDIFF, ">$SPAN_PORTS_DIR/$host.diff.txt" || die "open for write $SPAN_PORTS_DIR/$host.diff.txt:$!\n";
			print SPANDIFF "$host: No SPAN port information before now\n" ;
			close SPANDIFF;
		}
		rename "$SPAN_PORTS_DIR/$host.last.txt", "$SPAN_PORTS_DIR/$host.prev.txt";
	}
	##

	#
	# static ports 
	#
	##open TTT, ">$STATIC_PORTS_DIR/$host" || die "open $STATIC_PORTS_DIR/$host: $!\n";
	##print TTT @static_ports;
	##close TTT;
	##

	# to control errors
	my $total_macs_from_switch = 0;
	
	foreach my $row (@ret_gm){
		if($row =~ /$TNK::Switch::Switch::SWITCHES{$host}->{SH_MAC_TEMPL}/){
			my ($mac_n, $vlan_n, $port_n, $port_pref_n ) = ();
			my ($mac, $vlan, $port, $ip) = ();
			
			if ($TNK::Switch::Switch::SWITCHES{$host}->{TYPE} eq 'AP1220-IOS'){
				# MAC Address    IP address      Device        Name            Parent         State
				# 000c.f11d.ec12 10.4.179.40        -           -               self           EAP-Assoc
				($mac, $ip, $port) = ($1, $2, 'undefined for AP');
				if ($ip =~ /10\.4\.185\./){ # no switch in Perl :-(
					$vlan = 29;
				}
				elsif ($ip =~ /10\.4\.178\./){
					$vlan = 40;
				}
				elsif ($ip =~ /10\.4\.179\./){
					$vlan = 35;
				}
				elsif ($ip =~ /10\.4\.220\./){
					$vlan = 553;
				}
				else {
					$vlan = -1;
				}
			}
			else {
				($mac_n, $vlan_n, $port_n, $port_pref_n ) = @{$TNK::Switch::Switch::SWITCHES{$host}->{MAC_VLAN_PORT_ORDER}};
				($mac, $vlan, $port, $ip) = ($$mac_n, $$vlan_n, $$port_pref_n.$$port_n,'');
			
				#search if trunk
				my $trunk_templ = $TNK::Switch::Switch::SWITCHES{$host}->{SH_TRUNK_TEMPL};
				$trunk_templ  =~ s/PORT/$port/;
				#print "$trunk_templ\n";
				foreach my $trunk_row (@trunk){
					if ($trunk_row =~ /$trunk_templ/){
						##print "port $port is trunking...\n";
						goto DONE_SW_ROW;
					}
				}
			
				# find ip from router
				my $mac_dot = uc $utils->mac_dotted($mac);
				$ip = $ARP{$mac_dot}->{IP};
			}

			# find AD login
			my ($userName) = $d->execSELECT("SELECT TOP 1 UserName FROM LOGONACTIVITY2 (nolock) WHERE SourceNetworkAddress = '$ip' AND TimeGenerated > (getdate()-1) order by TimeGenerated desc");
			##$odbc->{SEL_LOGIN}->{S}->execute($ip); ##ODBC
			##my ($userName) = $odbc->{SEL_LOGIN}->{S}->fetchrow_array(); ##ODBC
			##

			$mac = $utils->mac_dashed(uc $mac);
			$userName = uc $userName; $userName =~ s/^\s+//; $userName =~ s/\s+$//;
			$ip =~ s/^\s+//; $ip =~ s/\s+$//;

			if ( !$userName && $ip && !grep {$ip =~ /$_/} (
					'10\.4\.6[4-8]\.', 
					'10\.4\.19[0123]\.', 
					'10\.4\.189\.', 
					'10\.4\.10[34]\.', 
					'10\.4\.182\.', 
					'10\.4\.8[13459]\.', 
					'10\.4\.76\.') 
				) {
				print IP_WO_LOGIN "$ip \t $mac \t $host \t $port \n";
			}

			print "$$: row='$row'\n\t$$:  VLAN='$vlan'\tMAC='$mac'\tIP='$ip'\tPORT='$port'\tSwitch='$host'\tuserName='$userName'\n" if $DEBUG;
			##goto DONE_SW_ROW; ##DEBUG

			my ($id,$ip_o,$switch_o,$port_o,$vlan_o,$firstseen_o,$lastseen_o,$deleted_o,$userName_o) = 
				$d->execSELECT("SELECT id,ip,switch,port,vlan,convert(varchar(50),firstseen,20),convert(varchar(50),lastseen,20),deleted,UserName FROM MACS WHERE mac='$mac'") ;
			map {$_ =~ s/^\s+//; $_ =~ s/\s+$//} ($ip_o,$switch_o,$port_o,$vlan_o,$userName_o);

			##$odbc->{SEL_MAC}->{S}->execute($mac); ##ODBC
			##my ($id,$ip_o,$switch_o,$port_o,$vlan_o,$firstseen_o,$lastseen_o,$deleted_o,$userName_o) = $odbc->{SEL_MAC}->{S}->fetchrow_array(); ##ODBC
			
			print "$$: Old for $mac: $id,$ip_o,$switch_o,$port_o,$vlan_o,$firstseen_o,$lastseen_o,$deleted_o,$userName_o\n" if $DEBUG;
			
			my ($ip_o_p,$switch_o_p,$port_o_p,$vlan_o_p,$firstseen_o_p,$lastseen_o_p,$userName_o_p,$ip_p,$host_p,$vlan_p,$userName_p,$port_p) = 
			$d->procBeforeInsert($ip_o,$switch_o,$port_o,$vlan_o,$firstseen_o,$lastseen_o,$userName_o,$ip,$host,$vlan,$userName,$port);
			if ($id) { ##already in DB (update)
				my $flag = 0;
				my $query = "UPDATE MACS SET lastseen=getdate() WHERE id=$id";
				##print "$query\n"; ##DEBUG
				$d->execDO($query) unless $opt_U;
				$ip =~ s/\s*//g;
				$ip_o =~ s/\s*//g;
				unless ("x$ip_o" eq "x$ip"){
					my $query = "UPDATE MACS SET ip = $ip_p WHERE id=$id ";
					##print "$query\n"; ##DEBUG
					$d->execDO($query) unless $opt_U;
					$flag++;
					print "$$: IP: '$ip_o' !eq '$ip' => $flag\n" if $DEBUG;
				}
				unless ("x$userName_o" eq "x$userName"){
					my $query = "UPDATE MACS SET userName=$userName_p WHERE id=$id";
					##print "$query\n"; ##DEBUG
					$d->execDO($query) unless $opt_U;
					$flag++;
					print "$$: USERNAME: '$userName_o' !eq '$userName' => $flag\n" if $DEBUG; 
				}
				unless ($switch_o eq $host){
					my $query = "UPDATE MACS SET switch=$host_p WHERE id=$id";
					##print "$query\n"; ##DEBUG
					$d->execDO($query) unless $opt_U;
					$flag++;
					print "$$: $switch_o !eq $host => $flag\n" if $DEBUG;
				}
				unless ($port_o eq $port){
					my $query = "UPDATE MACS SET port=$port_p WHERE id=$id";
					##print "$query\n"; ##DEBUG
					$d->execDO($query) unless $opt_U;
					$flag++;
					print "$$: $port_o !eq $port => $flag\n" if $DEBUG; 
				}
				unless ($vlan_o == $vlan){
					my $query = "UPDATE MACS SET vlan=$vlan_p WHERE id=$id";
					##print "$query\n"; ##DEBUG
					$d->execDO($query) unless $opt_U;
					$flag++;
					print "$$: $vlan_o !eq $vlan => $flag\n" if $DEBUG; 
				}
				if($deleted_o == 1){
					my $query = "UPDATE MACS SET deleted=0 WHERE id=$id";
					##print "$query\n"; ##DEBUG
					$d->execDO($query) unless $opt_U;
					writeLog("".localtime()."  Changed parameter:'deleted' to:1 for MAC:'$mac'\n");
				}
				if ($flag > 0) { # something has changed
					my $query = "INSERT INTO MACS_HISTORY(userName,ip,mac,switch,port,vlan,firstseen,lastseen) VALUES ($userName_o_p,$ip_o_p,'$mac',$switch_o_p,$port_o_p,$vlan_o_p,$firstseen_o_p,$lastseen_o_p) ";
					print "$$: HISTORY: $query\n" if $DEBUG; 
					$d->execDO($query) unless $opt_I;
					$d->execDO("UPDATE MACS SET firstseen=getdate() WHERE id=$id") unless $opt_U;
					writeLog("".localtime()."  MAC changed: MAC:'$mac' new_ip:'$ip' new_switch:'$host' new_port:'$port' new_VLAN:'$vlan' old_ip:'$ip_o' old_switch:'$switch_o' old_port:'$port_o' old_VLAN:'$vlan_o'\n");
					
					#
					# check if location changed
					#
					$TNK::Switch::Switch::SWITCHES{$host}->{LOCATION} =~ /^([^:]+):/;
					my $new_location = $1;
					$TNK::Switch::Switch::SWITCHES{$switch_o}->{LOCATION} =~ /^([^:]+):/;
					my $old_location = $1;
					if ($new_location ne $old_location){
						 writeLog("".localtime()." MAC location changed: Info:'$old_location -> $new_location' MAC:'$mac' new_switch:'$host' new_port:'$port' new_VLAN:'$vlan' old_switch:'$switch_o' old_port:'$port_o' old_VLAN:'$vlan_o' IP:'$ip'\n");
					}
				}
			}
			else {  ## new MAC (insert)
				my $query = "INSERT INTO MACS(mac,ip,switch,port,vlan,firstseen,lastseen,deleted)  VALUES ('$mac',$ip_p,$host_p,$port_p,$vlan_p,getdate(),getdate(),0)";
				print "$$: $query\n" if $DEBUG; 
				$d->execDO($query) unless $opt_I;
				writeLog("".localtime()."  New MAC found:'$mac' switch:'$host' port:'$port' VLAN:'$vlan' IP:'$ip'\n");
			}

			$total_macs_from_switch++;
		}
		DONE_SW_ROW:
	}
	writeLastLog("".localtime()." Switch $host\t\t\t\t ...OK!\n");
	# no matching macs on switch
	if ($total_macs_from_switch == 0 && !(grep {$host =~ /$_/} ('^ap1230-') )){
		print STDERR "".localtime()." Switch $host: no matching macs, SH_MAC_TEMPL='".$TNK::Switch::Switch::SWITCHES{$host}->{SH_MAC_TEMPL}."', MAC_VLAN_PORT_ORDER=[".join(',',@{$TNK::Switch::Switch::SWITCHES{$host}->{MAC_VLAN_PORT_ORDER}})."], SH_TRUNK_TEMPL='".$TNK::Switch::Switch::SWITCHES{$host}->{SH_TRUNK_TEMPL}."\n";
	}
	DONE_SWITCH:
	
	
	$d->disconnect();
	
	exit(0);
	} #child done...
}

close IP_WO_LOGIN;

# papa
# wait for children to finish
my $ttt;
do {
	sleep; #sleep untill signal
	$ttt = scalar(@CHILDREN);
	print "papa $$: CHILDREN: $ttt\n" if $DEBUG; 
}
while ($ttt > 0);
###

$ping->close();

# SPAN ports diff collection
my @tm = localtime();
$tm[5] += 1900;
$tm[4] += 1;
my $suffix = $tm[5].sprintf("%02d",$tm[4]).sprintf("%02d",$tm[3]).sprintf("%02d",$tm[2]).sprintf("%02d",$tm[1]).sprintf("%02d",$tm[0]);
foreach my $f (glob("$SPAN_PORTS_DIR/*.diff.txt")){
	`$CAT $f >>$SPAN_PORTS_DIR/diff.$suffix.txt`;
	unlink $f;
}
open DIFFREZ, "<$SPAN_PORTS_DIR/diff.$suffix.txt" || die "open for read $SPAN_PORTS_DIR/diff.$suffix.txt: $!\n";
open DIFFREZ2, ">$SPAN_PORTS_DIR/diff.$suffix.win.txt" || die "open for read $SPAN_PORTS_DIR/diff.$suffix.win.txt: $!\n";
my $file_data = '';
while (<DIFFREZ>){
	$file_data .= $_; # collect $SPAN_PORTS_DIR/diff.$suffix.txt to one var
	s/\n/\r\n/;
	print DIFFREZ2 $_;
	
}
close DIFFREZ;
close DIFFREZ2;

if ($file_data !~ /\w+/){ #check if empty
	unlink "$SPAN_PORTS_DIR/diff.$suffix.txt", "$SPAN_PORTS_DIR/diff.$suffix.win.txt";
}
else {
	`$CAT $SPAN_PORTS_DIR/diff.$suffix.win.txt | $MAIL svsoldatov\@yourdomaoin.com`;
	`$GZIP $SPAN_PORTS_DIR/diff.$suffix.txt`;
	`$GZIP $SPAN_PORTS_DIR/diff.$suffix.win.txt`;
	`$MV $SPAN_PORTS_DIR/*.gz $SPAN_PORTS_DIR/LOGS/`;
}
###


$timedelta = time() - $timedelta;

writeLastLog("Congratulations! Completed in $timedelta seconds \n");

rename $LAST_LOG_PR, $LAST_LOG || die "Cannot rename $LAST_LOG_PR --> $LAST_LOG: $!\n";

unlink $PIDFILE unless $opt_P;


##undef $odbc->{SEL_LOGIN}->{S}; ##ODBC
##$odbc->{SEL_LOGIN}->{D}->disconnect if $odbc->{SEL_LOGIN}->{D};##ODBC
##
##undef $odbc->{SEL_MAC}->{S};##ODBC
##$odbc->{SEL_MAC}->{D}->disconnect if $odbc->{SEL_MAC}->{D};##ODBC


###########################################################
sub writeLastLog {
	my $m = shift;

	open LASTLOG, ">>$LAST_LOG_PR" || die "Can't open $LAST_LOG_PR : $!\n";
	print LASTLOG $m;
	close LASTLOG;
}
sub writeLog {
	my $m = shift;

	open LOG, ">>$CHANGES_LOG" or die "opening $CHANGES_LOG: $!\n";
	print LOG $m;
	close LOG;
}
###########################################################
sub child_handler {
        my $stiff;
	
	while($stiff = waitpid(-1, WNOHANG) > 0) {
		##print "Done $stiff...\n";
		pop @CHILDREN;
	}
	$SIG{CHILD} = \&child_handler;
}

###########################################################
sub delete_old_logs() {
	my @files = glob $TNK::Defs::SC_VAR."/update_macs/last.*.*";
	my $timeout = 86400; #one day in secs
	
	foreach my $f (@files){
		my @st = stat $f;
		my $size = $st[7]; # total size of file, in bytes
		my $mtime = $st[9]; #last modify time in seconds since the epoch
		my $now = time();
		my $now_str = "".localtime($now);
		my $mtime_str = "".localtime($mtime);
		
		if ($now-$mtime > 2*$timeout and $f =~ /last\.\d+\.work$/){
			`/usr/bin/logger -p user.info -t update_macs.pl $now_str Log file $f was deleted, size=0`;
			unlink $f;
			next;
		}
		
		if($now-$mtime > $timeout){
			`/usr/bin/logger -p user.info -t update_macs.pl $now_str Log file $f was deleted, mtime=$mtime_str`;
			unlink $f;
		}
	}
}
###########################################################
sub _usage {
print <<END_MLT;
usage: update_macs.pl <options>
	-D - switch DEBUG output on
	-I - do not insert MAC_HISTORY and MACs table
	-U - do not update MACs table
	-P - do not write and check pid file
	-h - print this help
END_MLT
}
###########################################################
sub mExit {
	my ($code) = @_;

	#unlink $PIDFILE;
	exit $code;
}

