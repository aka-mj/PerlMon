package OS;



#############################################################################
# Copyright 2007, 2008 Michael John
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
use WMDE;
use Distro;


# Constructor
sub new {
	my $class = shift;
	my $self = {
		"USER"			=> "Unknown",
		"USER_ID"			=> "Unknown",
		"HOSTNAME"		=> "Unknown",
		"UPTIME"			=> "Unknown",
		"OSTYPE"			=> "Unknown",
		"HARDWARE"		=> "Unknown", 
		"DISTRO"			=> "Unknown",
		"DISTRO_LOGO" 	=> "Unknown",
		"KERNEL_RES"		=> "Unknown",
		"KERNEL_VER"		=> "Unknown",
		"WM"			=> "Unknown",
		"DE"				=> "Unknown"
	};
	bless ($self, $class);
	return $self;
}

# Sets up all info program can
sub find_info {
	my $self = shift;
	my $graphical = shift;
	my $UNAME = `which uname`;
	my $PS = `which ps`;
	my $AWK = `which awk`;
	chomp( $UNAME, $PS, $AWK );
	chomp( $self->{USER} = getpwuid($<) );
	chomp( $self->{USER_ID} = $< );
	chomp( $self->{HOSTNAME} = `$UNAME -n` );
	chomp( $self->{UPTIME} = &uptime(`cat /proc/uptime`) );
	chomp( $self->{OSTYPE} = `$UNAME -o` );
	chomp( $self->{HARDWARE} = `$UNAME -i` );
	chomp( ($self->{DISTRO}, $self->{DISTRO_LOGO}) = Distro::getDistro($graphical) );
	chomp( ($self->{WM}, $self->{DE}) = WMDE::getWMDE($PS, $AWK) );
	chomp( $self->{KERNEL_RES} = `$UNAME -r` );
	chomp( $self->{KERNEL_VER} = `$UNAME -v` );
}


# Gets GTK::Image for vendor logo
sub getLogo {
	my $self = shift;
	return $self->{DISTRO_LOGO};
}


# Figures out system uptime and returns it in a readable format
sub uptime {
	my ($time) = @_;
	my @list = split(/ /,$time);
	$time = $list[0];

	my $days = int($time / 86_400);

	my $hours = int($time / 3600);
	$hours -= ($days * 24);

	my $min = int($time / 60);
	$min -= (($days * 24 * 60) + ($hours * 60));
	my $sec = int($time - $min * 60);

	if ($days == 0 && $hours == 0 && $min == 0) {
		return "$time seconds";
	} elsif ($days == 0 && $hours == 0) {
		return "$min minutes $sec seconds";
	} elsif ($days == 0) {
		return "$hours hours $min minutes";
	} else {
		return "$days days $hours hours $min minutes";
	}
}

# Returns a string of all the Operating System information that the program
# finds.
sub toString {
	my $self = shift;
	return (" User: $self->{USER}     User id: $self->{USER_ID}\n".
		" Host: $self->{HOSTNAME} \n".
		" Uptime: $self->{UPTIME} \n\n".
		" OS: $self->{OSTYPE} \n".
		" Distro: $self->{DISTRO} \n".
		" WM: $self->{WM} \n".
		" DE: $self->{DE} \n\n".
		" Kernel release: $self->{KERNEL_RES} \n".
		" Kernel version: $self->{KERNEL_VER} \n"
	);
}

1; #make compiler happy

