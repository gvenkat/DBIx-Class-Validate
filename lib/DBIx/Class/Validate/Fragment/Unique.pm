package DBIx::Class::Validate::Fragment::Unique;

use strict;
use parent 'DBIx::Class::Validate::Fragment::Base';


my %validator = (
  is_unique => sub {
    my ( $val, $c, $columns, $row ) = @_;
    my $search = $row->result_source->resultset->search( {
      ( map { $_ => $row->$_ } @$columns ),
    } );

    return 1 unless $row->has_column( 'id' );

    if( $row->id ) {
      $search = $search->search( { id => { '!=' => $row->id } } );
    }

    not $search->first;

  }
);


sub validate {
  my $self = shift;
  
  $self->__setup_for_unique;

  $self->SUPER::is_valid( '_validate_unique', { %validator }, undef, undef, 1 );

}


sub __setup_for_unique {
  my $self = shift;
  my $class = ref $self;

  unless( $class->can( '_validate_unique' ) ) {
    $class->setup_accessors( '_validate_unique' );
    my %uc = $self->unique_constraints;
    for my $constraint ( keys %uc ) {
      my $ucc = $uc{$constraint}; 
      $class->_validate_unique->{$ucc->[0]} = { 
        is_unique => 1, 
        message => sprintf( "%s needs to be unique, or its already taken", join( ",", @$ucc ) ),
        columns => $ucc
      };
    }
  }

}







1;
__END__
