
package Distro;

use strict;


# Tries figuring out which distro the user is running and assigns the 
# distros logo.
#
# NOTE: If you are not getting the correct logo displayed when running
# 	PerlMon, then look in the directory /etc and see how many files
# 	there are that say something like <DISTRO>-release or 
# 	<DISTRO>-version. Most likely there are more than one such file
# 	and PerlMon is checking the the wrong one first.
#
# 	An example of this is the distro Fedora. /etc contains a file
# 	called redhat-release and a file called fedora-release. If 
# 	Perlmon is checked for the redhat file first then the logo would
# 	be wrong.
# 	You can see where there can become some issues with distros that 
# 	are based off other ones. This problem is avoided for the 
# 	following distros:
# 		Fedora
# 		Sabayon
# 		Mandriva
# 		Ubuntu
# 	If you notice some issues like this with the distro that you are
# 	using then please feel free to contact me at the email address
# 	in the README file.
#
#

sub getDistro {
   	my $CAT = shift;
	my $graphical = shift;
	##$graphical = 0 if length($graphical);
   	my $distro = "Unknown Distro";
   	my $index = 0;
	my $path = "./images";
	my $logo = Gtk2::Image->new_from_file("$path/tux.png") if $graphical;

   	if (-f "/etc/coas") {
      		$distro = `$CAT /etc/coas`;
   	} elsif (-f "/etc/environment.corel") {
      		$distro = `$CAT /etc/environment.core`;
	} elsif (-f "/etc/fedora-release") { 
		## Fedora	
		$distro = `$CAT /etc/fedora-release`;
		$logo->set_from_file("$path/fedora_logo.png") if $graphical;
	} elsif (-f "/etc/mandrake-release") {
		## Mandrake
		$distro = `$CAT /etc/mandrake-release`;
		$logo->set_from_file("$path/mandriva_logo.png") if $graphical;
	} elsif (-f "/etc/mandriva-release") {
		## Mandriva
		$distro = `$CAT /etc/mandriva-release`;
		$logo->set_from_file("$path/mandriva_logo.png") if $graphical;
	} elsif (-f "/etc/SuSE-release") {
		## SUSE
		$distro = `$CAT /etc/SuSE-release`;
		$logo->set_from_file("$path/suse_logo.png") if $graphical;
	} elsif (-f "/etc/turbolinux-release") {
		## Turbo Linux
		$distro = `$CAT /etc/turbolinux-release`;
		$logo->set_from_file("$path/turbolinux_logo.png") if $graphical;
	} elsif (-f "/etc/slackware-version") {
		## Slackware
		$distro = `$CAT /etc/slackware-version`;
		$logo->set_from_file("$path/slackware_logo.png") if $graphical;
	} elsif (-f "/etc/enlisy-release") {
		## Enlisy
		$distro = `$CAT /etc/enlisy-release`;
		$logo->set_from_file("$path/enlisy_logo.png") if $graphical;
	} elsif (-f "/etc/arch-release") {
		## Arch Linux
		$distro = `$CAT /etc/arch-release`;
		$logo->set_from_file("$path/arch_logo.png") if $graphical;
	} elsif (-f "/etc/sabayon-release") {
		## Sabayon
		$distro = `$CAT /etc/sabayon-release`;
		$logo->set_from_file("$path/sabayon_logo.png") if $graphical;
	} elsif (-f "/etc/gentoo-release") {
		## Gentoo
		$distro = `$CAT /etc/gentoo-release`;
		$logo->set_from_file("$path/gentoo_logo.png") if $graphical;
	}elsif (-f "/etc/redhat-release") {
		## Red Hat
		$distro = `$CAT /etc/redhat-release`;
		$logo->set_from_file("$path/redhat_logo.png") if $graphical;
	} elsif (-f "/etc/zenwalk-version") {
		## Zenwalk
		$distro = `$CAT /etc/zenwalk-version`;
		$logo->set_from_file("$path/zenwalk_logo.png") if $graphical;
	} elsif (-f "/etc/lsb-release"){

	   ## Ubuntu
	   my @data;
	   open (UBUNTU, "/etc/lsb-release") || die ("Cannot open file");
	  
	   foreach my $m (<UBUNTU>){
		   chomp ($m);
		   $m =~ /[(\w).\1]*$/;
		   $data[$index] = $&;
		   $index++;
	   }
	   close (UBUNTU);
	   $data[2] = "(".$data[2].")";
	   $distro = join (" ", $data[0], $data[1], $data[2]);

	   $logo->set_from_file("$path/ubuntu_logo.png") if $graphical;

   	} elsif (-f "/etc/debian_version" && $distro eq "Unknown Distro") {
		##Debian
		$distro = "Debian ".readpipe("/etc/debian_version");
		$logo->set_from_file("$path/debian_logo.png") if $graphical;
	} else {

		## This is a last resort to try and identify the distro

		chomp( $distro = `ls \/etc \| grep \"version\\|release\"`);
		$distro = "/etc/$distro";
		open(D, "$distro");
		for my $m (<D>) { ($distro = $m) && last;	}
		close (D);
	}
	
	chomp $distro;
   	return ($distro, $logo);
}

1; #make compiler happy
