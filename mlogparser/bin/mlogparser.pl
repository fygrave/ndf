#!/bin/perl
# svsoldatov 2005-05-17

use POSIX ":sys_wait_h";
use Net::FTP;
use Net::SMTP;

# EVT_* - process Windows Event Log
#
%conf = (
	EVT_LL => { # logon/logout
		##SERVERS => ['REG-NS-DC01'], #DEBUG
		SERVERS => ['REG-NS-DC01'],
		# 2003:
		# UserName					0 (UNN)
		# SourceNetworkAddress		13 (SNAN)
		# AuthenticationPackage		5 (APN)
		#
		# 2008:
		# UserName					5
		# SourceNetworkAddress		18
		# AuthenticationPackage		10
		#
		CMDVER => "logparser \"SELECT Value FROM '\\\\SERVERNAME\\HKLM\\SOFTWARE\\Microsoft\\Windows NT\\CurrentVersion' WHERE ValueName = 'ProductName' \" -i:REG -o:NAT -headers:OFF -recurse:0 -q:ON",
		# Windows Server 2008 R2 Enterprise
		# Microsoft Windows Server 2003
		CMD => "logparser \"SELECT TimeGenerated,".
			" EXTRACT_TOKEN(Strings,UNN,'|') AS UserName, ".
			" EXTRACT_TOKEN(Strings,SNAN,'|') AS SourceNetworkAddress, ".
			" EXTRACT_TOKEN(Strings,APN,'|') AS AuthenticationPackage ".
			" INTO LogonActivity2 ".
			" FROM \\\\SERVERNAME\\Security ".
			" WHERE EventID IN (EVENTS) AND TimeGenerated > SUB( SYSTEM_TIMESTAMP(), TIMESTAMP('2', 'd') ) ".
			" AND UserName NOT IN ('';'ANONYMOUS LOGON';'ExchAdmin';'MSXSPI';'FMservice';'SHAREPOINT_INDEXER';'ics_cluster';'SHAREPOINT_SERVICE'; 'fmq_cluster'; 'Nyg-Sender1'; 'NYG-Sender2'; 'logparser'; 'secadmin'; 'ldapbrowser'; 'moss_sharepoint'; 'domain_script'; 'SAPEP2'; 'mssqlserver'; 'mobloguser'; 'DIRECTUM2';'rdc_micluster';'ovis_probe') ".
			" AND SourceNetworkAddress <> '-' ".
			" AND UserName NOT LIKE '%\$'  GROUP BY TimeGenerated, UserName, SourceNetworkAddress, AuthenticationPackage \"   ".
			" -i:EVT -o:SQL -server:REG-SERVNAM -database:security  -ignoreIdCols:ON -transactionRowCount:1000 -iCheckpoint:CPFILE",
		# 540 A user successfully logged on to a network.
		# 538 The logoff process was completed for a user.
		#EVENTSIN => '540;538',
		EVENTSIN => {
			2003 => '540',
			# for 2008 see http://support.microsoft.com/kb/947226
			2008 => '4624',
		},
		POS => { 
			2003 => {
				UNN => 0,
				SNAN => 13,
				APN => 5,
			},
			2008 => {
				UNN => 5,
				SNAN => 18,
				APN => 10,
			},
		},
		WHAT2DO => 'selfProc01',
		VAR_PATH => '../var',
		SENTMAILT => 'SentMail',
	},
	EVT_PRT => { # print event
	SERVERS => [qw/REG-PRN-19-20
		REG-PRN-17/],
	CMD => "logparser \"SELECT TimeGenerated as print_date, ".
		" EXTRACT_TOKEN(Strings,2,'|') as login, ".
		" EXTRACT_TOKEN(Strings,3,'|') as printername, ".
		" EXTRACT_TOKEN(Strings,1,'|') as filename, ".
		" EXTRACT_TOKEN(Strings,4,'|') as port ".
		" INTO PrintActivity ".
		" FROM \\\\SERVERNAME\\System ".
		" WHERE EventID = 10 \" ".
		" -i:EVT -o:SQL -server:REG-SERVNAM -database:security -ignoreIdCols:ON -transactionRowCount:1000 -iCheckpoint:CPFILE",
		# 10 - File Printed, Source - Print
		WHAT2DO => 'selfProc03',
		VAR_PATH => '../var',
		VAR_PREF => 'PRT_',
	},

#	EVT_FA => { # file access
#		SERVERS => ['REG-FS-03','REG-FS-01','REG-FS-04'],
#		# REG-FS-03: H:\Users4 
#		# REG-FS-01: F:\Users F:\SoftDrv
#		CMD => "logparser ".
#			" \"SELECT TimeGenerated, Message".
#			" INTO  TEXTFILENAME".
#			" FROM \\\\SERVERNAME\\security ".
#			" WHERE EventID IN (EVENTSIN) ".
#			" AND EXTRACT_TOKEN(strings,1,'|') = 'File' \" ".
#			" -i:EVT -o:SYSLOG -hostName:SERVERNAME -oCodepage:1251 -iCheckpoint:CPFILE",
#		#EVENTSIN => '560;562;563;564;565;567;568;569;570;571;572',
#		EVENTSIN =>'560;564;567',
#		WHAT2DO => 'selfProc02',
#		VAR_PATH => 'c:\\mlogparser\\var',
#		GZIP => 'c:\\bin\\gzip.exe -f -q ',
#		RECODE => 'c:\\bin\\recode.exe CP1251/CR-LF..KOI8-R ',
#		FTPSERVER => '192.168.11.67',
#		FTPDIR => '/incoming/FS/',
#		FTPFILES => 'C:\\mlogparser\\var\\*.txt.gz',
#		SENTMAILT => 'SentMail',
#		# 560	Access was granted to an already existing object.
#		# 562	A handle to an object was closed.
#		# 563	An attempt was made to open an object with the intent to delete it. 
#		#       Note: This is used by file systems when the FILE_DELETE_ON_CLOSE flag is specified in Createfile().
#		# 564	A protected object was deleted.
#		# 565	Access was granted to an already existing object type.
#		# 567	A permission associated with a handle was used. 
#		#       Note: A handle is created with certain granted permissions (Read, Write, and so on). When the handle is used, up to one audit is generated for each of the permissions that were used.
#		# 568	An attempt was made to create a hard link to a file that is being audited.
#		# 569	The resource manager in Authorization Manager attempted to create a client context.
#		# 570	A client attempted to access an object. 
#		#       Note: An event will be generated for every attempted operation on the object.
#		# 571	The client context was deleted by the Authorization Manager application.
#		# 572	The Administrator Manager initialized the application.
#		
#		## 772	The Certificate Manager denied a pending certificate request.
#		## 773	Certificate Services received a resubmitted certificate request.
#		## 774	Certificate Services revoked a certificate.
#		## 775	Certificate Services received a request to publish the certificate revocation list (CRL).
#		## 776	Certificate Services published the CRL.
#		## 777	A certificate request extension was made.
#		## 778	One or more certificate request attributes changed.
#		## 779	Certificate Services received a request to shut down.
#		## 780	Certificate Services backup started.
#		## 781	Certificate Services backup completed.
#		## 782	Certificate Services restore started.
#		## 783	Certificate Services restore completed.
#		## 784	Certificate Services started.
#		## 785	Certificate Services stopped.
#		## 786	The security permissions for Certificate Services changed.
#		## 787	Certificate Services retrieved an archived key.
#		## 788	Certificate Services imported a certificate into its database.
#		## 789	The audit filter for Certificate Services changed.
#		## 790	Certificate Services received a certificate request.
#		## 791	Certificate Services approved a certificate request and issued a certificate.
#		## 792	Certificate Services denied a certificate request.
#		## 793	Certificate Services set the status of a certificate request to pending.
#		## 794	The certificate manager settings for Certificate Services changed.
#		## 795	A configuration entry changed in Certificate Services.
#		## 796	A property of Certificate Services changed.
#		## 797	Certificate Services archived a key.
#		## 798	Certificate Services imported and archived a key.
#		## 799	Certificate Services published the certificate authority (CA) certificate to Microsoft Active Directory directory service.
#		## 800	One or more rows have been deleted from the certificate database.
#		## 801	Role separation enabled.
#	},
);

