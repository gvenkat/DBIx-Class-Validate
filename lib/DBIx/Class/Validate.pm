package DBIx::Class::Validate;

use strict;
use warnings;

# FIXME: Untested after modification
use parent (
  ( map {
      'DBIx::Class::Validate::Fragment::' . $_
    } qw/ Number Email Format Length Empty Unique /
  ), 'DBIx::Class'
);

use DBIx::Class::Error;

our $VERSION = q(0.0.1);

sub validate {
  my $self = shift;
  my $error = $self->next::method();

  $self->errors( DBIx::Class::Error->new_from_structure( $error ) );
}


# FIXME This override parts are a bit wierd, need to
# refactor them properly
sub update {
  my $self = shift;
  my ( $attrs, @rest ) = @_;


  $self->set_columns( $attrs );
  my $valid = $self->validate();

  $valid->is_error || $self->next::method( @_ );

  $self;
}


sub insert {
  my $self = shift;

  my $valid = $self->validate();

  $valid->is_error || $self->next::method( @_ );

  $self;
}


sub is_error {
  my $self = shift;

  return $self->errors->is_error if $self->errors;

  undef;
}

sub errors {
  my ( $self, $error ) = @_;
  if( $error && $error->isa( 'DBIx::Class::Validate::Error' ) ) {
    $self->{__error} = $error;
  }

  $self->{__error} || undef;
}

1;
__END__
