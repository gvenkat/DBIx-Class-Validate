package DBIx::Class::Validate::Fragment::Email;

use strict;
use parent 'DBIx::Class::Validate::Fragment::Base';
use CLASS;
use Carp qw( croak );
use Email::Valid;

use Hash::Merge qw( merge );

my %validator = (
  is_email => sub {
    my $val = shift;
    Email::Valid->address( $val );
  }
);


sub validates_email {
  my ( $self, $column, %opts ) = @_;
  my $class = ref $self || $self; 

  $opts{message} ||= "$column is invalid email";

  $class->setup_accessors( '_validate_email' ) unless $class->can( '_validate_email' );
  $class->_validate_email->{$column} = { %opts };
}


sub validate {
  my ( $self ) = @_;
  my $errors = $self->next::method();

  merge( $errors, $self->SUPER::is_valid( '_validate_email', { %validator }, 'is_email' ) );
}


1;
__END__
