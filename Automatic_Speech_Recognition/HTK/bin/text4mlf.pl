#!/usr/bin/perl

for $i (0..$#ARGV) {
	$filename = $ARGV[$i];

#$filename = shift(@ARGV) ;
	$filename =~ /\w+_t(\w\w)_s(\w\w)/;
	$textnum=$1;
	$sentnum=$2;
	$filename =~ s/wav/lab/;
	$textnum =~ s/0(\w)/$1/;
	$sentnum =~ s/0(\w)/$1/;
#	print "$filename $textnum    textnum     $sentnum   sentnum\n";

	push (@filenames, $filename);
	push (@textnums, $textnum);
	push (@sentnums, $sentnum);
}

open (LAB1, "/home/whyun/local_projects/spoken/txt/clean_sents${textnum}.txt");
while (<LAB1>) {
	@lines =   split " ", $_ ;
	$num = shift(@lines);
	$line = join(" ", @lines);
	push @nums, $num;
	push @real_lines, $line;
#	print "$line, $num\n";
}
for $i (0..$#sentnums) {
	for $j (0..$#nums) {

		if ($sentnums[$i] == $nums[$j]) {	
			print "\"*/$filenames[$i]\"\n";
			@onebyones = split " ", $real_lines[$j];
			for $k (0..$#onebyones) {
#			print "$real_lines[$j]\n";
				print "$onebyones[$k]\n";
			}
		}
		else {
		#	print "errer\n";
		}
	}
	print ".\n";
}
