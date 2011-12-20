package Settings;

use strict;
use constant PATH => './settings/';


# Reading the settings file that tells PerlMon what File system types to not 
# include in the Hard Drive tab.
sub skip_fstype {
	
	open (FS, PATH."./fs-skip.txt") || die ("Cannot open file for File System type settings");

	foreach my $m (<FS>) {
		next if $m =~ /^\s*\#/;
		$_[1] .= $m. " ";
	}
	close(FS);
	$_[1] =~ s/\n//g;
	return $_[1];
}


1; #Make compiler happy
