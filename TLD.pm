package Net::Domain::TLD;
use base qw(Exporter);
our @EXPORT_OK = qw(tlds tld_exists);

use strict;
use warnings;

use Carp;

=head1 NAME

Net::Domain::TLD - look up and validate TLDs

=head1 VERSION

version 1.60

 $Id$

=cut

our $VERSION = '1.60';

=head1 SYNOPSIS

 use Net::Domain::TLD qw(tlds);

 my @ccTLDs = tlds('cc');

=head1 DESCRIPTION

The purpose of this module is to provide user with current list of available
top level domain names including new ICANN additions and ccTLDs

=cut

my %tld_profile = (
  #fetched from http://www.icann.org/tlds/
  new_open => { 
    info   => q{Unrestricted use},
  },
  new_restricted => { 
    aero   => q{Air-transport industry}, 
    biz    => q{Businesses},
    coop   => q{Cooperatives},
    museum => q{Museums},
    name   => q{For registration by individuals},
    pro    => q{Accountants, lawyers, and physicians},
  },
  #fetched from http://www.dnso.org/constituency/gtld/gtld.html 
  #specific defininitions from http://whatis.techtarget.com
  gtld_open => {
    com => q{Commercial organization},
    net => q{Network connection services provider},
    org => q{Non-profit organizations and industry standard groups}
  },
  gtld_restricted => {
    gov => q{United States Government},
    mil => q{United States Military},
    edu => q{Educational institution},
    int => q{International treaties/databases},
  },
  #fetched from http://www.iana.org/cctld/cctld-whois.htm
  cc_tlds => {
    ac => q{Ascension Island},
    ad => q{Andorra},
    ae => q{United Arab Emirates},
    af => q{Afghanistan},
    ag => q{Antigua and Barbuda},
    ai => q{Anguilla},
    al => q{Albania},
    am => q{Armenia},
    an => q{Netherlands Antilles},
    ao => q{Angola},
    aq => q{Antartica},
    ar => q{Argentina},
    as => q{American Samoa},
    at => q{Austria},
    au => q{Australia},
    aw => q{Aruba},
    az => q{Azerbaijan},
    ba => q{Bosnia and Herzegovina},
    bb => q{Barbados},
    bd => q{Bangladesh},
    be => q{Belgium},
    bf => q{Burkina Faso},
    bg => q{Bulgaria},
    bh => q{Bahrain},
    bi => q{Burundi},
    bj => q{Benin},
    bm => q{Bermuda},
    bn => q{Brunei Darussalam},
    bo => q{Bolivia},
    br => q{Brazil},
    bs => q{Bahamas},
    bt => q{Bhutan},
    bv => q{Bouvet Island},
    bw => q{Botswana},
    by => q{Belarus},
    bz => q{Belize},
    ca => q{Canada},
    cc => q{Cocos (Keeling) Islands},
    cd => q{Congo, Democratic Republic of the},
    cf => q{Central African Republic},
    cg => q{Congo, Republic of},
    ch => q{Switzerland},
    ci => q{Cote d'Ivoire},
    ck => q{Cook Islands},
    cl => q{Chile},
    cm => q{Cameroon},
    cn => q{China},
    co => q{Colombia},
    cr => q{Costa Rica},
    cu => q{Cuba},
    cv => q{Cap Verde},
    cx => q{Christmas Island},
    cy => q{Cyprus},
    cz => q{Czech Republic},
    de => q{Germany},
    dj => q{Djibouti},
    dk => q{Denmark},
    dm => q{Dominica},
    do => q{Dominican Republic},
    dz => q{Algeria},
    ec => q{Ecuador},
    ee => q{Estonia},
    eg => q{Egypt},
    eh => q{Western Sahara},
    er => q{Eritrea},
    es => q{Spain},
    et => q{Ethiopia},
    fi => q{Finland},
    fj => q{Fiji},
    fk => q{Falkland Islands (Malvina)},
    fm => q{Micronesia, Federal State of},
    fo => q{Faroe Islands},
    fr => q{France},
    ga => q{Gabon},
    gd => q{Grenada},
    ge => q{Georgia},
    gf => q{French Guiana},
    gg => q{Guernsey},
    gh => q{Ghana},
    gi => q{Gibraltar},
    gl => q{Greenland},
    gm => q{Gambia},
    gn => q{Guinea},
    gp => q{Guadeloupe},
    gq => q{Equatorial Guinea},
    gr => q{Greece},
    gs => q{South Georgia and the South Sandwich Islands},
    gt => q{Guatemala},
    gu => q{Guam},
    gw => q{Guinea-Bissau},
    gy => q{Guyana},
    hk => q{Hong Kong},
    hm => q{Heard and McDonald Islands},
    hn => q{Honduras},
    hr => q{Croatia/Hrvatska},
    ht => q{Haiti},
    hu => q{Hungary},
    id => q{Indonesia},
    ie => q{Ireland},
    il => q{Israel},
    im => q{Isle of Man},
    in => q{India},
    io => q{British Indian Ocean Territory},
    iq => q{Iraq},
    ir => q{Iran (Islamic Republic of)},
    is => q{Iceland},
    it => q{Italy},
    je => q{Jersey},
    jm => q{Jamaica},
    jo => q{Jordan},
    jp => q{Japan},
    ke => q{Kenya},
    kg => q{Kyrgyzstan},
    kh => q{Cambodia},
    ki => q{Kiribati},
    km => q{Comoros},
    kn => q{Saint Kitts and Nevis},
    kp => q{Korea, Democratic People's Republic},
    kr => q{Korea, Republic of},
    kw => q{Kuwait},
    ky => q{Cayman Islands},
    kz => q{Kazakhstan},
    la => q{Lao People's Democratic Republic},
    lb => q{Lebanon},
    lc => q{Saint Lucia},
    li => q{Liechtenstein},
    lk => q{Sri Lanka},
    lr => q{Liberia},
    ls => q{Lesotho},
    lt => q{Lithuania},
    lu => q{Luxembourg},
    lv => q{Latvia},
    ly => q{Libyan Arab Jamahiriya},
    ma => q{Morocco},
    mc => q{Monaco},
    md => q{Moldova, Republic of},
    mg => q{Madagascar},
    mh => q{Marshall Islands},
    mk => q{Macedonia, Former Yugoslav Republic},
    ml => q{Mali},
    mm => q{Myanmar},
    mn => q{Mongolia},
    mo => q{Macau},
    mp => q{Northern Mariana Islands},
    mq => q{Martinique},
    mr => q{Mauritania},
    ms => q{Montserrat},
    mt => q{Malta},
    mu => q{Mauritius},
    mv => q{Maldives},
    mw => q{Malawi},
    mx => q{Mexico},
    my => q{Malaysia},
    mz => q{Mozambique},
    na => q{Namibia},
    nc => q{New Caledonia},
    ne => q{Niger},
    nf => q{Norfolk Island},
    ng => q{Nigeria},
    ni => q{Nicaragua},
    nl => q{Netherlands},
    no => q{Norway},
    np => q{Nepal},
    nr => q{Nauru},
    nu => q{Niue},
    nz => q{New Zealand},
    om => q{Oman},
    pa => q{Panama},
    pe => q{Peru},
    pf => q{French Polynesia},
    pg => q{Papua New Guinea},
    ph => q{Philippines},
    pk => q{Pakistan},
    pl => q{Poland},
    pm => q{St. Pierre and Miquelon},
    pn => q{Pitcairn Island},
    pr => q{Puerto Rico},
    ps => q{Palestinian Territories},
    pt => q{Portugal},
    pw => q{Palau},
    py => q{Paraguay},
    qa => q{Qatar},
    re => q{Reunion Island},
    ro => q{Romania},
    ru => q{Russian Federation},
    rw => q{Rwanda},
    sa => q{Saudi Arabia},
    sb => q{Solomon Islands},
    sc => q{Seychelles},
    sd => q{Sudan},
    se => q{Sweden},
    sg => q{Singapore},
    sh => q{St. Helena},
    si => q{Slovenia},
    sj => q{Svalbard and Jan Mayen Islands},
    sk => q{Slovak Republic},
    sl => q{Sierra Leone},
    sm => q{San Marino},
    sn => q{Senegal},
    so => q{Somalia},
    sr => q{Suriname},
    st => q{Sao Tome and Principe},
    sv => q{El Salvador},
    sy => q{Syrian Arab Republic},
    sz => q{Swaziland},
    tc => q{Turks and Caicos Islands},
    td => q{Chad},
    tf => q{French Southern Territories},
    tg => q{Togo},
    th => q{Thailand},
    tj => q{Tajikistan},
    tk => q{Tokelau},
    tm => q{Turkmenistan},
    tn => q{Tunisia},
    to => q{Tonga},
    tp => q{East Timor},
    tr => q{Turkey},
    tt => q{Trinidad and Tobago},
    tv => q{Tuvalu},
    tw => q{Taiwan},
    tz => q{Tanzania},
    ua => q{Ukraine},
    ug => q{Uganda},
    uk => q{United Kingdom},
    um => q{US Minor Outlying Islands},
    us => q{United States},
    uy => q{Uruguay},
    uz => q{Uzbekistan},
    va => q{Holy See (City Vatican State)},
    vc => q{Saint Vincent and the Grenadines},
    ve => q{Venezuela},
    vg => q{Virgin Islands (British)},
    vi => q{Virgin Islands (USA)},
    vn => q{Vietnam},
    vu => q{Vanuatu},
    wf => q{Wallis and Futuna Islands},
    ws => q{Western Samoa},
    ye => q{Yemen},
    yt => q{Mayotte},
    yu => q{Yugoslavia},
    za => q{South Africa},
    zm => q{Zambia},
    zw => q{Zimbabwe}
  }
);

my @all_tlds = map { keys %$_ } values %tld_profile;

=head1 PUBLIC INTERFACES

Versions prior to 1.60 were intended for use as objects.  The objects carried
no data, so this was not useful.  There was no class-based configuration,
either, so class methods would not be a useful interface.  You can still use
the old interface, but the suggested interface is procedural.

=head2 PROCEDURAL INTERFACE

=head3 C<< tlds >>

 my @all_tlds = tlds;
 my @cc_tlds  = tlds('cc');
 my @cc_tlds  = tlds('cc', 'generic');

 my $tld = tlds;

In list context, this routine returns a list of TLDs of the requested type.  If
no type is given, all known TLDs are returned.  The list consists of strings.

In scalar context, this routine returns a reference to a hash of TLDs and
their descriptions.

Valid groups are:

 cc                 - country code TLDs
 gtld_open          - generic TLDs that anyone can register
 gtld_restricted    - generic TLDs with restricted registration
 gtld_new           - the horrible, recently added generic TLDs
 gtld               - all of the above gtld groups

=cut

sub _uniq { my %h; map { $h{$_}++ == 0 ? $_ : () } @_; } 

my %tld_group = (
  gtld_new => [ qw(new_open new_restricted) ],
  gtld     => [ qw(gtld_open gtld_restricted gtld_new) ],
);

sub _expand_types {
  my @types = @_;

  my @expanded;
  for (@types) {
    if (defined $tld_profile{$_}) {
      push @expanded, $_;
    } elsif (defined $tld_group{$_}) {
      push @expanded, _expand_types( @{ $tld_group{$_} });
    } else {
      croak "unknown TLD group '$_'";
    }
  }

  return sort _uniq @expanded;
}

sub tlds {
  my @types = @_ ? _expand_types(@_) : keys %tld_profile;

  if (wantarray) {
    return map { keys %$_ } values %tld_profile;
  } else {
    my %tld = map {
      my $group = $_;
      map { $_ => $group->{$_} } keys %$group;
    } values %tld_profile;
  }
}

=head3 C<< tld_exists >>

  die "no such domain" unless tld_exists($tld);

This routine returns true if the given domain exists and false if it does not.

=cut

sub tld_exists {
  my $tld = lc shift;
  return 1 if grep { $tld eq $_ } @all_tlds;
  return;
}

=head2 OO INTERFACE

The object-oriented interface is clunky and unneeded.  Don't use it.

=head3 C<< new >>

 my $tld = Net::Domain::TLD->new;

This method, which creates a new Net::Domain::TLD object, is deprecated.  Use
the procedural interface instead.

=head3 C<< All >>

 my @list = $tld->All;
 # equivalent to:
 my @list = tld;

=head3 C<< TLDs_new >>

 my @list = $tld->TLDs_new;
 # equivalent to:
 my @list = tld('new');

=head3 C<< gTLDs_open >>

 my $tld = $tld->gTLDs_open;
 # equivalent to:
 my $tld = tld('gtld_open');

=head3 C<< gTLDs_restricted >>

 my @list = $tld->gTLDs_restricted;
 # equivalent to:
 my @list = tld('gtld_restricted');

=head3 C<< ccTLDs >>

 my $tld = $tld->ccTLDs;
 # equivalent to:
 my $tld = tld('cc');

=head3 C<< exists >>

 print $tld->exists(q{info}) ? q{ok} : q{not ok};
 # equivalent to:
 print tld_exists(q{info}) ? q{ok} : q{not ok};

=cut

sub new {
  warnings::warnif(
    "deprecated",
    "object-oriented use of Net::Domain::TLD is deprecated"
  );
  return \do { my $stupid_object } => shift;
}

sub All { tlds; }
sub TLDs_new   { tlds('new'); }
sub gTLDs_open { tlds('gtld_open'); }
sub gTLDs_restricted { tlds('gtld_restricted'); }
sub ccTLDs { tlds('cc'); }
sub exists { tld_exists($_[1]); }

=head1 COPYRIGHT

Copyright (c) 2003-2005 Alexander Pavlovic, all rights reserved.  This program
is free software; you can redistribute it and/or modify it under the same terms
as Perl itself.

=head1 AUTHORS

Alexander Pavlovic <alex-1@telus.net>

Ricardo SIGNES C<< <rjbs@cpan.org> >>

=cut

1;
