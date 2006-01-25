package Net::Domain::TLD;

use strict;

BEGIN {
	use vars qw ( $VERSION );
	$VERSION = 1.06;
}

use constant NEW_TLDS => '_newTLDs';
use constant GENERIC_TLDS_OPEN => '_gTLDs_open';
use constant GENERIC_TLDS_RESTRICTED => '_gTLDs_restricted';
use constant CC_TLDS => '_ccTLDs';

########################################### main pod documentation begin ##

=head1 NAME

	Net::Domain::TLD - Work with TLD names 

=head1 SYNOPSIS

	use Net::Domain::TLD;
	my $domain_list = Net::Domain::TLD->new;
	my @ccTLDs = $domain_list->ccTLDs;

=head1 DESCRIPTION

	The purpose of this module is to provide user with current list of 
	available top level domain names including new ICANN additions and ccTLDs
	Currently TLD definitions have been acquired from the following sources:

	http://www.icann.org/tlds/
	http://www.dnso.org/constituency/gtld/gtld.html
	http://www.iana.org/cctld/cctld-whois.htm

=head1 BUGS

	If you find any, please let the author know

=head1 AUTHOR

	Alex Pavlovic
	CPAN ID: ALEXP
	alex.pavlovic@taskforce-1.com
	

=head1 COPYRIGHT

	Copyright (c) 2002 Alex Pavlovic. All rights reserved.
	This program is free software; you can redistribute
	it and/or modify it under the same terms as Perl itself.
	
	The full text of the license can be found in the
	LICENSE file included with this module.

=head1 SEE ALSO

	perl(1).

=head1 PUBLIC METHODS

	Each public function/method is described here.
	These are how you should interact with this module.

=cut

