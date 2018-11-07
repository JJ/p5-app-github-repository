use Test::More  tests => 4; # -*- mode:cperl -*-

use lib qw(../lib lib);

use App::GitHub::Repository;

my $repo = App::GitHub::Repository->new('https://github.com/JJ/p5-app-github-repository');

isa_ok($repo, 'App::GitHub::Repository');
$repo->has_readme( "Has README" );
$repo->has_file( ".gitignore", "Has .gitignore" );
$repo->has_milestones( 1, "Correct number of milestones" );
