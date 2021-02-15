use strict;
use warnings;

use Test::More;
use Text::BibTeX::Validate qw( validate_BibTeX );

my @cases = (
    [ { doi => 'not a DOI' },
      'doi: value \'not a DOI\' does not look like valid DOI' ],
    [ { doi => 'http://doi.org/10.1234/567890' },
      'doi: value \'http://doi.org/10.1234/567890\' is better written as \'10.1234/567890\'' ],
    [ { isbn => '0-306-40615-2' }, undef ],
    [ { isbn => '0-306-40615-X' },
      'isbn: value \'0-306-40615-X\' does not look like valid ISBN' ],
    [ { pmid => 'PMC1234567' },
      'pmid: PMCID \'PMC1234567\' is provided instead of PMID' ],
);

plan tests => 2 * scalar @cases;

for my $case (@cases) {
    my @warnings = validate_BibTeX( $case->[0] );

    is( scalar @warnings, defined $case->[1] ? 1 : 0 );
    is( @warnings ? "$warnings[0]" : undef, $case->[1] );
}
