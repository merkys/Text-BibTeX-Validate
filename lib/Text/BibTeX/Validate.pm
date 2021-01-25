package Text::BibTeX::Validate;

use strict;
use warnings;

use Algorithm::CheckDigits;
use Data::Validate::Email qw( is_email_rfc822 );
use Data::Validate::URI qw( is_uri );

sub validate_BibTeX
{
    my( $what ) = @_;

    # TODO: check for duplicated keys
    my $entry = { map { lc $_ => $what->{$_} } keys %$what };

    if( exists $entry->{email} &&
        !defined is_email_rfc822 $entry->{email} ) {
        warn sprintf 'email: value \'%s\' does not look like an email ' .
                     'address' . "\n",
                     $entry->{email};
    }

    if( exists $entry->{isbn} ) {
        my $isbn = CheckDigits('ISBN');
        if( !$isbn->is_valid( $entry->{isbn} ) ) {
            warn sprintf 'isbn: value \'%s\' does not look like an ISBN ' . "\n",
                         $entry->{isbn};
        }
    }

    if( exists $entry->{issn} ) {
        my $issn = CheckDigits('ISSN');
        if( !$isbn->is_valid( $entry->{issn} ) ) {
            warn sprintf 'issn: value \'%s\' does not look like an ISBN ' . "\n",
                         $entry->{issn};
        }
    }

    # Both keys are non-standard
    for my $key ('eprint', 'url') {
        next if !exists $entry->{$key};
        next if defined is_uri $entry->{$key};
        warn sprintf '%s: value \'%s\' does not look like an URL' . "\n",
                     $key,
                     $entry->{$key};
    }
}

1;
