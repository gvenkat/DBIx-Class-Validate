package DBIx::Class::Validate::Fragment::Length;

use strict;
use parent 'DBIx::Class::Validate::Fragment::Base';
use CLASS;

# FIXME: Not use Mojo::Exception here
use Mojo::Exception;
use Hash::Merge qw( merge );

my %validator = (
  in => sub {
    my ( $val, $items ) = @_;
    return 1 if( length( $val ) >= $items->[0] && length( $val ) <= $items->[-1] );
  },

  min => sub {
    my ( $val, $exp ) = @_;
    length( $val ) >= $exp;
  },

  max => sub {
    my ( $val, $exp ) = @_;
    length( $val ) <= $exp;
  }
);


sub validates_length_of {
  my ( $self, $column, %opts ) = @_;
  my $class = ref $self || $self;

  $class->setup_accessors( '_validate_length' ) unless $class->can( '_validate_length' );
  $class->_validate_length->{$column} = { %opts };
}


sub validate {
  my ( $self ) = @_;
  my $errors = $self->next::method();
  merge( $errors, $self->SUPER::is_valid( '_validate_length', { %validator } ) ); 
} 

1;
__END__
