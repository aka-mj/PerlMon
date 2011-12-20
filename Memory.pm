package Memory;


#############################################################################
# Copyright© 2007 Michael John
# All Rights Reserved
#
# This file is part of the PerlMon package.
#
#    PerlMon is free software; you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation; under current version 3 of the License.
#
#    PerlMon is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#
#    You should have received a copy of the GNU General Public License
#    along with this program.  If not, see <http://www.gnu.org/licenses/>.
############################################################################

use strict;


# Constructor
sub new {
	my $class = shift;
	my $self = {
		"TOTAL"		=> "Unknown", #Memory Total
		"FREE"		=> "Unknown", #Memory Free
		"USED"		=> "Unknown", #Memory used
		"SWAP_T"	=> "Unknown", #Swap Total
		"SWAP_F"	=> "Unknown", #Swap Free
		"SWAP_U"	=> "Unknown", #Swap used
		"SWAPPINESS"	=> "Unknown", #swappiness number
		"M_PERCENTAGE"	=> "Unknown", #Percentage of memory used
		"S_PERCENTAGE"	=> "Unknown"  #Percentage of spaw used
	};
	bless ($self, $class);
	return $self;
}


# Finds as much information as the program can
sub find_info {
	my $self = shift;
	$_ = `cat /proc/meminfo`;
	$self->{TOTAL} = int $1/1024 if /MemTotal\s*:\s+(\d+)/;
	$self->{FREE} = int $1/1024 if /MemFree\s*:\s+(\d+)/;
	$self->{USED} = $self->{TOTAL} - $self->{FREE};
	$self->{SWAP_T} = int $1/1024 if /SwapTotal\s*:\s+(\d+)/;
	$self->{SWAP_F} = int $1/1024 if /SwapFree\s*:\s+(\d+)/;
	$self->{SWAP_U} = $self->{SWAP_T} - $self->{SWAP_F};
	$self->{SWAPPINESS} = `cat /proc/sys/vm/swappiness`;
	chomp( $self->{SWAPPINESS} );
	
	if ( $self->{TOTAL} != 0 ) {
		$self->{M_PERCENTAGE} = int(( $self->{USED} / $self->{TOTAL} ) * 100);
	}	
	if ( $self->{S_PERCENTAGE} ) {
		$self->{S_PERCENTAGE} = int(( $self->{SWAP_U} / $self->{SWAP_T} ) * 100);
	}
}


# Gets fraction of Memory/Swap used (For Gtk2::ProgressBar)
sub getFraction {
	my $self = shift;
	my $choice = shift;
	if ($choice =~ /^memory$/i) {
		return ($self->{USED} / $self->{TOTAL});
	} elsif ($choice =~ /^swap$/i) {
		return ($self->{SWAP_U} / $self->{SWAP_T});
	}
}


# Gets the percentage of Memory/Swap used (For text in Gtk2::ProgressBar)
sub getPercentage {
	my $self = shift;
	my $choice = shift;
	if ($choice =~ /^memory$/i and $self->{TOTAL} != 0) {
		return ( int(( $self->{USED} / $self->{TOTAL} ) * 100) );
	} elsif ($choice =~ /^swap$/i and $self->{SWAP_T} != 0) {
		return ( int(( $self->{SWAP_U} / $self->{SWAP_T} ) * 100) );
	} else {
		return 0;
	}
}
	
# Returns String on Memory information
sub toString_memory {
	my $self = shift;
	return (" Total Memory: $self->{TOTAL} MB \n".
		" Used Memory: $self->{USED} MB \n Free Memory: $self->{FREE} MB"
	);
}

# Retuns String on Swap information
sub toString_swap {
	my $self = shift;
	return (" Total Swap: $self->{SWAP_T} MB \n".
		" Used Swap: $self->{SWAP_U} MB \n Free Swap: $self->{SWAP_F} MB\n".
		" Swappiness: $self->{SWAPPINESS}"
	);
}

# Returns a String of all information
sub toString {
	my $self = shift;
	return $self->toString_memory."\n".$self->toString_swap."\n";
}
		
	
1;  #makes compiler happy
