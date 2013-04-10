#!/usr/bin/perl
# svsoldatov 2010-02-04

$PATH = '\\\10.10.89.47\\windows_logs\\NewVersion';
#$PATH = '\\\10.10.89.47\\windows_logs_test\\NewVersion'; #DEBUG
$ZIP = 'rar a -m5 ZIP_FILENAME FILE_NAME';

$LOGDIR = 'C:\\mlogparser\\var';


#check if no pid-file or it's too old
my $create_pid = 0;
if (-f "$LOGDIR\\process_old_windows_logs.pl.pid") {
	open PIDFILE, "<$LOGDIR\\process_old_windows_logs.pl.pid";
	while(my $l = <PIDFILE>){
		if ($l =~ /(\d+)\s+(\d+)/) {
			my ($pid, $date) = ($1, $2);
			if ( (time() - $date) > 345600) { # 4 days
				$create_pid = 1;
			}
		}
	}
	close PIDFILE;
}
else {
	$create_pid = 1;
}


if ($create_pid == 1) { 
	#write pid
	open PIDFILE, ">$LOGDIR\\process_old_windows_logs.pl.pid" or die "create pid file: $!\n";
	print PIDFILE "$$ ".time()."\n";
	close PIDFILE;

	# main process
	open LOG, ">$LOGDIR\\process_old_windows_logs.lastlog" or die "open log: $!\n";
	opendir(DIR, $PATH) or die "open '$PATH': $!\n";
	while(my $f = readdir(DIR)){
		if($f =~ /_(\d{4})-(\d{2})-(\d{2})_\w+\.csv$/){	
			my ($yyyy,$mm,$dd) = ($1,$2,$3); map {s/^0*//} ($yyyy,$mm,$dd);
			chdir $PATH;
			my @now = localtime();
			my $datedif = ($now[5]+1900-$yyyy)*372 + ($now[4]-$mm + 1)*31 + $now[3] - $dd;
			#print "$f: ".$now[5]."<>$yyyy ".$now[4]."<>$mm ".$now[3]."<>$dd diff=$datedif\n"; #DEBUG
			if ($datedif > 2) { # older than two days, need to be archived
				my $cmd = $ZIP;
				$cmd =~ s/ZIP_FILENAME/$f.rar/;
				$cmd =~ s/FILE_NAME/$f/;
				my @acmd = split /\s+/, $cmd;
				#print "$cmd ::: ",@acmd,"\n"; #DEBUG
			
				my $exitcode = system(@acmd);
				if ($exitcode != 0) { # error
					print LOG "'$cmd' returned $exitcode\n";
					unlink "$f.rar" if (-f "$f.rar");
				}
				else { #OK
					unlink $f;
				}
			}
		}
		else {
			if (!grep {$f =~ /$_/} ("\\.rar\$", "\\.zip\$", "^\\.\$", "^\\.\\.\$") ) {
				print LOG "'$f' does not match '/_\\d{4}_\\d{2}_\\d{2}_\\w+\\.csv\$/ \n";
			}
		}
	}
	closedir(DIR);
	close LOG;
	unlink "$LOGDIR\\process_old_windows_logs.pl.pid";
}
else { #already running
	print "Already running. Exiting ...\n";
}
