use strict;
use warnings;

use File::Temp;
use Test::More tests => 1;
use Text::BibTeX;
use Text::BibTeX::Validate;

my $tmp = File::Temp->new();
my $fh;
open( $fh, '>', $tmp->filename );
print $fh <<'END';
@Article{Merkys2016,
  author    = {Merkys, Andrius and Vaitkus, Antanas and Butkus, Justas and Okuli{\v{c}}-Kazarinas, Mykolas and Kairys, Visvaldas and Gra{\v{z}}ulis, Saulius},
  journal   = {Journal of Applied Crystallography},
  title     = {{\it COD::CIF::Parser}: an error-correcting {CIF} parser for the {P}erl language},
  year      = {2016},
  month     = {Feb},
  number    = {1},
  pages     = {292--301},
  volume    = {49},
  doi       = {10.1107/S1600576715022396},
  url       = {http://dx.doi.org/10.1107/S1600576715022396},
}
END
close $fh;

my $bibfile = Text::BibTeX::File->new( $tmp->filename );
while( my $entry = Text::BibTeX::Entry->new( $bibfile ) ) {
    my $warning;
    local $SIG{__WARN__} = sub { $warning = $_[0] };
    Text::BibTeX::Validate::validate_BibTeX( $entry );
    $warning =~ s/\n$// if $warning;
    is( $warning, undef );
}
