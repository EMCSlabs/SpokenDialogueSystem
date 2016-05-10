#!/usr/bin/perl
while (<>) {
	chomp;
	if (($_ =~ /ENTER/) || ($_ =~ /EXIT/)) {
		print "$_\n";
	}
	elsif ($_ =~ /sil/) {
		print "$_\n";
	}
	else {
		print "${_}sp\n";
	}
}
