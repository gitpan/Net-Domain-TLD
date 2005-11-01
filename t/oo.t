#!perl
use strict;
use warnings;

use Test::More tests => 17;

BEGIN { use_ok('Net::Domain::TLD'); }

my $tld = do { no warnings 'deprecated'; my $tld = Net::Domain::TLD->new; };

ok($tld->exists('edu'), ".edu exists, right?");

my @methods = qw(All TLDs_new gTLDs_open gTLDs_restricted ccTLDs);

for (@methods) {
  my @tlds = $tld->$_;
  ok(@tlds > 1, "list context $_ gives a bunch of things");
  my $tlds = $tld->$_;
  isa_ok($tlds, 'HASH', "scalar context $_ gives a hashref");

  cmp_ok(@tlds, '==', keys(%$tlds), "as many hashref entries as list members");
}
