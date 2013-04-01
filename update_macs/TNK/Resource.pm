package TNK::Resource;
##
## Resource Object		svsoldatov october, 2003
##

use TNK::DBAccess;
use CGI;

%Resources = (
	DOMAIN => {
		TEXT => 'NT Domain',
	},
	POST => {
		TEXT => 'Corporate e-mail',
	},
	FILE => {
		TEXT => 'Access Files and Folders',
		TABLE => 'SHARES',
	},
);

#Right order
@Order = ('DOMAIN', 'POST', 'FILE');

#have the next step in query
@Have_Query2 = ('FILE');

#Simple
@Simple_check = ('DOMAIN', 'POST');

%SAPResources = (
	TN2 => {
		TEXT => 'SAP R/3 TN2 system',
		MANDANTS => ['500'],
	},
	HR2 => {
		TEXT => 'SAP R/3 HR2 system',
		MANDANTS => ['501'],
	},
);

#################################################################
sub new {
	shift;
	my $tag = shift;
	return undef unless $tag;

	my $self = {
		TAG => $tag,
	};

	bless $self;

	return $self;
}
#################################################################
sub printQueryHTML1 {
	my $self = shift;
	my $tag = $self->{TAG};
	
	if ($tag eq 'FILE'){
		print "Shares: <input type=\"text\" name=\"${tag}_shares\" size=\"70\">\n";
	}
	
}
#################################################################
sub printQueryHTML2 {
	my $self = shift;
	my $d = shift;
	my $params = shift;
	my $tag = $self->{TAG};
	
	my $q = new CGI;
	if ($tag eq 'FILE'){
		my @shares = split /\s+/, $params->[0];
		print "<TABLE BORDER=\"1\" CELLSPACING=\"0\">\n<TR><TH>NN<TH>Name Template<TH>Items found<TH>Known shares</TR>\n";
		my $i = 0;
		foreach $sh (@shares){
			my $sth = $d->execSQL("SELECT servername, sharename from ".$Resources{$tag}->{TABLE}.
				" WHERE sharename like '%$sh%'");
			my %items = ();
			while( my($servername, $sharename) = $sth->fetchrow_array ){
				next if ($sharename =~ /\$$/); #hidden share does not show
				$items{"\\\\$servername\\$sharename"} = 1;
			}
			my @k_items = keys %items;
			if (@k_items){ #shares found
				print "<TR><TD>".($i+1)."<TD>$sh<TD>".scalar(@k_items)."<TD>".
					$q->popup_menu("${tag}_res_$i",\@k_items)."</TR>\n";
			}
			else {
				print "<TR><TD>".($i+1)."<TD>$sh<TD>0<TD>";
				print "<TABLE BORDER=\"1\" COLLSPACING=\"0\">\n".
					"<TR><TD>Share name: <TD> <input type=\"text\" name=\"${tag}_newshare_$i\" size=\"50\">\n".
					"<TR><TD>Owner: <TD>\n";
				TNK::Employee->printQueryHTML("owner_$i");
				print "</TR></TABLE>";
				print "</TR>\n";
			}
			$i++;
		}
		print "</TABLE>\n";
	}
}
#################################################################
sub getText {
	my $self = shift;
	
	return $Resources{$self->{TAG}}->{TEXT};
}
#################################################################

1;


