package DBIx::Class::Validate::Fragment::Number;

use strict;
use parent 'DBIx::Class::Validate::Fragment::Base';
use CLASS;
use Carp qw( croak );
use Scalar::Util qw( looks_like_number );
use Hash::Merge qw( merge );

my %validator = (

  odd => sub {
    my $value = shift;
    return ( $value % 2 );
  },

  even => sub {
    my $v = shift;
    not ( $v % 2 ); 
  },

  gt => sub {
    my ( $v, $c ) = @_;
    $v > $c;
  },

  eq => sub {
    my ( $v, $c ) = @_;
    $v == $c;
  },

  lt => sub {
    my ( $v, $c ) = @_;
    $v < $c;
  },

  le => sub {
    my ( $v, $c ) = @_;
    $v <= $c; 
  },

  ge => sub {
    my ( $v, $c ) = @_;
    $v >= $c;
  },

  integer => sub {
    my $val = shift;
    $val =~ /-?\d+/;
  },

  number => sub {
    my $val = shift;
    $val =~ /-?\d+(\.\d+)?/;
  }

);


sub validates_numericality_of {
  my ( $self, $column, %opts ) = @_;
  my $class = ref $self || $self; 

  $class->setup_accessors( '_validate_number' ) unless $class->can( '_validate_number' );
  $class->_validate_number->{$column} = { %opts };
}


sub validate {
  my ( $self ) = @_;
  my $errors = $self->next::method();

  merge( $errors, $self->SUPER::is_valid( '_validate_number', { %validator }, 'number' ) );
}


1;
__END__
