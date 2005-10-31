#!perl
use strict;
use warnings;

use Test::More;

use Net::Domain::TLD qw(tlds tld_exists);

my @tlds = tlds;

plan tests => scalar @tlds;

# make sure that every tld in all tlds is also considered to exist
ok(tld_exists($_), "$_ exists") for @tlds;
