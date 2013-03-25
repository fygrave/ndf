#!/usr/bin/perl
#
# v.7 2013-03-22 svsoldatov
#

use lib "/root/perl5/lib/perl5"; #CPAN home
use POSIX "sys_wait_h";
use Socket qw( inet_aton inet_ntoa );
use IPC::Shareable;
use Getopt::Long;
use Net::IP::Match::XS;
use Time::HiRes qw(gettimeofday);

do "Lists.conf"; # Threashold and Output files of colored lists

#####################################
# G L O B A L S 
#####################################
$BUF_SIZE = 100000; #lines in buffer
@buf = (); #array to store buffer 
$CHILDREN_NUM = 9; #concurrent worker processes
@CHILDREN = ();
#####################################

#
# +Options definitions
#
GetOptions( 
	convl2iponly => \$convert_l2ip_only, #convert long to ip
	
	# Parse already converted file, search only
	append => \$write_mode_append,

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
	#showLists(\%lists); #DEBUG

	openOutputFiles(\%lists);

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
		
					#print "$$: First line in buffer $buf[0] ..\n\n"; #DEBUG
					#print "$$: Last line in buffer $buf[$#buf] ..\n\n"; #DEBUG
					##################
					#sleep 1; #DEBUG #
					#exit 0;  #DEBUG #
					##################

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
											
											my @dnames = split '.', $f[$i];
											my @rdnames = ();
											my $nn = $dlevel > @dnames ? $#dnames : ($dlevel-1);
											for (0 ..  $nn){
												unshift( @rdnames, pop(@dnames) );
											}
											$serach_pattern = join '.', @rdnames;
										}
										#print "\t\t\t\t -- DomainSearch (pattern: $serach_pattern) --"; #DEBUG
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
							
						#print "Score: $linescore\n\n\n"; #DEBUG
						$l = "($linescore) ".$l if $printscore;

						#print map {"$_\n"} ($ParserCfg::Lists{ExpWhiteList}->{OutFileFD},$ParserCfg::Lists{WhiteList}->{OutFileFD},$ParserCfg::Lists{GrayList}->{OutFileFD},$ParserCfg::Lists{BlackList}->{OutFileFD},$ParserCfg::Lists{ExpBlackList}->{OutFileFD}); #DEBUG
			
						if ( $ParserCfg::Lists{ExpWhiteList}->{OutFileFD} && ($linescore > $ParserCfg::Lists{ExpWhiteList}->{Thr}) ){
							#print "Line goes to ExpWhiteList\n"; #DEBUG
							print {$ParserCfg::Lists{ExpWhiteList}->{OutFileFD}} "$l\n";
							$ParserCfg::Lists{ExpWhiteList}->{OutFileLCNT}++;
						}
						elsif( $ParserCfg::Lists{WhiteList}->{OutFileFD} && ($ParserCfg::Lists{WhiteList}->{Thr} <= $linescore) && ($linescore <= $ParserCfg::Lists{ExpWhiteList}->{Thr}) ){
							#print "Line goes to WhiteList\n"; #DEBUG
							print {$ParserCfg::Lists{WhiteList}->{OutFileFD}} "$l\n";
							$ParserCfg::Lists{WhiteList}->{OutFileLCNT}++;
						}
						elsif( $ParserCfg::Lists{GrayList}->{OutFileFD} && ($ParserCfg::Lists{BlackList}->{Thr} < $linescore) && ($linescore < $ParserCfg::Lists{WhiteList}->{Thr}) ){
							#print "Line goes to GrayList\n"; #DEBUG
							print {$ParserCfg::Lists{GrayList}->{OutFileFD}} "$l\n";
							$ParserCfg::Lists{GrayList}->{OutFileLCNT}++;
						}
						elsif( $ParserCfg::Lists{BlackList}->{OutFileFD} && ($ParserCfg::Lists{ExpBlackList}->{Thr} <= $linescore) && ($linescore <= $ParserCfg::Lists{BlackList}->{Thr}) ){
							#print "Line goes to BlackList\n"; #DEBUG
							print {$ParserCfg::Lists{BlackList}->{OutFileFD}} "$l\n";
							$ParserCfg::Lists{BlackList}->{OutFileLCNT}++;
						}
						elsif( $ParserCfg::Lists{ExpBlackList}->{OutFileFD} && ($linescore < $ParserCfg::Lists{ExpBlackList}->{Thr}) ){
							#print "Line goes to ExpBlackList\n"; #DEBUG
							print {$ParserCfg::Lists{ExpBlackList}->{OutFileFD}} "$l\n";
							$ParserCfg::Lists{ExpBlackList}->{OutFileLCNT}++;
						}
					}
					
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

	# close files
	closeOutputFiles(\%lists);
}
elsif($match_search){
	print  "Enter match Search --$list_search--\n";#DEBUG
	do "$match_search"; #read checks detais

	my %lists = ();
	readLists(\%lists);
	#showLists(\%lists); #DEBUG

	openOutputFiles(\%lists);


	my $buf_size = $BUF_SIZE*700;
	print "Shared memory SIZE: ".IPC::Shareable::SHM_BUFSIZ()." will change to $buf_size\n\n"; #DEBUG
	my $h = tie @buf, , 'IPC::Shareable', {
		key => 'GLUE',
		create => 1,
		mode => 0600, 
		destroy => 1, 
		#size => $buf_size, 
	};
	@CHILDREN = ();
	
	@buf = ();
	while (get_next_buf_to_parse() > 0){
	last if @buf == 0;

		foreach my $data (keys %{$lists{MatchSearch}}){
			if ( (my $pid = fork()) > 0){
				#PAPA
				push @CHILDREN, $pid;

				$SIG{CHLD} = \&child_handler;
				$SIG{INT} = \&int_handler;

			}
			else {
				#CHILD
				@CHILDREN = ();
				$SIG{INT} = \&int_handler;

				print "Child $$: data='$data' buf size=".@buf."\n";
				#sleep 2;
				#exit 0;
				
				foreach my $l (@buf){
					my @f = transform_log_line($l);
					$l = join_log_line(@f);

					my $i = 0; #Output line field counter
					foreach my $fn (@{$ParserCfg::Proclog{Output}}){ #field name
						if ($fn eq $lists{MatchSearch}->{$data}->{FN}){
							print {$lists{MatchSearch}->{$data}->{OFD}} "$l\n" if $f[$i] =~ /$data/;
						}
						$i++;
					}
				}
			} #Child body
		}
		while(@CHILDREN > 0){ #wait for children
			sleep 1;
		}

	}# get_next_buf_to_parse

	# close files
	closeOutputFiles(\%lists);
}
else{ 
	printUsage();
	exit 0;
}


