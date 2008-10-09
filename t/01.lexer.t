use Test::More tests => 10;

BEGIN {
use Parse::Yapp;
use_ok( 'Parse::BNF' );
}

my $lexer_header = <<'_EOF_';

input :
    input syntax { push @{$_[1]}, $_[2]; $_[1] }
  | # empty
  ;

syntax :
    rule_name { [ 'rule_name', $_[1] ] }
  | literal { [ 'literal', $_[1] ] }
  | '::=' { [ $_[1], $_[1] ] }
  | ' ' { [ $_[1], $_[1] ] }
  | EOL { [ 'EOL', $_[1] ] }
  ;

%%

_EOF_

my $parser = Parse::Yapp->new
  (
  input => $Parse::BNF::header . $lexer_header # . $Parse::BNF::grammar
  );
my $yapptxt = $parser->Output( classname => 'BNF' );
eval $yapptxt;
my $BNF = BNF->new;

my $DEBUG;

sub parse
  {
  my ( $text ) = @_;
  $BNF->YYData->{INPUT} = $text;
  return $BNF->YYParse( yylex => \&Parse::BNF::Lexer, yydebug => $DEBUG );
  }

is_deeply
  (
  parse( q{foo-bar} ), [ [ 'rule_name', 'foo-bar' ] ], q{rule_name.1}
  );

is_deeply ( parse( q{::=} ), [ [ '::=', '::=' ] ], q{::=.1} );
is_deeply ( parse( q{ } ), [ [ ' ', ' ' ] ], q{' '.1} );

is_deeply
  (
  parse( q{'1, 2, foo'} ), [ [ 'literal', q{'1, 2, foo'} ] ], q{literal.1}
  );
is_deeply
  (
  parse( q{"1, 2, foo"} ), [ [ 'literal', q{"1, 2, foo"} ] ], q{literal.2}
  );
is_deeply
  (
  parse( q{'1, 2, \'foo\''} ),
  [ [ 'literal', q{'1, 2, \'foo\''} ] ],
  q{literal.3}
  );
is_deeply
  (
  parse( q{"1, 2, 'foo'"} ),
  [ [ 'literal', q{"1, 2, 'foo'"} ] ],
  q{literal.4}
  );

is_deeply ( parse( qq{\n} ), [ [ 'EOL', qq{\n} ] ], q{EOL.1} );

is_deeply
  (
  parse( q{"1, 2, 'foo'" ::= bar-foo} ),
  [
  [ 'literal', q{"1, 2, 'foo'"} ],
  [ ' ', ' ' ],
  [ '::=', '::=' ],
  [ ' ', ' ' ],
  [ 'rule_name', 'bar-foo' ],
  ],
  q{compound.1}
  );
