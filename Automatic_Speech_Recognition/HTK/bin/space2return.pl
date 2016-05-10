#!/usr/bin/perl
while (<>) {
#	chomp;
	s/\s+/\n/g;
	print "$_";
}
