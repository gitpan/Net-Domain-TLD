#!perl
use strict;
use warnings;

use Test::More tests => 6;

BEGIN { use_ok('Net::Domain::TLD', qw(tlds tld_exists)); }

my @domains = tlds('gtld');

ok(
  grep({ $_ eq 'edu' } @domains),
  "edu is in gtlds"
);

ok(tld_exists('edu'), "and it 'exists'");
ok(not(tld_exists('wtf')), "bit 'wtf' doesn't");

my @cc_1 = tlds('cc');
my @cc_2 = tlds('cc', 'cc');

cmp_ok(@cc_1, '==', @cc_2, "specifying one group twice does nothing scary");

eval { tlds('martian') };
ok($@, "croak on invalid top-level domain type");
