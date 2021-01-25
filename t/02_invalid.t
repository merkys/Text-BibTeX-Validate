use strict;
use warnings;

use Test::More;
use Text::BibTeX::Validate;

my @cases = (
    [ { doi => 'not a DOI' },
      'doi: value \'not a DOI\' does not look like DOI' ],
    [ { doi => 'http://doi.org/10.1234/567890' },
      'doi: value \'http://doi.org/10.1234/567890\' is better written as \'10.1234/567890\'' ],
);

plan tests => scalar @cases;

for my $case (@cases) {
    my $warning;
    local $SIG{__WARN__} = sub { $warning = $_[0] };
    Text::BibTeX::Validate::validate_BibTeX( $case->[0] );
    $warning =~ s/\n$// if $warning;
    is( $warning, $case->[1] );
}
