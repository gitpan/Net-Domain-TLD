package Net::Domain::TLD;

=head1 INSTALLATION

 perl Makefile.PL
 make
 make test
 make install

=head1 NAME

Net::Domain::TLD - Gives ability to retrieve currently available tld 
names/descriptions and perform verification of given tld name 

=head1 SYNOPSIS

 use Net::Domain::TLD;
 my $domain_list = Net::Domain::TLD->new;
 my @ccTLDs = $domain_list->ccTLDs;

=head1 DESCRIPTION

The purpose of this module is to provide user
with current list of available top level domain names
including new ICANN additions and ccTLDs

=cut

use strict;
use warnings;
use Memoize;

use constant NEW_TLDS => '_newTLDs';
use constant GENERIC_TLDS_OPEN => '_gTLDs_open';
use constant GENERIC_TLDS_RESTRICTED => '_gTLDs_restricted';
use constant CC_TLDS => '_ccTLDs';

sub BEGIN {
        our ($VERSION) = '$Revision: 1.1 $' =~ /Revision: ([\d.]+)/;
}

use constant TLD_PROFILE => {
	#fetched from http://www.icann.org/tlds/
	&NEW_TLDS => { 
		q{.aero} => q{Air-transport industry}, 
		q{.biz} => q{Businesses},
		q{.coop} => q{Cooperatives},
		q{.info} => q{Unrestricted use},
		q{.museum} => q{Museums},
		q{.name} => q{For registration by individuals},
		q{.pro} => q{Accountants, lawyers, and physicians},
	},
	#fetched from http://www.dnso.org/constituency/gtld/gtld.html 
	#specific defininitions from http://whatis.techtarget.com
	&GENERIC_TLDS_OPEN => {
		q{.com} => q{Commercial organization},
		q{.net} => q{Network connection services provider},
		q{.org} => q{Non-profit organizations and industry standard groups}
	},
	&GENERIC_TLDS_RESTRICTED => {
		q{.gov} => q{United States Government},
		q{.mil} => q{United States Military},
		q{.edu} => q{Educational institution},
		q{.int} => q{International treaties/databases}
	},
	#fetched from http://www.iana.org/cctld/cctld-whois.htm
	&CC_TLDS => {
		q{.ac} => q{Ascension Island},
		q{.ad} => q{Andorra},
		q{.ae} => q{United Arab Emirates},
		q{.af} => q{Afghanistan},
		q{.ag} => q{Antigua and Barbuda},
		q{.ai} => q{Anguilla},
		q{.al} => q{Albania},
		q{.am} => q{Armenia},
		q{.an} => q{Netherlands Antilles},
		q{.ao} => q{Angola},
		q{.aq} => q{Antartica},
		q{.ar} => q{Argentina},
		q{.as} => q{American Samoa},
		q{.at} => q{Austria},
		q{.au} => q{Australia},
		q{.aw} => q{Aruba},
		q{.az} => q{Azerbaijan},
		q{.ba} => q{Bosnia and Herzegovina},
		q{.bb} => q{Barbados},
		q{.bd} => q{Bangladesh},
		q{.be} => q{Belgium},
		q{.bf} => q{Burkina Faso},
		q{.bg} => q{Bulgaria},
		q{.bh} => q{Bahrain},
		q{.bi} => q{Burundi},
		q{.bj} => q{Benin},
		q{.bm} => q{Bermuda},
		q{.bn} => q{Brunei Darussalam},
		q{.bo} => q{Bolivia},
		q{.br} => q{Brazil},
		q{.bs} => q{Bahamas},
		q{.bt} => q{Bhutan},
		q{.bv} => q{Bouvet Island},
		q{.bw} => q{Botswana},
		q{.by} => q{Belarus},
		q{.bz} => q{Belize},
		q{.ca} => q{Canada},
		q{.cc} => q{Cocos (Keeling) Islands},
		q{.cd} => q{Congo, Democratic Republic of the},
		q{.cf} => q{Central African Republic},
		q{.cg} => q{Congo, Republic of},
		q{.ch} => q{Switzerland},
		q{.ci} => q{Cote d'Ivoire},
		q{.ck} => q{Cook Islands},
		q{.cl} => q{Chile},
		q{.cm} => q{Cameroon},
		q{.cn} => q{China},
		q{.co} => q{Colombia},
		q{.cr} => q{Costa Rica},
		q{.cu} => q{Cuba},
		q{.cv} => q{Cap Verde},
		q{.cx} => q{Christmas Island},
		q{.cy} => q{Cyprus},
		q{.cz} => q{Czech Republic},
		q{.de} => q{Germany},
		q{.dj} => q{Djibouti},
		q{.dk} => q{Denmark},
		q{.dm} => q{Dominica},
		q{.do} => q{Dominican Republic},
		q{.dz} => q{Algeria},
		q{.ec} => q{Ecuador},
		q{.ee} => q{Estonia},
		q{.eg} => q{Egypt},
		q{.eh} => q{Western Sahara},
		q{.er} => q{Eritrea},
		q{.es} => q{Spain},
		q{.et} => q{Ethiopia},
		q{.fi} => q{Finland},
		q{.fj} => q{Fiji},
		q{.fk} => q{Falkland Islands (Malvina)},
		q{.fm} => q{Micronesia, Federal State of},
		q{.fo} => q{Faroe Islands},
		q{.fr} => q{France},
		q{.ga} => q{Gabon},
		q{.gd} => q{Grenada},
		q{.ge} => q{Georgia},
		q{.gf} => q{French Guiana},
		q{.gg} => q{Guernsey},
		q{.gh} => q{Ghana},
		q{.gi} => q{Gibraltar},
		q{.gl} => q{Greenland},
		q{.gm} => q{Gambia},
		q{.gn} => q{Guinea},
		q{.gp} => q{Guadeloupe},
		q{.gq} => q{Equatorial Guinea},
		q{.gr} => q{Greece},
		q{.gs} => q{South Georgia and the South Sandwich Islands},
		q{.gt} => q{Guatemala},
		q{.gu} => q{Guam},
		q{.gw} => q{Guinea-Bissau},
		q{.gy} => q{Guyana},
		q{.hk} => q{Hong Kong},
		q{.hm} => q{Heard and McDonald Islands},
		q{.hn} => q{Honduras},
		q{.hr} => q{Croatia/Hrvatska},
		q{.ht} => q{Haiti},
		q{.hu} => q{Hungary},
		q{.id} => q{Indonesia},
		q{.ie} => q{Ireland},
		q{.il} => q{Israel},
		q{.im} => q{Isle of Man},
		q{.in} => q{India},
		q{.io} => q{British Indian Ocean Territory},
		q{.iq} => q{Iraq},
		q{.ir} => q{Iran (Islamic Republic of)},
		q{.is} => q{Iceland},
		q{.it} => q{Italy},
		q{.je} => q{Jersey},
		q{.jm} => q{Jamaica},
		q{.jo} => q{Jordan},
		q{.jp} => q{Japan},
		q{.ke} => q{Kenya},
		q{.kg} => q{Kyrgyzstan},
		q{.kh} => q{Cambodia},
		q{.ki} => q{Kiribati},
		q{.km} => q{Comoros},
		q{.kn} => q{Saint Kitts and Nevis},
		q{.kp} => q{Korea, Democratic People's Republic},
		q{.kr} => q{Korea, Republic of},
		q{.kw} => q{Kuwait},
		q{.ky} => q{Cayman Islands},
		q{.kz} => q{Kazakhstan},
		q{.la} => q{Lao People's Democratic Republic},
		q{.lb} => q{Lebanon},
		q{.lc} => q{Saint Lucia},
		q{.li} => q{Liechtenstein},
		q{.lk} => q{Sri Lanka},
		q{.lr} => q{Liberia},
		q{.ls} => q{Lesotho},
		q{.lt} => q{Lithuania},
		q{.lu} => q{Luxembourg},
		q{.lv} => q{Latvia},
		q{.ly} => q{Libyan Arab Jamahiriya},
		q{.ma} => q{Morocco},
		q{.mc} => q{Monaco},
		q{.md} => q{Moldova, Republic of},
		q{.mg} => q{Madagascar},
		q{.mh} => q{Marshall Islands},
		q{.mk} => q{Macedonia, Former Yugoslav Republic},
		q{.ml} => q{Mali},
		q{.mm} => q{Myanmar},
		q{.mn} => q{Mongolia},
		q{.mo} => q{Macau},
		q{.mp} => q{Northern Mariana Islands},
		q{.mq} => q{Martinique},
		q{.mr} => q{Mauritania},
		q{.ms} => q{Montserrat},
		q{.mt} => q{Malta},
		q{.mu} => q{Mauritius},
		q{.mv} => q{Maldives},
		q{.mw} => q{Malawi},
		q{.mx} => q{Mexico},
		q{.my} => q{Malaysia},
		q{.mz} => q{Mozambique},
		q{.na} => q{Namibia},
		q{.nc} => q{New Caledonia},
		q{.ne} => q{Niger},
		q{.nf} => q{Norfolk Island},
		q{.ng} => q{Nigeria},
		q{.ni} => q{Nicaragua},
		q{.nl} => q{Netherlands},
		q{.no} => q{Norway},
		q{.np} => q{Nepal},
		q{.nr} => q{Nauru},
		q{.nu} => q{Niue},
		q{.nz} => q{New Zealand},
		q{.om} => q{Oman},
		q{.pa} => q{Panama},
		q{.pe} => q{Peru},
		q{.pf} => q{French Polynesia},
		q{.pg} => q{Papua New Guinea},
		q{.ph} => q{Philippines},
		q{.pk} => q{Pakistan},
		q{.pl} => q{Poland},
		q{.pm} => q{St. Pierre and Miquelon},
		q{.pn} => q{Pitcairn Island},
		q{.pr} => q{Puerto Rico},
		q{.ps} => q{Palestinian Territories},
		q{.pt} => q{Portugal},
		q{.pw} => q{Palau},
		q{.py} => q{Paraguay},
		q{.qa} => q{Qatar},
		q{.re} => q{Reunion Island},
		q{.ro} => q{Romania},
		q{.ru} => q{Russian Federation},
		q{.rw} => q{Rwanda},
		q{.sa} => q{Saudi Arabia},
		q{.sb} => q{Solomon Islands},
		q{.sc} => q{Seychelles},
		q{.sd} => q{Sudan},
		q{.se} => q{Sweden},
		q{.sg} => q{Singapore},
		q{.sh} => q{St. Helena},
		q{.si} => q{Slovenia},
		q{.sj} => q{Svalbard and Jan Mayen Islands},
		q{.sk} => q{Slovak Republic},
		q{.sl} => q{Sierra Leone},
		q{.sm} => q{San Marino},
		q{.sn} => q{Senegal},
		q{.so} => q{Somalia},
		q{.sr} => q{Suriname},
		q{.st} => q{Sao Tome and Principe},
		q{.sv} => q{El Salvador},
		q{.sy} => q{Syrian Arab Republic},
		q{.sz} => q{Swaziland},
		q{.tc} => q{Turks and Caicos Islands},
		q{.td} => q{Chad},
		q{.tf} => q{French Southern Territories},
		q{.tg} => q{Togo},
		q{.th} => q{Thailand},
		q{.tj} => q{Tajikistan},
		q{.tk} => q{Tokelau},
		q{.tm} => q{Turkmenistan},
		q{.tn} => q{Tunisia},
		q{.to} => q{Tonga},
		q{.tp} => q{East Timor},
		q{.tr} => q{Turkey},
		q{.tt} => q{Trinidad and Tobago},
		q{.tv} => q{Tuvalu},
		q{.tw} => q{Taiwan},
		q{.tz} => q{Tanzania},
		q{.ua} => q{Ukraine},
		q{.ug} => q{Uganda},
		q{.uk} => q{United Kingdom},
		q{.um} => q{US Minor Outlying Islands},
		q{.us} => q{United States},
		q{.uy} => q{Uruguay},
		q{.uz} => q{Uzbekistan},
		q{.va} => q{Holy See (City Vatican State)},
		q{.vc} => q{Saint Vincent and the Grenadines},
		q{.ve} => q{Venezuela},
		q{.vg} => q{Virgin Islands (British)},
		q{.vi} => q{Virgin Islands (USA)},
		q{.vn} => q{Vietnam},
		q{.vu} => q{Vanuatu},
		q{.wf} => q{Wallis and Futuna Islands},
		q{.ws} => q{Western Samoa},
		q{.ye} => q{Yemen},
		q{.yt} => q{Mayotte},
		q{.yu} => q{Yugoslavia},
		q{.za} => q{South Africa},
		q{.zm} => q{Zambia},
		q{.zw} => q{Zimbabwe}
	}
};

=head1 PUBLIC INTERFACES

=over 4

=item new

Creates new Net::Domain::TLD instance 

my $tld = Net::Domain::TLD->new;

=cut

sub new {
	for ( qw ( All TLDs_new gTLDs_open gTLDs_restricted ccTLDs ) ) {
		memoize $_;
	}
	return bless {}, shift;
}

=item All 

 my @list = $tld->All;

returns list or hash ref of all TLDs names/descriptions

=cut

sub All {
	my %list;
	for ( NEW_TLDS, GENERIC_TLDS_OPEN, GENERIC_TLDS_RESTRICTED, CC_TLDS ) {
		@list{keys %{TLD_PROFILE->{$_}}} = values %{TLD_PROFILE->{$_}};
	}
	return wantarray ? keys %list : \%list;
}

=item TLDs_new 

 my @list = $tld->TLDs_new;

returns list or hash ref of new TLD names/descriptions

=cut

sub TLDs_new {
	wantarray ? keys % { TLD_PROFILE->{&NEW_TLDS} } : TLD_PROFILE->{&NEW_TLDS};	
}

=item gTLDs_open

 my $names = $tld->gTLDs_open;

returns a list or hash ref of generic TLD names/descriptions available to general public

=cut

sub gTLDs_open {
	 wantarray ? keys % { TLD_PROFILE->{&GENERIC_TLDS_OPEN} } : TLD_PROFILE->{&GENERIC_TLDS_OPEN};
}

=item gTLDs_restricted 

 my @list = $tld->gTLDs_restricted;

returns a list or hash ref of generic TLD names/descriptions restricted for assignment to specific users

=cut 

sub gTLDs_restricted {
	 wantarray ? keys % { TLD_PROFILE->{&GENERIC_TLDS_RESTRICTED} } : TLD_PROFILE->{&GENERIC_TLDS_RESTRICTED};
}

=item ccTLDs

 my $names = $tld->ccTLDs;

returns a list or hash ref of country code TLD names/descriptions 

=cut

sub ccTLDs {
	my $self = shift;
	wantarray ? keys % { TLD_PROFILE->{&CC_TLDS} } : TLD_PROFILE->{&CC_TLDS}; 
}

=item exists 

determines if given tld exists, returns 1 if tld is valid and 0 if not

 $tld->exists(q{.info}) ? print q{ok} : print q{not ok};

=cut

sub exists {
	my ( $self, $tld ) = @_;
	my $list = $self->All;
	return exists $list->{$tld};
}

1;

=back

=head1 AUTHOR

Alexander Pavlovic <alex.pavlovic@marketingtips.com>

=head1 COPYRIGHT

Copyright (c) 2001 Internet Marketing Center . All rights reserved.
This package is free software; you can redistribute it and/or
modify it under the same terms as Perl itself.

=cut
