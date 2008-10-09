use Test::More tests => 1;

BEGIN {
use_ok( 'Parse::BNF' );
}

my $lexer_header = <<'_EOF_';

input:
    #empty
  | input line '\n' { push(@{$_[1]},$_[2]); $_[1] }
  ;

    #++$_[0]->YYData->{LINE};
line:
    rule_name { [ 'rule_name', $_[1] ] }
  | error { $_[0]->YYErrok }
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
  parse( qq{foo-bar} ), [ [ 'rule_name', 12 ] ], q{rule_name.1}
  );

#is_deeply ( parse( qq{-\n} ), [ [ 'minus_sign', q{-} ] ], q{minus_sign.1} );
