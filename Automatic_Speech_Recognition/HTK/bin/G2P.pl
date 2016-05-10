#!/usr/bin/perl

use strict;
use warnings;

use encoding "utf8";

 my ($onset, $nucleus, $coda, $unicode_hangul, $onset_pron, $nucleus_pron, $coda_pron, $result_pron, $finalword, $finalpron); 
# 자소버퍼 : 초성/중성/종성 순
my @kors;
my @results;
my @result_prons;
my $result="";

while (<>) {
    chomp;
    my $kor = $_;
    my @inputs = unpack("U*", $kor);
	
    foreach  (@inputs) {
		
		if ($_ >= 0xAC00 && $_ <= 0xD7A3) {
			
# Unicode_value = (onset * 21) + nucleus) * 28 ) + coda + 0xAC00;
			$unicode_hangul = $_ - 0xAC00;
			$coda = $unicode_hangul % 28;
			$coda_pron = $coda;
			$nucleus = (($unicode_hangul - $coda) / 28) % 21;
			$nucleus_pron = $nucleus;
			$onset = ((($unicode_hangul - $coda) / 28) - $nucleus) / 21;
			$onset_pron = $onset ;
			
			$onset_pron =~ s/^0$/k0/; $onset_pron =~ s/^1$/kk/; $onset_pron =~ s/^2$/nn/; $onset_pron =~ s/^3$/t0/;
			$onset_pron =~ s/^4$/tt/; $onset_pron =~ s/^5$/ll/; $onset_pron =~ s/^6$/mm/; $onset_pron =~ s/^7$/p0/;
			$onset_pron =~ s/^8$/pp/; $onset_pron =~ s/^9$/s0/; $onset_pron =~ s/^10$/ss/;$onset_pron =~ s/^11$//;
			$onset_pron =~ s/^12$/c0/;$onset_pron =~ s/^13$/cc/;$onset_pron =~ s/^14$/ch/;$onset_pron =~ s/^15$/kh/;
			$onset_pron =~ s/^16$/th/;$onset_pron =~ s/^17$/ph/;$onset_pron =~ s/^18$/hh/;
			
			$nucleus_pron =~ s/^0$/aa/;  $nucleus_pron =~ s/^1$/ee/;   $nucleus_pron =~ s/^2$/ya/; 
			$nucleus_pron =~ s/^3$/ye/; $nucleus_pron =~ s/^4$/vv/;   $nucleus_pron =~ s/^5$/ee/; 
			$nucleus_pron =~ s/^6$/yv/; $nucleus_pron =~ s/^7$/ye/;   $nucleus_pron =~ s/^8$/oo/; 
			$nucleus_pron =~ s/^9$/wa/;  $nucleus_pron =~ s/^10$/we/; $nucleus_pron =~ s/^11$/we/;
			$nucleus_pron =~ s/^12$/yo/; $nucleus_pron =~ s/^13$/uu/;   $nucleus_pron =~ s/^14$/wv/;
			$nucleus_pron =~ s/^15$/we/; $nucleus_pron =~ s/^16$/wi/;  $nucleus_pron =~ s/^17$/yu/;
			$nucleus_pron =~ s/^18$/xx/; $nucleus_pron =~ s/^19$/xi/; $nucleus_pron =~ s/^20$/ii/;
			

			$coda_pron =~ s/^0$//;$coda_pron =~ s/^1$/K0/; $coda_pron =~ s/^2$/KK/; $coda_pron =~ s/^3$/K0S0/;
			$coda_pron =~ s/^4$/NN/; $coda_pron =~ s/^5$/NNC0/; $coda_pron =~ s/^6$/NNHH/; $coda_pron =~ s/^7$/T0/;
			$coda_pron =~ s/^8$/LL/; $coda_pron =~ s/^9$/LLK0/; $coda_pron =~ s/^10$/LLMM/;$coda_pron =~ s/^11$/LLP0/;
			$coda_pron =~ s/^12$/LLS0/;$coda_pron =~ s/^13$/LLTH/;$coda_pron =~ s/^14$/LLPH/;$coda_pron =~ s/^15$/LLHH/;
			$coda_pron =~ s/^16$/MM/;$coda_pron =~ s/^17$/P0/;$coda_pron =~ s/^18$/P0S0/;
			$coda_pron =~ s/^19$/S0/;$coda_pron =~ s/^20$/SS/;$coda_pron =~ s/^21$/ng/;$coda_pron =~ s/^22$/C0/;
			$coda_pron =~ s/^23$/CH/;$coda_pron =~ s/^24$/KH/;$coda_pron =~ s/^25$/TH/;
			$coda_pron =~ s/^26$/PH/;$coda_pron =~ s/^27$/HH/;

			
			if ($onset_pron) {
				$result_pron .=$onset_pron . $nucleus_pron;
			}
			else {
				$result_pron .= $onset_pron . $nucleus_pron;
			}
			
			if ($coda_pron) {
				$result_pron .= $coda_pron ;
			}
			else {
#				$result .= "-";
#				$result_pron .= " ";
			}
		} 
		else {
			$result_pron .= chr($_);
		}
    }
	
    $result_pron =~ s/\s\s/ /g;
    $result_pron =~ s/\s\"\s$/\"/;
    $result_pron =~ s/\w\w 1//g;

	print "$result_pron\n";

    $result_pron = "";
}
