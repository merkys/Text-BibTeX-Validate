package Text::BibTeX::Validate::Warning;

use strict;
use warnings;

# ABSTRACT: validaton warning class
# VERSION

use Text::sprintfn;

use overload
    '""'  => \&to_string,
    'cmp' => \&_cmp;

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

    return sprintfn $message, { %$self };
}

sub _cmp
{
    my( $a, $b, $are_swapped ) = @_;
    return "$a" cmp "$b" * ($are_swapped ? -1 : 1);
}

1;