$SIG{CHLD} = \&child_handler;

foreach my $k (keys %conf) {
	if ($k =~ /^EVT_/) {
		$conf{$k}->{WHAT2DO}($conf{$k});
	}
}
#################################################
# handle child
sub child_handler {
	##print "In child_handler...\n"; #DEBUG
	while (my $died = waitpid(-1, WNOHANG) > 0) {
		$exit_value = $? >> 8;
		$dumped_core = $? & 128;

		if ($exit_value != 0 or $dumped_core) { # delete lock file if child died with errors
			##print "$died exited whth errors\n"; #DEBUG
		}
		else {
			##print "$died exited successfully\n"; #DEBUG
		}
		delete ($childs{$died});
	}
	$SIG{CHLD} = \&child_handler;
}
#################################################
# process Print events
sub selfProc03 {
	my $c = shift;

	my $cmd = $c->{CMD};
	
	foreach my $s (@{$c->{SERVERS}}) {
		if (my $pid = fork()) {
			#papa
		}
		else {
			#child
			
			$cmd =~ s/SERVERNAME/$s/;
			my $cp_file = $c->{VAR_PATH}.'/'.$c->{VAR_PREF}.$s.'.lpc';
			$cmd =~ s/CPFILE/$cp_file/;
				
			#print "\n\n$$: '$cmd'\n";
			my $out = `$cmd`;
			print "Server: $s:$out\n";
					
			exit 0;
		}# child
	}# for $s (servers)

}
#################################################
# process file access events
sub selfProc02 {
	my $c = shift;
	my $cmd = $c->{CMD};

	#LOGFILE
	open LOG, ">>".$c->{VAR_PATH}.'\\mlogparser.log' or die "cannot create logfile: $!\n";

	# FTP put
	if (my $pid = fork() == 0){ #new process
		my $ftpcmdfile = $c->{VAR_PATH}."/ftp$$.cmd";
		open FTPCMD, ">$ftpcmdfile" || die "cannot open $ftpcmdfile: $!\n";
		print FTPCMD "anonymous\nbinary\ncd ".$c->{FTPDIR}."\n";
		my @to_unlink = ();
		my @dirgl = glob($c->{FTPFILES});
		foreach my $f1 (@dirgl) {
			 print FTPCMD "put $f1\n";
			 push @to_unlink, $f1;
		}
		print FTPCMD "quit\n";
		close FTPCMD;
		my $cmd = "ftp -i -s:$ftpcmdfile ".$c->{FTPSERVER};
		`$cmd`;
		foreach my $f (@to_unlink) {
			unlink $f;
		}
		unlink $ftpcmdfile;
		exit 0;
	}
	# FTP put end
	##exit 0; #DEBUG

	%childs = ();
	foreach my $s (@{$c->{SERVERS}}) {
		my $lockfn = $c->{VAR_PATH}.'\\'.$s.'.lock'; #LOCK
		if (my $pid = fork()) {
			#papa
		}
		else {
			#child
			die "cannot fork: $!" unless defined $pid;
			
			##print "I'm $$! I will process $s\n"; #DEBUG

			$cmd =~ s/SERVERNAME/$s/g;                    # eventlog server
			$cmd =~ s/EVENTSIN/$c->{EVENTSIN}/;            # events to choose
			my $cp_file = $c->{VAR_PATH}.'\\'.$s.'.lpc';
			$cmd =~ s/CPFILE/$cp_file/;                  # check point file
			
			my ($sec,$min,$hour,$mday,$mon,$year) = localtime(time); 
			$year += 1900; $mon += 1; 
			my $tm_str = sprintf("%4d",$year).sprintf("%02d",$mon).sprintf("%02d",$mday).sprintf("%02d",$hour).sprintf("%02d",$min).sprintf("%02d",$sec); 
			my $tmp_file = $c->{VAR_PATH}.'\\'.$tm_str.'_'.$s.'.txt';
			$cmd =~ s/TEXTFILENAME/$tmp_file/;
			##print "\n\n$s: '$cmd'\n"; #DEBUG
			my $out = `$cmd`;
			
			# check if file is empty
			my @st = stat $tmp_file;
			##print "File $tmp_file size: ",$st[7],"\n"; #DEBUG
			if ($st[7] < 10) { # file size
				unlink $tmp_file;
				print LOG ''.localtime(time)." file access evts: server: $s: No new events since last check\n";
			}
			else {
				##print "File $tmp_file recode and gzip...\n"; #DEBUG
				$out .= `$c->{RECODE} $tmp_file`; 
				$out .= `$c->{GZIP} $tmp_file`; 
			}

			print "Server: $s:$out\n";
			exit 0;
		}# child
	}# for $s (servers)
	close LOG;
}
#################################################
# process Logon/Logoff events
sub selfProc01 {
	my $c = shift;

	# get DC list
	if (@{$c->{SERVERS}} == 0) {
		my $netdom = `netdom query /D:CORP DC`;
		foreach my $r (split /\s+/, $netdom) {
			if ($r =~ /DC0/) {
				push @{$c->{SERVERS}}, $r;
			}
		}
	}
	##print join("; ",@{$c->{SERVERS}})."\n"; #DEBUG
	##exit 0;

	my $cmd = $c->{CMD};
	my $cmdver = $c->{CMDVER};
	

	foreach my $s (@{$c->{SERVERS}}) {
		##my $lockfn = $c->{VAR_PATH}.'/'.$s.'.lock'; #LOCK
		if (my $pid = fork()) {
			#papa
		}
		else {
			#child
			
			#LOGFILE
			open LOG, ">".$c->{VAR_PATH}."/$s-logparser.log" or die "cannot create logfile: $!\n";
			
			#get windows version
			$cmdver =~ s/SERVERNAME/$s/;
			my $out = `$cmdver`;
			my $winver = 0;
			if ($out =~ /Windows\s+Server\s+(\d+)/i) {
				$winver = $1;
			}
			else {
				print LOG localtime()."$s: Unknown windows version\n";
				print localtime()."$s: Unknown windows version: $out\n";
				exit 1;
			}

			##print "\n\n$cmdver:winver=$winver:$out\n"; #DEBUG

			$cmd =~ s/SERVERNAME/$s/;
			$cmd =~ s/EVENTS/$c->{EVENTSIN}->{$winver}/;
			my $cp_file = $c->{VAR_PATH}.'/'.$s.'.lpc';
			$cmd =~ s/CPFILE/$cp_file/;
			foreach my $pos (keys %{$c->{POS}->{$winver}}) {
				$cmd =~ s/$pos/$c->{POS}->{$winver}->{$pos}/;
			}
				
			##print "\n\n$$:winver=$winver: '$cmd'\n"; #DEBUG
			##print "Server: $s: "; #DEBUG

			undef $out;
			$out = `$cmd`;
			print "Server: $s:$winver: $out\n";
			print LOG localtime()."$s:$winver: $out\n";

			close LOG;
			
			exit 0;
		}# child
	}# for $s (servers)

}
###################################################
sub writeLock {
	my ($n, $d) = @_;

	my $s = $d || $$;

	open FL, ">>$n" || die "open '$n': $!\n";
	print FL "$s\n";
	close FL;
}
sub deleteLock {
	my $n = shift;

	unlink($n);
}

sub checkLock {
	my $n = shift;

	if (-e $n) {
		return 1;
	}
	else {
		return 0;
	}
}
sub countSentMail {
	my ($n, $t) = @_;
	
	##print "--- $$: countSentMail: ($n, $t): "; #DEBUG
	open FL, "<$n" || die "open '$n': $!\n";
	my $c = 0;
	while (<FL>) {
		if (/$t/) {
			$c++;
		}
	}
	close FL;
	##print "will return $c\n"; #DEBUG
	return $c;
}
###################################################
sub sendMail {
	my ($data) = @_;
	my @r = ('svsoldatov@example.com');
	my $f = 'logparser';

	$smtp = Net::SMTP->new('10.4.193.5') || die "sendMail new: $!\n";
	
	my $from = $f.'@REG-logprsr-01.corp.example.com';
	#print "from $from\n";
	$smtp->mail($from) || die "sendMail mail $from: $!\n";
	$smtp->to(@r) || die "sendMail to: $!\n";

	$smtp->data() || die "sendMail data: $!\n";
	$smtp->datasend("\n$data") || die "sendMail datasend: $!\n";
	$smtp->dataend() || die "sendMail dataend: $!\n";

    $smtp->quit;
}