###################################################
#  S U B S
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
					#print "MatchSearch: $data, $ofn\n"; #DEBUG
					$ref->{$a->{FUNC}}->{$data} = {FN=>$f,OFN=>$ofn};
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
	--append - write results in append mode
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
	foreach my $fn ( @{$ParserCfg::Proclog{Output}} ) {
		my $regexp = $ParserCfg::Proclog{REGEXP};
		foreach my $ffn ( @{$ParserCfg::Proclog{Output}} ) {
			if($fn eq $ffn){
				my $freg = '('.$ParserCfg::Proclog{FIELDS}->{$ffn}.')';
				$regexp =~ s/$ffn/$freg/;
			}
			else {
				$regexp =~ s/$ffn/$ParserCfg::Proclog{FIELDS}->{$ffn}/;
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
	return @ret;
}
###################################################
sub join_log_line {
	my @ar = @_;
	my $l = $ParserCfg::Proclog{OUTPUT};

	my $j = 0;
	foreach my $fn ( @{$ParserCfg::Proclog{Output}} ) {
		$l =~ s/$fn/$ar[$j]/;
		$j++;
	}

	return $l;
}
###################################################
# wait for children to exit and kill zombies (reaper)
###################################################
sub child_handler {
	my $pid;

	while ( ($pid = waitpid(-1, &WNOHANG)) > 0){
		print "PAPA $$: Child $pid died....\n"; #DEBUG
		for(my $ii=0; $ii<@CHILDREN;$ii++){
			if($pid == $CHILDREN[$ii]){
				splice(@CHILDREN,$ii,1);
			}
		}
	}
	print "PAPA: CHILDREN = [".join(",",@CHILDREN)."]\n"; #DEBUG

	$SIG{CHLD} = \&child_handler;
}
##################################################
# SIGINT handler
##################################################
sub int_handler {
	if (@CHILDREN) {
		#print "PAPA $$: Caught SIGINT\n"; #DEBUG
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

	print "$l_read lines read\n\n"; #DEBUG
	
	return $l_read;
}
######################################################
# open output files
######################################################
sub openOutputFiles {
	my $ref = shift;

	# open colored files
	if ($list_search){
		foreach my $l (keys %ParserCfg::Lists){
			if ($ParserCfg::Lists{$l}->{OutFile}){
				undef $ParserCfg::Lists{$l}->{OutFileFD};
				open ($ParserCfg::Lists{$l}->{OutFileFD}, $write_mode_append ? ">>":">", $ParserCfg::Lists{$l}->{OutFile}) 
					or die "open ".$ParserCfg::Lists{$l}->{OutFile}.": $!\n";
			}
		}
	}
	
	# open write-just-matched files (MatchSearch algorithm)
	if ($match_search){
		foreach my $a (keys %{$ref}){ #FUNC
			foreach my $data (keys %{$ref->{$a}}){ #FUNC
				open($ref->{$a}->{$data}->{OFD},$write_mode_append ? ">>":">", $ref->{$a}->{$data}->{OFN})
					or die "Open ".$ref->{$a}->{$data}->{OFN}.": $!\n";
			}
		}
	}
}
sub closeOutputFiles {
	my $ref = shift;

	# close colored lists
	map {
		close $ParserCfg::Lists{$_}->{OutFileFD}; 
		unlink $ParserCfg::Lists{$_}->{OutFile} if (-z $ParserCfg::Lists{$_}->{OutFile}); #delete if size is zero
	} (keys %ParserCfg::Lists) if $list_search;
	
	# close write-just-matched files (MatchSearch algorithm)
	# $ref->{$a->{FUNC}}->{$data} = {FN=>$f,OFN=>$ofn};
	map {
		close($ref->{MatchSearch}->{$_}->{OFD});
		unlink $ref->{MatchSearch}->{$_}->{OFN} if (-z $ref->{MatchSearch}->{$_}->{OFN}); #delete if zerosize
	} (keys %{$ref->{MatchSearch}}) if $match_search;
}

