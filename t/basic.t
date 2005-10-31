#!perl
use strict;
use warnings;

use Test::More tests => 4;

BEGIN { use_ok('Net::Domain::TLD', qw(tlds tld_exists)); }

my $tld = Net::Domain::TLD->new;

ok($tld->exists('edu'), ".edu exists, right?");

my @domains = tlds('gtld');

ok(
  grep({ $_ eq 'edu' } @domains),
  "another check for edu"
);


eval { tlds('martian') };
ok($@, "croak on invalid top-level domain type");
