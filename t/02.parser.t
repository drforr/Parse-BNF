use Test::More tests => 5;

BEGIN
  {
  use Parse::Yapp;
  use_ok( 'Parse::BNF' );
  }

my $parser =
  Parse::Yapp->new ( input => $Parse::BNF::header . $Parse::BNF::grammar );
eval $parser->Output( classname => 'BNF' );
my $BNF = BNF->new;

my $DEBUG;

sub parse
  {
  my ( $text ) = @_;
  $BNF->YYData->{INPUT} = $text;
  my $foo = $BNF->YYParse( yylex => \&Parse::BNF::Lexer, yydebug => $DEBUG );
  return $BNF->YYData->{VARS};
  }

is_deeply
  (
  parse( q{<A>::=<b>} ),
  { A => [ [ 'b' ] ] },
  q{<A>::=<b>}
  );
is_deeply
  (
  parse( q{<A>\n::=<b>} ),
  { A => [ [ 'b' ] ] },
  q{<A>\n::=<b>}
  );
is_deeply
  (
  parse( q{<A>::=<b><c>} ),
  { A => [ [ 'b', 'c' ] ] },
  q{<A>::=<b><c>}
  );
is_deeply
  (
  parse( q{<A>::=<b><c>|<d>} ),
  { A => [ [ 'b', 'c' ], [ 'd' ] ] },
  q{<A>::=<b><c>}
  );
