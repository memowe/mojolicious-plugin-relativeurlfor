use strict;
use warnings;
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME                => 'Mojolicious::Plugin::RelativeUrlFor',
    AUTHOR              => 'Mirko Westermeier <mail@memowe.de>',
    VERSION_FROM        => 'lib/Mojolicious/Plugin/RelativeUrlFor.pm',
    ABSTRACT_FROM       => 'lib/Mojolicious/Plugin/RelativeUrlFor.pm',
    ($ExtUtils::MakeMaker::VERSION >= 6.3002
      ? ('LICENSE'=> 'perl')
      : ()),
    PL_FILES            => {},
    PREREQ_PM => {
        'Mojolicious'   => 2,
        'Test::More'    => 0,
    },
    dist                => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean               => { FILES => 'Mojolicious-Plugin-RelativeUrlFor-*' },
);
