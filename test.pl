#!/usr/bin/perl

use yahooBossv2;
use strict;

my $yahooBossv2 = yahooBossv2->new();

my $res = $yahooBossv2->query(@ARGV[0]);

print "The result returned is $res\n";
