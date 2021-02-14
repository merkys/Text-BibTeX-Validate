package Text::BibTeX::Validate::Warning;

use strict;
use warnings;

# ABSTRACT: validaton warning class
# VERSION

use Text::sprintfn;

sub new
{
    my( $class, $message, $fields ) = @_;
    my $self = { %$fields, message => $message };
    return bless $self, $class;
}

sub to_string
{
    my( $self ) = @_;

    my $message = $self->{message};
    $message = '%(field)s: ' . $message if exists $self->{field};
    $message = '%(key)s: '   . $message if exists $self->{key};
    $message = '%(file)s: '  . $message if exists $self->{file};

    return sprintfn $message, $self;
}

1;
