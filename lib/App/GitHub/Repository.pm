package App::GitHub::Repository;

use warnings;
use strict;
use Carp;

use Git;
use Mojo::UserAgent;
use File::Slurper qw(read_text);
use JSON;
use parent 'Test::Builder::Module'; # Included in Test::Simple

use version; our $VERSION = qv('0.0.3');

# Other recommended modules (uncomment to use):
#  use IO::Prompt;
#  use Perl6::Export;
#  use Perl6::Slurp;
#  use Perl6::Say;


# Module implementation here

sub new {
  my $class = shift;
  my $repo = shift;
  my $tmp_dir = shift || "/tmp";
  croak "$repo is not a GitHub repo" if ( $repo !~ /github/);
  my ($user,$name) = ($repo=~ /github.com\/(\S+)\/([^\.]+)/);
  my $self = {_tb => __PACKAGE__->builder,
	      _repo => $repo,
	      _user => $user,
	      _name => $name };
  my $repo_dir =  "$tmp_dir/$user-$name";
  `rm -rf $repo_dir` if -d $repo_dir;
  `git clone $repo $repo_dir`;
  croak "Couldn't download repo" if !(-d $repo_dir);
  my $student_repo =  Git->repository ( Directory => $repo_dir );
  my @repo_files = $student_repo->command("ls-files");
  $self->{'_repo_dir'} = $repo_dir;
  $self->{'_repo_files'} = \@repo_files;
  $self->{'_README'} =  read_text( "$repo_dir/README.md");
  bless $self, $class;
  return $self;
}

sub has_readme {
  my $self = shift;
  my $message = shift || "Has README.md";
  my $tb = $self->{'_tb'};
  $tb->ok( $self->{'_README'} ne '', $message );
}

sub has_file{
  my $self = shift;
  my $file = shift || croak "No file";
  my $message = shift || "Includes file $file";
  my $tb = $self->{'_tb'};
  $tb->ok( grep(@{$self->{'_repo_files'}}, $file) , $message );
}

sub has_milestones {
  my $self = shift;
  my $how_many = shift || 1;
  my $message = shift || "Has $how_many milestones";
  my $tb = $self->{'_tb'};
  my $user = $self->{'_user'};
  my $repo = $self->{'_name'};
  my $page = get_github( "https://github.com/$user/$repo/milestones" );
  my ($milestones ) = ( $page =~ /(\d+)\s+Open/);
  $tb->cmp_ok( $milestones, ">=", $how_many, $message);
}

sub get_github {
  my $url = shift;
  my $page = `curl -ss $url`;
  croak "No pude descargar la página" if !$page;
  return $page;
}

1; # Magic true value required at end of module
__END__

=head1 NAME

App::GitHub::Repository - [One line description of module's purpose here]


=head1 VERSION

This document describes App::GitHub::Repository version 0.0.1


=head1 SYNOPSIS

    use App::GitHub::Repository;

=for author to fill in:
    Brief code example(s) here showing commonest usage(s).
    This section will be as far as many users bother reading
    so make it as educational and exeplary as possible.
  
  
=head1 DESCRIPTION

=for author to fill in:
    Write a full description of the module and its features here.
    Use subsections (=head2, =head3) as appropriate.


=head1 INTERFACE 

=for author to fill in:
    Write a separate section listing the public components of the modules
    interface. These normally consist of either subroutines that may be
    exported, or methods that may be called on objects belonging to the
    classes provided by the module.


=head1 DIAGNOSTICS

=for author to fill in:
    List every single error and warning message that the module can
    generate (even the ones that will "never happen"), with a full
    explanation of each problem, one or more likely causes, and any
    suggested remedies.

=over

=item C<< Error message here, perhaps with %s placeholders >>

[Description of error here]

=item C<< Another error message here >>

[Description of error here]

[Et cetera, et cetera]

=back


=head1 CONFIGURATION AND ENVIRONMENT

=for author to fill in:
    A full explanation of any configuration system(s) used by the
    module, including the names and locations of any configuration
    files, and the meaning of any environment variables or properties
    that can be set. These descriptions must also include details of any
    configuration language used.
  
App::GitHub::Repository requires no configuration files or environment variables.


=head1 DEPENDENCIES

=for author to fill in:
    A list of all the other modules that this module relies upon,
    including any restrictions on versions, and an indication whether
    the module is part of the standard Perl distribution, part of the
    module's distribution, or must be installed separately. ]

None.


=head1 INCOMPATIBILITIES

=for author to fill in:
    A list of any modules that this module cannot be used in conjunction
    with. This may be due to name conflicts in the interface, or
    competition for system or program resources, or due to internal
    limitations of Perl (for example, many modules that use source code
    filters are mutually incompatible).

None reported.


=head1 BUGS AND LIMITATIONS

=for author to fill in:
    A list of known problems with the module, together with some
    indication Whether they are likely to be fixed in an upcoming
    release. Also a list of restrictions on the features the module
    does provide: data types that cannot be handled, performance issues
    and the circumstances in which they may arise, practical
    limitations on the size of data sets, special cases that are not
    (yet) handled, etc.

No bugs have been reported.

Please report any bugs or feature requests to
C<bug-app-github-repository@rt.cpan.org>, or through the web interface at
L<http://rt.cpan.org>.


=head1 AUTHOR

JJ Merelo  C<< <jjmerelo@gmail.com> >>


=head1 LICENCE AND COPYRIGHT

Copyright (c) 2018, JJ Merelo C<< <jjmerelo@gmail.com> >>. All rights reserved.

This module is free software; you can redistribute it and/or
modify it under the same terms as Perl itself. See L<perlartistic>.


=head1 DISCLAIMER OF WARRANTY

BECAUSE THIS SOFTWARE IS LICENSED FREE OF CHARGE, THERE IS NO WARRANTY
FOR THE SOFTWARE, TO THE EXTENT PERMITTED BY APPLICABLE LAW. EXCEPT WHEN
OTHERWISE STATED IN WRITING THE COPYRIGHT HOLDERS AND/OR OTHER PARTIES
PROVIDE THE SOFTWARE "AS IS" WITHOUT WARRANTY OF ANY KIND, EITHER
EXPRESSED OR IMPLIED, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE. THE
ENTIRE RISK AS TO THE QUALITY AND PERFORMANCE OF THE SOFTWARE IS WITH
YOU. SHOULD THE SOFTWARE PROVE DEFECTIVE, YOU ASSUME THE COST OF ALL
NECESSARY SERVICING, REPAIR, OR CORRECTION.

IN NO EVENT UNLESS REQUIRED BY APPLICABLE LAW OR AGREED TO IN WRITING
WILL ANY COPYRIGHT HOLDER, OR ANY OTHER PARTY WHO MAY MODIFY AND/OR
REDISTRIBUTE THE SOFTWARE AS PERMITTED BY THE ABOVE LICENCE, BE
LIABLE TO YOU FOR DAMAGES, INCLUDING ANY GENERAL, SPECIAL, INCIDENTAL,
OR CONSEQUENTIAL DAMAGES ARISING OUT OF THE USE OR INABILITY TO USE
THE SOFTWARE (INCLUDING BUT NOT LIMITED TO LOSS OF DATA OR DATA BEING
RENDERED INACCURATE OR LOSSES SUSTAINED BY YOU OR THIRD PARTIES OR A
FAILURE OF THE SOFTWARE TO OPERATE WITH ANY OTHER SOFTWARE), EVEN IF
SUCH HOLDER OR OTHER PARTY HAS BEEN ADVISED OF THE POSSIBILITY OF
SUCH DAMAGES.