use constant TLD_PROFILE => {
	&NEW_TLDS => { 
		aero => q/Air-transport industry/, 
		biz => q/Businesses/,
		coop => q/Cooperatives/,
		info => q/Unrestricted use/,
		museum => q/Museums/,
		name => q/For registration by individuals/,
		pro => q/Accountants, lawyers, and physicians/,
	},
	&GENERIC_TLDS_OPEN => {
		com => q/Commercial organization/,
		net => q/Network connection services provider/,
		org => q/Non-profit organizations and industry standard groups/
	},
	&GENERIC_TLDS_RESTRICTED => {
		gov => q/United States Government/,
		mil => q/United States Military/,
		edu => q/Educational institution/,
		int => q/International treaties\/databases/
	},
	&CC_TLDS => {
		ac => q/Ascension Island/,
		ad => q/Andorra/,
		ae => q/United Arab Emirates/,
		af => q/Afghanistan/,
		ag => q/Antigua and Barbuda/,
		ai => q/Anguilla/,
		al => q/Albania/,
		am => q/Armenia/,
		an => q/Netherlands Antilles/,
		ao => q/Angola/,
		aq => q/Antartica/,
		ar => q/Argentina/,
		as => q/American Samoa/,
		at => q/Austria/,
		au => q/Australia/,
		aw => q/Aruba/,
		az => q/Azerbaijan/,
		ba => q/Bosnia and Herzegovina/,
		bb => q/Barbados/,
		bd => q/Bangladesh/,
		be => q/Belgium/,
		bf => q/Burkina Faso/,
		bg => q/Bulgaria/,
		bh => q/Bahrain/,
		bi => q/Burundi/,
		bj => q/Benin/,
		bm => q/Bermuda/,
		bn => q/Brunei Darussalam/,
		bo => q/Bolivia/,
		br => q/Brazil/,
		bs => q/Bahamas/,
		bt => q/Bhutan/,
		bv => q/Bouvet Island/,
		bw => q/Botswana/,
		by => q/Belarus/,
		bz => q/Belize/,
		ca => q/Canada/,
		cc => q/Cocos (Keeling) Islands/,
		cd => q/Congo, Democratic Republic of the/,
		cf => q/Central African Republic/,
		cg => q/Congo, Republic of/,
		ch => q/Switzerland/,
		ci => q/Cote d'Ivoire/,
		ck => q/Cook Islands/,
		cl => q/Chile/,
		cm => q/Cameroon/,
		cn => q/China/,
		co => q/Colombia/,
		cr => q/Costa Rica/,
		cu => q/Cuba/,
		cv => q/Cap Verde/,
		cx => q/Christmas Island/,
		cy => q/Cyprus/,
		cz => q/Czech Republic/,
		de => q/Germany/,
		dj => q/Djibouti/,
		dk => q/Denmark/,
		dm => q/Dominica/,
		do => q/Dominican Republic/,
		dz => q/Algeria/,
		ec => q/Ecuador/,
		ee => q/Estonia/,
		eg => q/Egypt/,
		eh => q/Western Sahara/,
		er => q/Eritrea/,
		es => q/Spain/,
		et => q/Ethiopia/,
		fi => q/Finland/,
		fj => q/Fiji/,
		fk => q/Falkland Islands (Malvina)/,
		fm => q/Micronesia, Federal State of/,
		fo => q/Faroe Islands/,
		fr => q/France/,
		ga => q/Gabon/,
		gd => q/Grenada/,
		ge => q/Georgia/,
		gf => q/French Guiana/,
		gg => q/Guernsey/,
		gh => q/Ghana/,
		gi => q/Gibraltar/,
		gl => q/Greenland/,
		gm => q/Gambia/,
		gn => q/Guinea/,
		gp => q/Guadeloupe/,
		gq => q/Equatorial Guinea/,
		gr => q/Greece/,
		gs => q/South Georgia and the South Sandwich Islands/,
		gt => q/Guatemala/,
		gu => q/Guam/,
		gw => q/Guinea-Bissau/,
		gy => q/Guyana/,
		hk => q/Hong Kong/,
		hm => q/Heard and McDonald Islands/,
		hn => q/Honduras/,
		hr => q/Croatia\/Hrvatska/,
		ht => q/Haiti/,
		hu => q/Hungary/,
		id => q/Indonesia/,
		ie => q/Ireland/,
		il => q/Israel/,
		im => q/Isle of Man/,
		in => q/India/,
		io => q/British Indian Ocean Territory/,
		iq => q/Iraq/,
		ir => q/Iran (Islamic Republic of)/,
		is => q/Iceland/,
		it => q/Italy/,
		je => q/Jersey/,
		jm => q/Jamaica/,
		jo => q/Jordan/,
		jp => q/Japan/,
		ke => q/Kenya/,
		kg => q/Kyrgyzstan/,
		kh => q/Cambodia/,
		ki => q/Kiribati/,
		km => q/Comoros/,
		kn => q/Saint Kitts and Nevis/,
		kp => q/Korea, Democratic People's Republic/,
		kr => q/Korea, Republic of/,
		kw => q/Kuwait/,
		ky => q/Cayman Islands/,
		kz => q/Kazakhstan/,
		la => q/Lao People's Democratic Republic/,
		lb => q/Lebanon/,
		lc => q/Saint Lucia/,
		li => q/Liechtenstein/,
		lk => q/Sri Lanka/,
		lr => q/Liberia/,
		ls => q/Lesotho/,
		lt => q/Lithuania/,
		lu => q/Luxembourg/,
		lv => q/Latvia/,
		ly => q/Libyan Arab Jamahiriya/,
		ma => q/Morocco/,
		mc => q/Monaco/,
		md => q/Moldova, Republic of/,
		mg => q/Madagascar/,
		mh => q/Marshall Islands/,
		mk => q/Macedonia, Former Yugoslav Republic/,
		ml => q/Mali/,
		mm => q/Myanmar/,
		mn => q/Mongolia/,
		mo => q/Macau/,
		mp => q/Northern Mariana Islands/,
		mq => q/Martinique/,
		mr => q/Mauritania/,
		ms => q/Montserrat/,
		mt => q/Malta/,
		mu => q/Mauritius/,
		mv => q/Maldives/,
		mw => q/Malawi/,
		mx => q/Mexico/,
		my => q/Malaysia/,
		mz => q/Mozambique/,
		na => q/Namibia/,
		nc => q/New Caledonia/,
		ne => q/Niger/,
		nf => q/Norfolk Island/,
		ng => q/Nigeria/,
		ni => q/Nicaragua/,
		nl => q/Netherlands/,
		no => q/Norway/,
		np => q/Nepal/,
		nr => q/Nauru/,
		nu => q/Niue/,
		nz => q/New Zealand/,
		om => q/Oman/,
		pa => q/Panama/,
		pe => q/Peru/,
		pf => q/French Polynesia/,
		pg => q/Papua New Guinea/,
		ph => q/Philippines/,
		pk => q/Pakistan/,
		pl => q/Poland/,
		pm => q/St. Pierre and Miquelon/,
		pn => q/Pitcairn Island/,
		pr => q/Puerto Rico/,
		ps => q/Palestinian Territories/,
		pt => q/Portugal/,
		pw => q/Palau/,
		py => q/Paraguay/,
		qa => q/Qatar/,
		re => q/Reunion Island/,
		ro => q/Romania/,
		ru => q/Russian Federation/,
		rw => q/Rwanda/,
		sa => q/Saudi Arabia/,
		sb => q/Solomon Islands/,
		sc => q/Seychelles/,
		sd => q/Sudan/,
		se => q/Sweden/,
		sg => q/Singapore/,
		sh => q/St. Helena/,
		si => q/Slovenia/,
		sj => q/Svalbard and Jan Mayen Islands/,
		sk => q/Slovak Republic/,
		sl => q/Sierra Leone/,
		sm => q/San Marino/,
		sn => q/Senegal/,
		so => q/Somalia/,
		sr => q/Suriname/,
		st => q/Sao Tome and Principe/,
		sv => q/El Salvador/,
		sy => q/Syrian Arab Republic/,
		sz => q/Swaziland/,
		tc => q/Turks and Caicos Islands/,
		td => q/Chad/,
		tf => q/French Southern Territories/,
		tg => q/Togo/,
		th => q/Thailand/,
		tj => q/Tajikistan/,
		tk => q/Tokelau/,
		tm => q/Turkmenistan/,
		tn => q/Tunisia/,
		to => q/Tonga/,
		tp => q/East Timor/,
		tr => q/Turkey/,
		tt => q/Trinidad and Tobago/,
		tv => q/Tuvalu/,
		tw => q/Taiwan/,
		tz => q/Tanzania/,
		ua => q/Ukraine/,
		ug => q/Uganda/,
		uk => q/United Kingdom/,
		um => q/US Minor Outlying Islands/,
		us => q/United States/,
		uy => q/Uruguay/,
		uz => q/Uzbekistan/,
		va => q/Holy See (City Vatican State)/,
		vc => q/Saint Vincent and the Grenadines/,
		ve => q/Venezuela/,
		vg => q/Virgin Islands (British)/,
		vi => q/Virgin Islands (USA)/,
		vn => q/Vietnam/,
		vu => q/Vanuatu/,
		wf => q/Wallis and Futuna Islands/,
		ws => q/Western Samoa/,
		ye => q/Yemen/,
		yt => q/Mayotte/,
		yu => q/Yugoslavia/,
		za => q/South Africa/,
		zm => q/Zambia/,
		zw => q/Zimbabwe/
	}
};

=head1 PUBLIC INTERFACES

=over 4

=item new

	Creates new Net::Domain::TLD instance 	
	my $tld = Net::Domain::TLD->new;

=cut

sub new {
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
	$tld->exists(info) ? print ok : print not ok;

=cut

sub exists {
	my ( $self, $tld ) = @_;
	$tld = lc $tld;
	$tld =~ s/\s+//g;
	my $list = $self->All;
	return exists $list->{$tld};
}

1;

__END__
