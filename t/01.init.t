use Test::More  tests => 1; # -*- mode:cperl -*-

use lib qw(../lib lib);

use App::GitHub::Repository;

my $repo = App::GitHub::Repository->new()
