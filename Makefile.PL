#!perl
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME         => 'Net::Domain::TLD',
    AUTHOR       => 'Alexander Pavlovic <alex-1@telus.net>',
    VERSION_FROM => 'TLD.pm',
    PREREQ_PM    => {Memoize => 0},
);
