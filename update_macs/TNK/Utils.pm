package TNK::Utils;
##
## usefull utils		svsoldatov april, 2003
##

#############
# functions #
#############
# mac_dashed - return mac address dashed XX-XX-XX-XX-XX-XX
# mac_dotted - return XXXX.XXXX.XXXX
# mac_joined - return xxxxxxxxxxxx
# sys_log ($msg, $severity)- write $msg to syslog, if $severity==error - exits with $?==1
# ip2long(ip_dotted) - return long representation of ip in X.X.X.X format
# long2ip(long) - return dotted representation (X.X.X.X) of IP address in long format
# proc_nmap take fd with nmap -O output and returns hash with keys matches OS and values - arrays of IP address
# proc_date - process date for MSSQL insertion
# _proc_delimeters - split web form input 

sub new {
  shift;
  my $tag = shift;
  
  my $self = {
	TAG => $tag,
  };

  bless($self);

  return $self;
}

##################################################################################
sub mac_joined {
   my $self = shift;
   my $mac = shift;
   my @bytes;
   if($mac =~ /(\w{2})\-(\w{2})\-(\w{2})\-(\w{2})\-(\w{2})\-(\w{2})/){
     @bytes = ($1,$2,$3,$4,$5,$6);
     return join '', @bytes;
   }
   elsif($mac =~ /(\w{2})\s+(\w{2})\s+(\w{2})\s+(\w{2})\s+(\w{2})\s+(\w{2})/){
     @bytes = ($1,$2,$3,$4,$5,$6);
     ##print "with spaces: bytes: ",@bytes;
     return join '', @bytes;
   }
   elsif($mac =~ /(\w{1,2})\:(\w{1,2})\:(\w{1,2})\:(\w{1,2})\:(\w{1,2})\:(\w{1,2})/){
     @bytes = ($1,$2,$3,$4,$5,$6);
     @bytes = map { (length($_) < 2) ? "0$_" : $_ } @bytes;
     return join '', @bytes;
   }
   elsif($mac =~ /(\w{4})\.(\w{4})\.(\w{4})/){
     @bytes = ($1,$2,$3);
     return join '', @bytes;
   }
   elsif($mac =~ /(\w{12})/){
     return $mac;
   }
   else {
     return undef;
   }
} 

##################################################################################

sub mac_dashed {
   my $self = shift;
   my $mac = shift;
   my @bytes;
   
   ##print "<p><i>with -: '$mac'\n</i></p>";
   if($mac =~ /\w{2}\-\w{2}\-\w{2}\-\w{2}\-\w{2}\-\w{2}/){
     return $mac;
   }
   elsif($mac =~ /(\w{2})\s+(\w{2})\s+(\w{2})\s+(\w{2})\s+(\w{2})\s+(\w{2})/){
     @bytes = ($1,$2,$3,$4,$5,$6);
     ##print "with -: bytes: ",@bytes;
     return join '', @bytes;
   }
   elsif($mac =~ /(\w{1,2})\:(\w{1,2})\:(\w{1,2})\:(\w{1,2})\:(\w{1,2})\:(\w{1,2})/){
     @bytes = ($1,$2,$3,$4,$5,$6);
     @bytes = map { (length($_) < 2) ? "0$_" : $_ } @bytes;
     return join '-', @bytes;
   }
   elsif($mac =~ /(\w{2})(\w{2})\.(\w{2})(\w{2})\.(\w{2})(\w{2})/){
     @bytes = ($1,$2,$3,$4,$5,$6);
     return join '-', @bytes;
   }
   elsif($mac =~ /(\w{2})(\w{2})(\w{2})(\w{2})(\w{2})(\w{2})/){
     @bytes = ($1,$2,$3,$4,$5,$6);
     return join '-', @bytes;
   }
   else {
     return undef;
   }
} 

##################################################################################
sub mac_dotted {
   my $self = shift;
   my $mac = shift;
   my @bytes;
   if($mac =~ /(\w{2})\-(\w{2})\-(\w{2})\-(\w{2})\-(\w{2})\-(\w{2})/){
     return "$1$2.$3$4.$5$6";
   }
   elsif($mac =~ /(\w{1,2})\:(\w{1,2})\:(\w{1,2})\:(\w{1,2})\:(\w{1,2})\:(\w{1,2})/){
     @bytes = ($1,$2,$3,$4,$5,$6);
     @bytes = map { (length($_) < 2) ? "0$_" : $_ } @bytes;
     return "$bytes[0]$bytes[1].$bytes[2]$bytes[3].$bytes[4]$bytes[5]";
   }
   elsif($mac =~ /(\w{2})(\w{2})\.(\w{2})(\w{2})\.(\w{2})(\w{2})/){
     return $mac;
   }
   elsif($mac =~ /(\w{4})(\w{4})(\w{4})/){
     @bytes = ($1,$2,$3);
     return join '.', @bytes;
   }
   else {
     return undef;
   }
} 

