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

    # Both keys are non-standard
    for my $key ('isbn', 'issn') {
        next if !exists $entry->{$key};
        my $check = CheckDigits(uc $key);
        next if $check->is_valid $entry->{$key};
        warn sprintf '%s: value \'%s\' does not look like an %s ' . "\n",
                     $key,
                     $entry->{$key},
                     uc $key;
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
