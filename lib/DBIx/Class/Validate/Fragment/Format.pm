package DBIx::Class::Validate::Fragment::Format;

use strict;
use parent 'DBIx::Class::Validate::Fragment::Base';
use CLASS;
use Mojo::Exception;
use Hash::Merge qw( merge );

my %validator = (
  with => sub {
    my ( $val, $re ) = @_;
    $val =~ $re;
  },

  without => sub {
    my ( $val, $re ) = @_;
    $val !~ $re;
  }
);


sub validates_format_of {
  my ( $class, $col, %opts ) = @_; 
  
  $class->setup_accessors( '_validate_format' ) unless $class->can( '_validate_format' );
  $class->_validate_format->{$col} = { %opts };
}

sub validate {  
  my ( $self ) = @_;
  merge( $self->next::method(), $self->SUPER::is_valid( '_validate_format', { %validator } ) );
}



1;
__END__
