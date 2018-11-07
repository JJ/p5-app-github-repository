use Test::More  tests => 1; # -*- mode:cperl -*-

use lib qw(../lib lib);

use App::GitHub::Repository;

my $repo = App::GitHub::Repository->new('https://github.com/JJ/p5-app-github-repository');

isa_ok($repo, 'App::GitHub::Repository');
