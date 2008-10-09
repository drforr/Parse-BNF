use strict;
use warnings;
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME                => 'Parse::BNF',
    AUTHOR              => 'Jeffrey Goff <jgoff@cpan.org>',
    VERSION_FROM        => 'lib/Parse/BNF.pm',
    ABSTRACT_FROM       => 'lib/Parse/BNF.pm',
    PL_FILES            => {},
    PREREQ_PM => {
        'Test::More' => 0,
        'version'    => 0,
    },
    dist                => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean               => { FILES => 'Parse-BNF-*' },
);
