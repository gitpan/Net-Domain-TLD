use ExtUtils::MakeMaker;
# See lib/ExtUtils/MakeMaker.pm for details of how to influence
# the contents of the Makefile that is written.
push(@extras,
    AUTHOR        => 'Alexander Pavlovic <alex.pavlovic@marketingtips.com>'
        ) if ($ExtUtils::MakeMaker::Version >= 5.4301);
WriteMakefile(
    NAME		=> 'Net::Domain::TLD',
    VERSION_FROM	=> 'TLD.pm', # finds $VERSION
    PREREQ_PM		=> {Memoize => 0}, # e.g., Module::Name => 1.1
);
