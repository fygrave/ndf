package TNK::FileUtils;
##
## Provides file options			svsoldatov, December, 2003
##

# Functions:
# rotate
# 

use strict;

sub new {
	shift;
	my $f = shift; 

	my $self = {
		F => $f, # file name
	};
	
	return unless (-f $f);

	bless($self);

	return $self;
}

sub rotate {
	my $self = shift;
	my ($more_then, $n) = @_;
	my $GZIP = '/bin/gzip';
	
	my $file = $self->{F};
	my @ret = stat $file;
	if ($ret[7] >= $more_then){ #size in bytes
		for (my $i=$n-1; $i>=0; $i--){
			my $j = $i+1;
			rename "$file.$i.gz", "$file.$j.gz" if ( -f "$file.$i.gz");
		}
		`$GZIP $file`;
		rename "$file.gz", "$file.0.gz";
	}

}

1;

