package DBIx::Class::Validate::Fragment::Base;

use strict;
use Data::Dumper;

sub setup_accessors {
  my ( $class, $accessor ) = @_;
  unless( $class->can( $accessor ) ) {
    {
      no strict 'refs';
      my $s = "
        package $class;
        our \$$accessor = { };
        sub $accessor {
          \$$accessor;
        }
      ";
      eval $s;
    }
  }
}


# SUPER HACK
# FIXME: Need to fix this part properly
# Maybe use hash based options and delegates to solve diffrent ways of calling validation methods???
# FIXME: Refactor this
sub is_valid {
  my ( $self, $col, $validator, $default, $validate_empty_value, $is_unique_validation ) = @_;
  my ( $class, $cols, $cinfo ) = @_;
  my $error = { };

  return unless ( $self->can( $col ) && $self->$col );


  # FIXME: Do not use Mojo::Exception here 
  $cols = $self->$col; 
  $class = ref( $self ) || Mojo::Exception->throw( "Can not call is_valid on $self" );

  # FIXME: Needs some refactoring
  VALID: foreach my $key ( keys %$cols ) {  
   
    my $val = $cols->{$key};

    if( $validate_empty_value || $self->$key ) {

      if( $default && exists( $validator->{$default} ) && ref( $validator->{$default} ) eq 'CODE' ) {
        unless( $validator->{$default}->( $self->$key ) ) {  
          if( not exists $error->{$key} ) {
            $error->{$key} = [ ];
          }

          push @{ $error->{$key} }, ( $val->{message} || 'error' );

        }
      }

      if( %$val ) {
        while( my ( $opt, $pref ) = each %$val ) {
          my $msg = $val->{message} ? $val->{message} : $self->$key . " must be $opt $pref";
          my $args = ( $is_unique_validation ) ? [ $self->$key, $pref, $val->{columns}, $self ] : [ $self->$key, $pref ];
          if( ref( $validator->{$opt} ) eq 'CODE' && not $validator->{$opt}->( @$args ) ) {
            if( not exists $error->{$key} ) {
              $error->{$key} = [ ];
            }

            push @{ $error->{$key} }, $msg;
          }
        }
      }
    }
  }

  $error;
}

1;
__END__
