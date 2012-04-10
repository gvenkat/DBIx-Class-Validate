package DBIx::Class::Validate::Error; 

use strict;
use CLASS;

sub new { bless { }, shift; }


sub add_to {
  my ( $self, $key, $msg ) = @_;

  $self->{$key} = [ ] if not exists $self->{$key};
  push @{ $self->{$key} }, $msg;
}

sub get_for {
  my ( $self, $key ) = @_; 
  $self->{$key};
}

sub clean_up {
  my $self = shift;
  if( $_[0] && exists $self->{ $_[0] } ) {
    $self->{ $_[0] } = [ ];
  } else {
    foreach my $k ( keys %$self ) {
      $self->{$k} = [ ];
    }
  }

}

sub new_from_structure {
  my ( $class, $structure ) = @_;
  if( ref $structure eq 'HASH' ) {
    bless $structure, $class;
  } else {
    __PACKAGE__->new;
  }
}

sub is_error { 
  my $self = shift;
  scalar( keys %$self );
}

1;
__END__
