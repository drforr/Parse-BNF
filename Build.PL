use strict;
use warnings;
use Module::Build;

my $builder = Module::Build->new(
    module_name         => 'Parse::BNF',
    license             => 'perl',
    dist_author         => 'Jeffrey Goff <jgoff@cpan.org>',
    dist_version_from   => 'lib/Parse/BNF.pm',
    requires => {
        'Test::More' => 0,
        'version'    => 0,
    },
    add_to_cleanup      => [ 'Parse-BNF-*' ],
);

$builder->create_build_script();
