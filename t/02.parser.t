use Test::More tests => 10;

BEGIN
{
use Parse::Yapp;
use_ok( 'Parse::BNF' );
}

my $parser = Parse::Yapp->new
  (
  input => $Parse::BNF::header . $Parse::BNF::grammar
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

use YAML; die Dump( parse( qq{<syntax>::=<rule><syntax>|<foo>'bar'} ) );
use YAML; die Dump( parse( qq{<syntax>::=<rule><syntax><foo>} ) );
use YAML; die Dump( parse( qq{<syntax>::=<rule>} ) );

use YAML; die Dump( parse( <<'_EOF_' ) );
<syntax> ::= <rule> | <rule> <syntax>
<rule> ::= <opt-whitespace> "<" <rule-name> ">" <opt-whitespace> "::=" <opt-whitespace> <expression> <line-end>
<opt-whitespace> ::= " " <opt-whitespace> | ""
<expression> ::= <list> | <list> "|" <expression>
<line-end> ::= <opt-whitespace> <EOL> | <line-end> <line-end>
<list> ::= <term> | <term> <opt-whitespace> <list>
<term> ::= <literal> | "<" <rule-name> ">"
<literal> ::= '"' <text> '"' | "'" <text> "'"
_EOF_
