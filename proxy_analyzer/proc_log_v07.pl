#!/usr/bin/perl
#
# v.9 2013-04-16 svsoldatov
#

use lib "/root/perl5/lib/perl5"; #CPAN home
use POSIX "sys_wait_h";
use Socket qw( inet_aton inet_ntoa );
use IPC::Shareable;
use Getopt::Long;
use Net::IP::Match::XS;
use Time::HiRes qw(gettimeofday);
use Sys::CpuLoadX;

do "Lists.conf"; # Threashold and Output files of colored lists

#####################################
# G L O B A L S 
#####################################
$BUF_SIZE = 2000; #lines in buffer
$MAX_LOAD_AVG = 9; #CPU load average after that we'd better go to sleep (used in --match only)
$SLEEP = 10; #sleep when CPU overloaded (used in --match only)

@buf = (); #array to store buffer 
@buf2 = (); #array to store buffer 
$CHILDREN_NUM = 9; #concurrent worker processes (used in --list only)
@CHILDREN = (); #(used in --list only)
#####################################

#
# +Options definitions
#
GetOptions( 
	convl2iponly => \$convert_l2ip_only, #convert long to ip

	help => \$help,
	
	"io=s" => \$io_file, #Input/Output config
	"list=s" => \$list_search, #perform list search (can be list:s, but doesn't work im my env :-(()
	"match=s" => \$match_search, #perform exact match search
	printscore => \$printscore, #print score into output file
);

if($help){
	printUsage();
	exit 0;
}

# Input/Output format
$io_file = "InputOutputFileFormat.conf" unless $io_file;
do "$io_file";

