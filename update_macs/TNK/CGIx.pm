package TNK::CGIx;
##
## Provide advanced CGI operations			svsoldatov, December, 2003
##

# Functions:
# printTableSth - print table from DBI's statemant handler
# printTableArray - print table from Array

use strict;

sub new {
	shift;
	my $q = shift; #CGI qurery if exists

	my $self = {
		Q => $q,
		MINDATE => 2000,
		MAXDATE => 2020,
	};

	bless($self);

	return $self;
}

sub url_encode {
	my ( $self, $encode ) = @_;
	return () unless defined $encode;
	$encode =~ s/([^A-Za-z0-9\-_.!~*'() ])/ uc sprintf "%%%02x",ord $1 /eg;
	$encode =~ tr/ /+/;
	return $encode;
}

sub url_decode {
	my ( $self, $decode ) = @_;
	return () unless defined $decode;
	$decode =~ tr/+/ /;
	$decode =~ s/%([a-fA-F0-9]{2})/ pack "C", hex $1 /eg;
	return $decode;
}

sub printTable1Var {
	my ($self,$str,$bgc,$tc,$fs,$b) =  @_;
	
	$bgc = "WHITE" unless $bgc;
	$tc = "BLACK" unless $tc;
	$str = "\&nbsp;" unless $str;
	$fs = 3 unless $fs;

	return "<table BORDER=\"$b\" CELLSPACEING=\"0\" cellpadding=\"0\"><TR BGCOLOR=\"$bgc\"><TD><FONT SIZE=\"$fs\" COLOR=\"$tc\">$str</FONT></TD></TR></TABLE>";
}

sub printAsteriskVar {
	my ($self, $color, $size, $q) =  @_;
	
	my $qq = $self->{Q} || $q;

	return "<FONT SIZE=\"$size\" FACE=\"Courier\" COLOR=\"$color\">*</FONT>\n";
}

sub escapeAllParams {
	my ($self, $q) = @_;
	
	my $qq = $self->{Q} || $q;

	for ($qq->param) {
		$qq->param(-name=>$_, -value=>$qq->escapeHTML($qq->param($_)));
	}
}

sub prep2HTMLShow {
	my ($self, $str) = @_;
	my $ret = $str;
	
	$ret =~ s/\n/<BR>/g;
	$ret =~ s/  +/\&nbsp;\&nbsp;/g;
	$ret =~ s/\t/\&nbsp;/g;
	
	return $ret;
}

sub printTableSth {
	my ($self, $sth, $th, $before, $after, $tmpl_before, $tmpl_after) = @_;
	
	print "<TABLE BORDER=\"1\" CELLSPACING=\"0\">\n";
	print "\t<TR><TH>\&nbsp;",join("<TH>\&nbsp;", @{$th}),"</TH></TR>\n" if $th;
	my $j = 0;
	while(my @row = $sth->fetchrow_array()){
		$j += 1;
		print "\t<TR>\n";
		for(my $i=0; $i<@{$th}; $i++){
			my $bi = $before->[$i];
			my $ai = $after->[$i];
			$bi =~ s/$tmpl_before->[$i]/$row[$i]/g if defined $tmpl_before->[$i];
			$ai =~ s/$tmpl_after->[$i]/$row[$i]/g if defined $tmpl_after->[$i];
			print "\t\t<TD>\&nbsp;".$bi.$row[$i].$ai."</TD>\n";
		}
		print "\t</TR>\n";
	}
	print "</TABLE>\n";

	return $j;
}

sub printTableArray {
	my ($self, $array, $n, $th, $before, $after, $tmpl_before, $tmpl_after) = @_;

	print "<TABLE BORDER=\"1\" CELLSPACING=\"0\">\n";
	print "\t<TR><TH>\&nbsp;",join("<TH>\&nbsp;", @{$th}),"</TH></TR>\n" if $th;
	my $j = 0;
	while(my @row = splice(@{$array},0,$n)){
		$j += 1;
		print "\t<TR>\n";
		for(my $i=0; $i<$n; $i++){
			my $bi = $before->[$i];
			my $ai = $after->[$i];
			$bi =~ s/$tmpl_before->[$i]/$row[$i]/g if defined $tmpl_before->[$i];
			$ai =~ s/$tmpl_after->[$i]/$row[$i]/g if defined $tmpl_after->[$i];
			print "\t\t<TD>\&nbsp;".$bi.$row[$i].$ai."</TD>\n";
		}
		print "\t</TR>\n";
	}
	print "</TABLE>\n";
	
	return $j;
}

sub printTableTextfieldsQuery {
	my ($serf, $names, $fieldnames, $size, $defaults, $titles) = @_;
	print "<TABLE BORDER=\"1\" CELLSPACING=\"0\">\n";
	for ( my $i=0; $i<@{$fieldnames}; $i++ ) {
		print "<TR><TD>".$names->[$i]."</TD><TD><input type=\"text\" name=\"".
			$fieldnames->[$i]."\" value=\"".$defaults->[$i]."\"  size=\"$size\"  title=\"".$titles->[$i]."\"  \/></TD></TR>\n";
	}
	print "</TABLE>\n";
}


sub printTableFields {
	my ($serf, $names, $values ) = @_;
	print "<TABLE BORDER=\"1\" CELLSPACING=\"0\">\n";
	for ( my $i=0; $i<@{$names}; $i++ ) {
		print "\t<TR><TD>\&nbsp;",$names->[$i],"<TD>\&nbsp;",$values->[$i],"</TD></TR>\n";
	}
	print "</TABLE>\n";
}

sub printTableFieldsVar {
	my ($serf, $names, $values ) = @_;
	
	my $ret = "<TABLE BORDER=\"1\" CELLSPACING=\"0\">\n";
	for ( my $i=0; $i<@{$names}; $i++ ) {
		$ret .= "\t<TR><TD>\&nbsp;".$names->[$i]."<TD>\&nbsp;".$values->[$i]."</TD></TR>\n";
	}
	$ret .= "</TABLE>\n";

	return $ret;
}

sub printTableFieldsM {
	my $serf = shift;
	my @a = @_;
	
	##print "<p>",@a,"</p>";
	my $n = scalar(@a);
	my $m = scalar(@{$a[0]});

	print "<TABLE BORDER=\"1\" CELLSPACING=\"0\">\n";

	for ( my $i=0; $i<$m; $i++ ) {
		print "\t<TR>\n";
		for ( my $j=0; $j<$n; $j++ ) {
			print "\t\t<TD>\&nbsp;",$a[$j]->[$i];
		}
		print "\n";
	}
	print "</TABLE>\n";
}

sub printDate {
	my ($self, $dt,  $pref) = @_;
	
	my ($dd, $mm, $yyyy, $h, $m, $s) = @{$dt};

	foreach my $p ($dd, $mm, $yyyy){
		unless($p =~ /^\d+/){
			_printError("Wrong date format in '$p'!");
			return;
		}
	}
	my $q = $self->{Q};

	print $q->popup_menu("${pref}_dd", [0 .. 31], $dd),"\n",
		$q->popup_menu("${pref}_mm", [1 .. 12], $mm),"\n",
		$q->popup_menu("${pref}_yyyy", [$self->{MINDATE} .. $self->{MAXDATE}], $yyyy),"\n";
	if (defined($h) || defined($m) || defined($s)) {
		print $q->popup_menu("${pref}_h", [0 .. 23], $h),"\n",
			$q->popup_menu("${pref}_m", [0 .. 60], $m),"\n",
			$q->popup_menu("${pref}_s", [0 .. 60], $s),"\n";
	}	
}

sub printDateVar {
	my ($self, $dt,  $pref) = @_;
	
	my ($dd, $mm, $yyyy, $h, $m, $s) = @{$dt};
	##print "<p>$dd, $mm, $yyyy, $h, $m, $s</p>\n"; #DEBUG
	
	foreach my $p ($dd, $mm, $yyyy){
		unless($p =~ /^\d+/){
			_printError("Wrong date format in '$p'!");
			return;
		}
	}
	my $q = $self->{Q};

	my $ret = "\t\t".$q->popup_menu("${pref}_dd", [0 .. 31], $dd)."\n".
		"\t\t".$q->popup_menu("${pref}_mm", [1 .. 12], $mm)."\n".
		"\t\t".$q->popup_menu("${pref}_yyyy", [$self->{MINDATE} .. $self->{MAXDATE}], $yyyy)."\n";
	if (defined($h) || defined($m) || defined($s)) {
		##print "<p>$h, $m, $s - are defined</p>\n"; #DEBUG
		$ret .= "\t\t".$q->popup_menu("${pref}_h", [0 .. 23], $h)."\n".
			"\t\t".$q->popup_menu("${pref}_m", [0 .. 60], $m)."\n".
			"\t\t".$q->popup_menu("${pref}_s", [0 .. 60], $s),"\n";
	}

	##print "<p>$ret</p>\n"; #DEBUG

	return $ret;	
}

sub getDate {
	my ($self,$pref,$template,$flag) = @_;
	##template - smth like YYYY-MM-DD HO:MI:SE
	
	my $q = $self->{Q};

	foreach my $m ("${pref}_dd", "${pref}_mm", "${pref}_yyyy"){
		unless(defined $q->param($m)){
			##_printError("TNK::CGIx::getDate: No parameter with name '$m'!");
			return undef;
		}
	}
	
	my ($dd,$mm,$yyyy,$h,$m,$s) = (
		$flag ? sprintf("%02d", $q->param("${pref}_dd")) : $q->param("${pref}_dd"), 
		$flag ? sprintf("%02d", $q->param("${pref}_mm")) : $q->param("${pref}_mm"), 
		$flag ? sprintf("%04d", $q->param("${pref}_yyyy")) : $q->param("${pref}_yyyy"), 
		$flag ? sprintf("%02d", $q->param("${pref}_h")) : $q->param("${pref}_h"), 
		$flag ? sprintf("%02d", $q->param("${pref}_m")) : $q->param("${pref}_m"), 
		$flag ? sprintf("%02d", $q->param("${pref}_s")) : $q->param("${pref}_s")
	);
	
	return undef if ($dd == 0);
	return "$dd.$mm.$yyyy" unless $template;
	$template =~ s/YYYY/$yyyy/;
	$template =~ s/MM/$mm/;
	$template =~ s/DD/$dd/;
	$template =~ s/HO/$h/;
	$template =~ s/MI/$m/;
	$template =~ s/SE/$s/;
	return $template;
}

sub getDateLink {
	my ($self,$pref) = @_;

	my $q = $self->{Q};
	my @ret = ();

	foreach my $m ("${pref}_dd", "${pref}_mm", "${pref}_yyyy") {
		unless(defined $q->param($m)){
			##_printError("No parameter with name '$m'!");
			return undef;
		}
		push @ret, "$m=".$q->param($m);
	}
	
	foreach my $m ("${pref}_h", "${pref}_m", "${pref}_s") {
		push @ret, "$m=".$q->param($m);
	}

	return join('&',@ret);
}

sub _printError {
	my $msg = shift;
	
	print "\n<P><I><B>$msg</B></I></P>\n";
}

1;

