use ExtUtils::MakeMaker;
push(@extras, AUTHOR => 'Alex Pavlovic <alex.pavlovic@taskforce-1.com>' ) if ($ExtUtils::MakeMaker::Version >= 5.4301);
WriteMakefile(
    NAME		=> 'Net::Domain::TLD',
    VERSION_FROM	=> 'lib/Net/Domain/TLD.pm', # finds $VERSION
    PREREQ_PM		=> {}, # e.g., Module::Name => 1.1
);