##################################################################################
sub sys_log {
  my $self = shift;
  my $msg = shift;
  my $severity = shift;
  my $tag = $self->{TAG}.':';
  
  `/bin/logger -p user.$severity $tag $msg`;

  if ($severity eq 'error'){
    print STDERR "$tag: $msg\n";
    exit 1;
  }
}

##################################################################################
#sub ip2long {
#	my $self = shift;
#	my $ip = shift;
#	my @b = split(/\./, $ip);
#	
#	return (unpack "L", (pack "CCCC", reverse @b));
#}
##################################################################################
#sub long2ip {
#	my $self = shift;
#	my $l = shift;
#	$l = pack "L", $l;
#	my @b = unpack "CCCC", $l;
#	
#	return join '.', reverse @b;
#}
##################################################################################
sub ip2long {
	my $self = shift;
	my $ip = shift;
	my @b = split(/\./, $ip);
	
	return (256*256*256*$b[0] + 256*256*$b[1] + 256*$b[2] + $b[3]);
}
##################################################################################
sub long2ip {
	my $self = shift;
	my $l = shift;
	
	my @b = ();
	for (0 .. 3){
		my $bi = $l%256;
		push @b, $bi;
		$l -= $bi;
		$l /= 256;
	}
	return join '.', reverse @b;
}
##################################################################################
sub proc_nmap {
	my $self = shift;
	my $fd = shift;
	
	my %r = ();
	my ($ip, $name) = ();
	
	while (my $l = <$fd>) {
		if ($l =~ /Interesting\s+ports\s+on\s+(\S+)\s+\(([0-9.]+)\)/) {
			$ip = $2;
			$name = $1;
		}
		elsif($l =~ /^Remote\s.*HP\-UX/){
			push @{$r{"HP-UX"}}, $ip;
			($ip, $name) = ();
		}
		elsif($l =~ /^Remote\s.*Cisco/){
			push @{$r{"Cisco"}}, $ip;
			($ip, $name) = ();
		}
		elsif($l =~ /^Remote\s.*Linux/){
			push @{$r{"Linux"}}, $ip;
			($ip, $name) = ();
		}
		elsif($l =~ /^Remote\s.*Windows/){
			push @{$r{"Windows"}}, $ip;
			($ip, $name) = ();
		}
		elsif($l =~/^No\s+exact\s+OS\s+matches\s+for\s+host/){
			push @{$r{"UNKNOWN"}}, $ip;
			($ip, $name) = ();
		}
	}
	return \%r;
}
########################################################################
sub wget {
	my $self = shift;
	my ($url, $file, $dir) = @_;
	
	return undef unless $url;
	return undef unless $file;
	$dir = '.' unless $dir;
	
	my $dist = "$dir/$file";
	unless (-e $dist) {
		##print STDERR "/usr/local/bin/wget -O $dist $url\n";
		`/usr/local/bin/wget -q -O $dist $url >/dev/null`;
		chmod 0644, $dist;
		return 2; #downloaded
	}
	return 1;     #file was
}
########################################################################
sub del_spaces {
	my $self = shift;
	my @v = @_;

	my @ret = ();
	for my $i (@v) {
		$i =~ s/^\s*//;
		$i =~ s/\s*$//;
		push @ret, $i;
	}
	return @ret;
}
##########################################################################################################
sub proc_date {
	my $self = shift;
        my $date = shift;
        return undef unless defined($date);
	
	$date =~ s/^\s*//; $date =~ s/\s*$//;

        if ($date =~ /\d{1,2}\.\d{1,2}\.\d{4}/){
                my ($dd,$mm,$yy) = split /\./, $date;

                return "$yy-$mm-$dd";
        }
        else {
                return $date;
        }
}

#############################################################################################################
sub _proc_delimeters {
	my $self = shift;
        my $str = shift;
        return () unless defined($str);
        my @ret = ();

        if ($str =~ /\#/){
                @ret = split /\#/, $str;
        }
        else {
                @ret = split "\n", $str;
        }
        return @ret;
}


1;