if($convert_l2ip_only){
	my $pcount = 0; 

	while (my $l = <STDIN>){
		print join_log_line(transform_log_line($l))."\n";

		if(++$pcount %300000 == 0){ 
			print STDERR "$pcount lines processed \r\n" ;
		}
	}
}
elsif($list_search){
	
	print  "Enter list Search --$list_search--\n";#DEBUG
	do "$list_search"; #read checks detais

	my %lists = ();
	readLists(\%lists);

	@buf = ();
	while (get_next_buf_to_parse() > 0){
		last if @buf == 0;
		while(@buf > 0){ #wait for buffer emptied => was copied to child
			if(@CHILDREN <= $CHILDREN_NUM){
				#my $t0 = gettimeofday(); #DEBUG
				my $pid = fork();
				if ($pid){
					#PAPA
				
					@buf = (); #buffer copied to child so can be cleared
					push @CHILDREN, $pid;
					$SIG{CHLD} = \&child_handler;
					$SIG{INT} = \&int_handler;
				}
				else {
					#CHILD
					#my $t1 = gettimeofday(); #DEBUG
					#print "FORK TIME $$: ".($t1-$t0)."\n\n"; #DEBUG
					
					@CHILDREN = (); #no children
					$SIG{INT} = \&int_handler;
		
					#print "$$: First line in buffer ".substr($buf[0],0,50)." ..\n\n"; #DEBUG
					#print "$$: Last line in buffer ".substr($buf[$#buf],0,50)." ..\n\n"; #DEBUG
					my $line_counter = 0;

					##################
					#sleep 1; #DEBUG #
					#exit 0;  #DEBUG #
					##################
					
					# Open output file
					foreach my $color (keys %ParserCfg::Lists){
						my $out_file_name = $ParserCfg::Lists{$color}->{OutFile};
						my $t = time();
						unless ( ($out_file_name =~ s/PID/$$/) && ($out_file_name =~ s/TIME/$t/) ){
							my @tok = split /\./, $out_file_name;
							$tok[$#tok-1] .= "_${t}_$$";
							$out_file_name = join ".",@tok;
						}
						open $ParserCfg::Lists{$color}->{OutFileFD}, ">$out_file_name" 
							or print STDERR "Open '".$ParserCfg::Lists{$color}->{OutFile}."': $!\n";
						$ParserCfg::Lists{$color}->{OutFile} = $out_file_name;
					}
					
					foreach my $l (@buf){
						# prepare line
						my @f = transform_log_line($l);
						$l = join_log_line(@f);

						my $linescore = 0;
						
						my $i = 0; #Output line field counter
						foreach my $fn (@{$ParserCfg::Proclog{Output}}){ #field name
							##print "\t\t -- $fn --\n"; #DEBUG
				
							foreach my $a (@{$ParserCfg::Checks{$fn}}){ #enumerate checks
								if ($a->{DATA_FILE}){
									if ($a->{FUNC} eq "ListSearch"){ #search in hash (list search)
										#print "\t\t\t\t -- ListSearch -- "; #DEBUG
										$linescore += $lists{$fn}->{$a->{FUNC}}->{$f[$i]};
										#print " ($linescore) \n"; #DEBUG
									}
									elsif($a->{FUNC} =~ /^DomainSearch/){

										my $serach_pattern;
										if ($f[$i] =~ /\.\d{1,3}$/ ){ #IP
											$serach_pattern = $f[$i];
										}
										else { #domain
											my ($func, $dlevel) = split ':', $a->{FUNC};
											$dlevel = 3 unless $dlevel;
											
											my @dnames = split /\./, $f[$i];
											my @rdnames = ();
											my $nn = $dlevel > @dnames ? $#dnames : ($dlevel-1);
											for (0 ..  $nn){
												unshift( @rdnames, pop(@dnames) );
											}
											$serach_pattern = join '.', @rdnames;
										}
										#print "\t\t\t\t -- DomainSearch (pattern: $serach_pattern (".$f[$i].") ) --\n"; #DEBUG
										$linescore += $lists{$fn}->{$a->{FUNC}}->{$serach_pattern};
										#print " ($linescore) \n"; #DEBUG
										
									}
									elsif($a->{FUNC} eq "RegexpSearch"){
										#print "\t\t\t\t -- RegexpSearch --"; #DEBUG
										foreach my $re (@{$lists{$fn}->{$a->{FUNC}}->{LIST}}){
											##print "Check '$re'\n"; #DEBUG
											if ($f[$i] =~ /$re/){
												$linescore += $lists{$fn}->{$a->{FUNC}}->{SUCCESS_RETURN};
												#print " ($linescore) "; #DEBUG
												last;
											}
										}
										#print "\n"; #DEBUG
									}
									elsif($a->{FUNC} eq "IPListSearch"){
										#print "\t\t\t\t -- IPListSearch --"; #DEBUG
										foreach my $range (@{$lists{$fn}->{$a->{FUNC}}->{LIST}}){
											##print "Check '$range'\n"; #DEBUG
											if(match_ip($f[$i],$range)){
												$linescore += $lists{$fn}->{$a->{FUNC}}->{SUCCESS_RETURN};
												#print " ($linescore) "; #DEBUG
												last;
											}
										}
										#print "\n"; #DEBUG
									}
								}
							}
							$i++;
						}
							
						#print "$$: Line: $l\nScore: $linescore\n\n\n"; #DEBUG
						$l = "($linescore) ".$l if $printscore;
						$line_counter++;

						#print map {"$_\n"} ($ParserCfg::Lists{ExpWhiteList}->{OutFileFD},$ParserCfg::Lists{WhiteList}->{OutFileFD},$ParserCfg::Lists{GrayList}->{OutFileFD},$ParserCfg::Lists{BlackList}->{OutFileFD},$ParserCfg::Lists{ExpBlackList}->{OutFileFD}); #DEBUG
			
						$| = 1; #flush 
						if ( $ParserCfg::Lists{ExpWhiteList}->{OutFileFD} && ($linescore > $ParserCfg::Lists{ExpWhiteList}->{Thr}) ){
							#print "Line goes to ExpWhiteList\n"; #DEBUG
							print {$ParserCfg::Lists{ExpWhiteList}->{OutFileFD}} "$l\n";
						}
						elsif( $ParserCfg::Lists{WhiteList}->{OutFileFD} && ($ParserCfg::Lists{WhiteList}->{Thr} <= $linescore) && ($linescore <= $ParserCfg::Lists{ExpWhiteList}->{Thr}) ){
							#print "Line goes to WhiteList\n"; #DEBUG
							print {$ParserCfg::Lists{WhiteList}->{OutFileFD}} "$$: $l\n";
						}
						elsif( $ParserCfg::Lists{GrayList}->{OutFileFD} && ($ParserCfg::Lists{BlackList}->{Thr} < $linescore) && ($linescore < $ParserCfg::Lists{WhiteList}->{Thr}) ){
							#print "Line goes to GrayList\n"; #DEBUG
							print {$ParserCfg::Lists{GrayList}->{OutFileFD}} "$$: $l\n";
						}
						elsif( $ParserCfg::Lists{BlackList}->{OutFileFD} && ($ParserCfg::Lists{ExpBlackList}->{Thr} <= $linescore) && ($linescore <= $ParserCfg::Lists{BlackList}->{Thr}) ){
							#print "Line goes to BlackList\n"; #DEBUG
							print {$ParserCfg::Lists{BlackList}->{OutFileFD}} "$l\n";
						}
						elsif( $ParserCfg::Lists{ExpBlackList}->{OutFileFD} && ($linescore < $ParserCfg::Lists{ExpBlackList}->{Thr}) ){
							#print "Line goes to ExpBlackList\n"; #DEBUG
							print {$ParserCfg::Lists{ExpBlackList}->{OutFileFD}} "$l\n";
						}
						else {
							print STDERR "$l\n"; #DEBUG
						}
					}
					
					# Close output files
					map {
						close $ParserCfg::Lists{$_}->{OutFileFD};
						unlink $ParserCfg::Lists{$_}->{OutFile} if (-z $ParserCfg::Lists{$_}->{OutFile}); #delete if size is zero
					} (keys %ParserCfg::Lists);

					#print "$$: end processed $line_counter lines\n"; #DEBUG

					exit 0;
				} # CHILD body
			}
			else {
				sleep 1; # PAPA waits for children to die
			}
		} #while buffer isn't empty nobody has taken it to processing
	}# get_next_buf_to_parse
	
	while (@CHILDREN > 0){ # PAPA waits for children to die
		sleep 1;

		#print "$$ waits...\n"; #DEBUG
	}
}
elsif($match_search){
	print  "Enter match Search --$match_search--\n";#DEBUG
	do "$match_search"; #read checks detais

	my %lists = ();
	readLists(\%lists);
	#showLists(\%lists); #DEBUG

	my $h = tie @buf, 'IPC::Shareable', {
		key => 'GLUE',
		create => 1,
		mode => 0600, 
		destroy => 1, 
	};
	my $h2 = tie @buf2, 'IPC::Shareable', {
		key => '_GLUE',
		create => 1,
		mode => 0600, 
		destroy => 1, 
	};
	@CHILDREN = ();
	
	#print  "\t\t1 shlock\n";#DEBUG
	$h->shlock();
	#print  "\t\t1.5 shlock\n";#DEBUG
	$h2->shlock();
	#print  "\t\t2 shlock\n";#DEBUG
	@buf = ();
	@buf2 = ();
	
	my $buf_ref = get_next_buf_to_parse2();
	print "$$: buf size: ".@{$buf_ref}."\n"; #DEBUG
	
	while (@{$buf_ref} > 0){
		foreach my $fn ( keys %lists ){
			my $fn_i = indexOf($ParserCfg::Proclog{Output}, $fn);
			if (defined $fn_i){
				foreach my $data (keys %{$lists{$fn}->{MatchSearch}}){
					#print "fork...\n"; #DEBUG
					my $pid = fork();
					if ( $pid  > 0 ){
						#PAPA
						push @CHILDREN, $pid;
	
						$SIG{CHLD} = \&child_handler;
						$SIG{INT} = \&int_handler;
					}
					else {
						#CHILD
						@CHILDREN = ();
						$SIG{INT} = \&int_handler;
						$SIG{USR1} = \&usr_handler;

						print "Child $$: data='$data' field='$fn' ($fn_i) buf size=".@{$buf_ref}."\n"; #DEBUG
						#print "$$: First line in buffer $buf_ref->[0] ..\n\n"; #DEBUG
						#print "$$: Last line in buffer $buf_ref->[@{$buf_ref}-1] ..\n\n"; #DEBUG
						#sleep 2;
						#exit 0;

						# open file
						my $out_file_name = $lists{$fn}->{MatchSearch}->{"$data"}->{OFN};
						my $t = time();
						unless ( ($out_file_name =~ s/PID/$$/) && ($out_file_name =~ s/TIME/$t/) ){
							my @tok = split /\./, $out_file_name;
							$tok[$#tok-1] .= "_${fn}_${t}_$$";
							$out_file_name = join ".",@tok;
						}
						open $lists{$fn}->{MatchSearch}->{$data}->{OFD}, ">$out_file_name"
							or print STDERR "Open '$out_file_name': $!\n";
						$lists{$fn}->{MatchSearch}->{"$data"}->{OFN} = $out_file_name;
				
						#my $j = 0; #DEBUG
						foreach my $l (@{$buf_ref}){ #lines
							my @f = transform_log_line($l);
							$l = join_log_line(@f);
							#print "$$: $l\n"; #DEBUG
							
							if ($f[$fn_i] =~ /$data/){
								print {$lists{$fn}->{MatchSearch}->{$data}->{OFD}} "$l\n";
								#print "MATCH: $l\n"; #DEBUG
							}

							#$j++; #DEBUG
							#print "$$: line ", $j,"\n" if ($j%10000 == 0); #DEBUG
						}

						close $lists{$fn}->{MatchSearch}->{$data}->{OFD};
						unlink $lists{$fn}->{MatchSearch}->{"$data"}->{OFN} 
							if (-z $lists{$fn}->{MatchSearch}->{"$data"}->{OFN});
	
						exit 0;
					} #Child body
				}
			}
		}
		
		my $buf_ref2 = get_next_buf_to_parse2();
		
		while(@CHILDREN > 0){ #wait for children
			my ($load1,$load5,$load15) = Sys::CpuLoadX::get_cpu_load();
			if ($load1 > $MAX_LOAD_AVG){
				print "PAPA: ls = $load1 (>$MAX_LOAD_AVG)\n"; #DEBUG;
				kill USR1 => @CHILDREN;

				sleep 60; # can be 1 minute because minimum load average period is 1 min
			}

			#print "PAPA: Children count: ".@CHILDREN.": ".join(" ",@CHILDREN)."\n"; #DEBUG;
			sleep 1;
		}

		@{$buf_ref} = (); #Children died => wee can empty buffer
		$buf_ref = $buf_ref2;

	}# get_next_buf_to_parse2
	$h->shunlock();
	$h2->shunlock();

	# close files
}
else{ 
	printUsage();
	exit 0;
}


###################################################
#  S U B S
###################################################
sub indexOf {
	my ($ar, $f) = @_;	

	my $i = 0;
	foreach my $fi (@{$ar}){
		if ($fi eq $f){
			return $i;
		}
		$i++;
	}
	return undef;
}
###################################################
#
# read lists
#
sub readLists {
	my ($ref) = @_;
	%{$ref} = ();
	
	#print "In readLists... \n"; #DEBUG
	foreach my $f (keys %ParserCfg::Checks){
		#print "--- FIELD: $f --- \n"; #DEBUG
		foreach my $a (@{$ParserCfg::Checks{$f}}){
			#print "--- ARRAY: $a --- \n"; #DEBUG
			open LL, $a->{DATA_FILE} or do{print STDERR "Open ".$a->{DATA_FILE}.": $!\n" if $a->{DATA_FILE};  $a->{DATA_FILE}=''};
			while(my $ll = <LL>){
				$ll =~ s/^\s+//;
				$ll =~ s/\s+$//;
				next if $ll =~ /^#/;
				#print "readLists (FUNC=".$a->{FUNC}."): '$ll'...\n"; #DEBUG
				if ( grep {$a->{FUNC} =~ /$_/} ("^ListSearch","^DomainSearch")){
					$ref->{$f}->{$a->{FUNC}}->{$ll} = $a->{SUCCESS_RETURN};
				}
				elsif ( grep {$a->{FUNC} eq $_} ("RegexpSearch","IPListSearch") ){
					$ref->{$f}->{$a->{FUNC}}->{SUCCESS_RETURN} = $a->{SUCCESS_RETURN};
					push @{$ref->{$f}->{$a->{FUNC}}->{LIST}}, $ll;
				}
				elsif ($a->{FUNC} eq "MatchSearch"){
					my ($data,$ofn) = split /##/, $ll;
					print "MatchSearch: $data, $ofn\n"; #DEBUG
					$ref->{$f}->{$a->{FUNC}}->{$data}->{OFN} = $ofn;
				}
				#print "goes to ${f}::".$a->{FUNC}."\n"; #DEBUG
			}
			close LL;
		}
	}
}
sub showLists {
	my ($ref) = @_;

	print "============= showLists =====================\n";
	for my $f (keys %{$ref}){
		print "$f\n";
		for my $fu (keys %{$ref->{$f}}){
			print "\t$fu\n";
			if (grep {$fu eq $_} ("ListSearch","MatchSearch") ){
				my $i = 0;
				for my $lm ( keys %{$ref->{$f}->{$fu}} ){
					print "\t\t$lm\t".$ref->{$f}->{$fu}->{$lm}."\n";
					$i++;
					last if $i >=10;
				}
			}
			elsif (grep {$fu eq $_} ("IPListSearch","RegexpSearch") ){
				my $i = 0;
				for my $lm ( @{$ref->{$f}->{$fu}->{LIST}} ){
					print "\t\t$lm\t".$ref->{$f}->{$fu}->{SUCCESS_RETURN}."\n";
					$i++;
					last if $i >=10;
				}
			}
		}
	}
	print "===============================================\n";
}

###################################################
# IP to Long and back
###################################################
sub long2ip {
	my $d = shift;
	if ($d =~ /^\d+$/){
		return inet_ntoa(pack('N', $d));
	}
	else {
		return $d;
	}
}
sub ip2long {
	my $d = shift;
	if($d =~ /\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}/){
		return unpack('N', inet_aton($d));
	}
	else {
		return $d;
	}
}
###################################################
# show help
###################################################
sub printUsage {
print <<EEE;
Serach patterns in HTTP logs and store results in different files.
	OPTIONS:
	--convl2iponly - convert Long to dotted IP only w/o search
	--list=<FILE> - list serach with specified config
	--io=<FILE> - Input/Output config
	--printscore - print logline score into output file
	--help - print help
EEE

}
###################################################
# Transform log line.
# Input: raw log line
# Output: desired field in correct order
sub transform_log_line {
	my $LINE = shift;
	my @ret = ();
	
	$LINE =~ s/^\s+//; $l =~ s/\s+$//;
	if (defined $ParserCfg::Proclog{DELIMETER}){
		my @inpfields = split /$ParserCfg::Proclog{DELIMETER}/,$LINE;
		#print "inpfields: ".join("::",@inpfields)."\n"; #DEBUG
		@ret = map {$_=~/_IP$/ ? long2ip($inpfields[$ParserCfg::Proclog{FIELDS}->{$_}->{N}]) : $inpfields[$ParserCfg::Proclog{FIELDS}->{$_}->{N}]} @{$ParserCfg::Proclog{Output}};
	}
	else {
		#print "ELSE!\n"; #DEBUG
		foreach my $fn ( @{$ParserCfg::Proclog{Output}} ) {
			my $regexp = $ParserCfg::Proclog{REGEXP};
			foreach my $ffn ( @{$ParserCfg::Proclog{Output}} ) {
				if($fn eq $ffn){
					my $freg = '('.$ParserCfg::Proclog{FIELDS}->{$ffn}->{RE}.')';
					$regexp =~ s/$ffn/$freg/;
				}
				else {
					$regexp =~ s/$ffn/$ParserCfg::Proclog{FIELDS}->{$ffn}->{RE}/;
				}
			}
			if ($LINE =~ /$regexp/){
				my $fff = $1;
				if($fn =~ /_IP$/){
					$fff = long2ip($fff);
				}
				push @ret, $fff;
				#print "OK on $fn ($1)\n\n"; #DEBUG
			}
			#else {
			#	print "ERROR on $fn: '$regexp'\n\n$LINE\n\n"; #DEBUG
			#}
		}
	}
	#print "transform_log_line: ".join('::',@ret)."\n"; #DEBUG
	return @ret;
}
###################################################
sub join_log_line {
	my @ar = @_;
	my $l = '';

	if ($ParserCfg::Proclog{DELIMETER}){
		$l = join ($ParserCfg::Proclog{DELIMETER}, @ar);
	}
	else {
		$l = $ParserCfg::Proclog{OUTPUT};
		my $j = 0;
		foreach my $fn ( @{$ParserCfg::Proclog{Output}} ) {
			$l =~ s/$fn/$ar[$j]/;
			$j++;
		}
	}
	
	#print "join_log_line: $l\n"; #DEBUG
	return $l;
}
###################################################
# wait for children to exit and kill zombies (reaper)
###################################################
sub child_handler {
	my $pid;

	while ( ($pid = waitpid(-1, &WNOHANG)) > 0){
		#print "PAPA $$: Child $pid died....\n"; #DEBUG
		for(my $ii=0; $ii<@CHILDREN;$ii++){
			if($pid == $CHILDREN[$ii]){
				splice(@CHILDREN,$ii,1);
			}
		}
	}
	#print "PAPA: CHILDREN = [".join(",",@CHILDREN)."]\n"; #DEBUG

	$SIG{CHLD} = \&child_handler;
}
#################################################
# USR1 handler
#################################################
sub usr_handler {
	print "CHILD $$: Caught USR1\n"; #DEBUG

	sleep $SLEEP;
	$SIG{USR1} = \&usr_handler;
}
##################################################
# SIGINT handler
##################################################
sub int_handler {
	if (@CHILDREN) { #PAPA
		#print "PAPA (INT handler): CHILDREN = [".join(",",@CHILDREN)."]\n"; #DEBUG
	
		kill -2 => @CHILDREN;
		sleep 1;

		exit 0;
	}
	else { #CHILD
		#print "CHILD $$: Caught SIGINT\n"; #DEBUG
		exit 0;
	}
}
###################################################
# read buf array from stdin 
# returns number of lines read
###################################################
sub get_next_buf_to_parse { 
	#print " Entering get_next_buf\n\n"; #DEBUG

	my $l_read=0;

	@buf = ();
	while (my $l = <STDIN>){
		push @buf, $l;
		last if (++$l_read == $BUF_SIZE);

		#print "$l_read\n"; #DEBUG (check shared segment size)
	}

	print "$$: $l_read lines read\n\n"; #DEBUG
	
	return $l_read;
}
###################################################
sub get_next_buf_to_parse2 { 
	print " Entering get_next_buf2\n\n"; #DEBUG
	my $buf_ref;

	if (@buf == 0){
		print "   Will use \@buf\n"; #DEBUG
		$buf_ref = \@buf;
	}
	elsif (@buf2 == 0) {
		print "   Will use \@buf2\n"; #DEBUG
		$buf_ref = \@buf2;
	}
	else {
		print "$$: no free buffer available\n\n"; #DEBUG
		return undef;
	}

	my $l_read=0;

	while (my $l = <STDIN>){
		push @{$buf_ref}, $l;
		last if (++$l_read == $BUF_SIZE);

		#print "$l_read\n"; #DEBUG (check shared segment size)
	}

	print "$$: $l_read lines read\n\n"; #DEBUG
	
	return $buf_ref;
}

