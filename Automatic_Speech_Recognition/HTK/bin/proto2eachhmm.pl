#!/usr/bin/perl
$model = shift(@ARGV);
while (<>) {
	s/proto/$model/;
	print "$_";
}
