package Text::BibTeX::Validate;

use strict;
use warnings;

# ABSTRACT: validator for BibTeX format
# VERSION

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
        warn sprintf 'email: value \'%s\' does not look like valid ' .
                     'email address' . "\n",
                     $entry->{email};
    }

    if( exists $entry->{doi} ) {
        my $doi = $entry->{doi};
        if( $entry->{doi} =~ m|^https?://doi\.org/(10\.[^/]+/.*)$| ) {
            warn sprintf 'doi: value \'%s\' is better written as \'%s\'' . "\n",
                         $entry->{doi},
                         $1;
        } elsif( $entry->{doi} !~ m|^(doi:)?10\.[^/]+/.*| ) {
            warn sprintf 'doi: value \'%s\' does not look like valid DOI' . "\n",
                         $entry->{doi};
        }
    }

    # Both keys are non-standard
    for my $key ('isbn', 'issn') {
        next if !exists $entry->{$key};
        my $check = CheckDigits(uc $key);
        my $value = $entry->{$key};
        $value =~ s/-//g;
        next if $check->is_valid( $value );
        warn sprintf '%s: value \'%s\' does not look like valid %s' . "\n",
                     $key,
                     $entry->{$key},
                     uc $key;
    }

    # Both keys are non-standard
    for my $key ('eprint', 'url') {
        next if !exists $entry->{$key};
        next if defined is_uri $entry->{$key};
        warn sprintf '%s: value \'%s\' does not look like valid URL' . "\n",
                     $key,
                     $entry->{$key};
    }
}

1;
