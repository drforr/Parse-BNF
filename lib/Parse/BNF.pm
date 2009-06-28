package Parse::BNF;

use warnings;
use strict;
use Carp;
use Regexp::Common;

use version;
our $VERSION = qv('0.0.3');

our $header = <<'_EOF_';

%%
_EOF_

our $grammar = <<'_EOF_';

syntax
  : rule
  # The Lexer eats one EOL...
  | rule EOL syntax
  ;

rule
  : rule_name '::=' terms
  { $_[0]->YYData->{VARS}{$_[1]} = $_[3] }
  ;

terms
  : term_list { [ $_[1] ] }
  | terms '|' term_list { push @{$_[1]}, $_[3]; $_[1] }
  ;

term_list
  : terminal { [ $_[1] ] }
  | term_list terminal { push @{$_[1]}, $_[2]; $_[1] }
  ;

terminal
  : rule_name
  | literal
  ;

%%

_EOF_

=head1 NAME

Parse::BNF - [One line description of module's purpose here]

=head1 VERSION

This document describes Parse::BNF version 0.0.1

=head1 SYNOPSIS

    use Parse::BNF;

    # XXX Simpler usage here once I've added wrappers
    

=head1 DESCRIPTION

Parser for basic BNF grammar. I'll add the (more common) EBNF grammar as a
separate module once I've gotten the wrapper for the basic ::Yapp stuff settled.

=head1 INTERFACE 

=head2 Lexer

Handles the basic BNF tokenizing with a little help from Regexp::Common. If the
dependencies become too onerous I'll copy in the appropriate RE from there.

=cut

sub Lexer
  {
  my ( $parser ) = @_;

  exists $parser->YYData->{LINE} or $parser->YYData->{LINE} = 1;

  $parser->YYData->{INPUT} or return ( '', undef );
  $parser->YYData->{INPUT} =~ s( ^ [ \t]+ )()x;
  $parser->YYData->{INPUT} =~ s( ^ \n )()x;

  for ($parser->YYData->{INPUT})
    {
    s( ^ <([-A-Za-z]+)> )()x and return ( 'rule_name', $1 );
    s( ^ (::=) )()x and return ( $1, $1 );
    s( ^ ($RE{quoted}) )()x and do
      {
      my $x = $1;
      $parser->YYData->{LINE} += $x =~ tr/\n/\n/;
      return ( 'literal', $x );
      };
    s( ^ (\n) )()x and do
      {
      $parser->YYData->{LINE}++;
      return ( 'EOL', $1 );
      };
    s( ^ (.) )()x and return ( $1, $1 );
    }
  }

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

Parse::BNF requires no configuration files or environment variables.

=head1 DEPENDENCIES

Parse::Yapp
Regexp::Common

=head1 INCOMPATIBILITIES

None reported.

=head1 BUGS AND LIMITATIONS

No bugs have been reported.

Please report any bugs or feature requests to
C<bug-parse-bnf@rt.cpan.org>, or through the web interface at
L<http://rt.cpan.org>.

=head1 AUTHOR

Jeffrey Goff  C<< <jgoff@cpan.org> >>

=head1 LICENCE AND COPYRIGHT

Copyright (c) 2008, Jeffrey Goff C<< <jgoff@cpan.org> >>. All rights reserved.

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

1;
