package DBIx::Class::Validate::Fragment::Empty;

use strict;
use parent 'DBIx::Class::Validate::Fragment::Base';
use CLASS;
use Hash::Merge qw( merge );


my %validator = (
  nonempty => sub {
    my $val = shift;
    defined( $val ) && $val ne ''; 
  }
);

sub validate {
  my $self = shift;
  $self->__setup;
  merge( $self->next::method(), $self->SUPER::is_valid( '_validate_existance', { %validator }, undef, 1 ) );
}

sub humanize {
  join( ' ', map { ucfirst( $_ ) } split /[_\-.]+/, $_[1] );
}

sub __setup {
  my $self = shift;
  my $class = ref( $self );

  unless( $class->can( '_validate_existance' ) ) {
    $class->setup_accessors( '_validate_existance' );
    my @cols = $self->columns; 
    for my $col ( @cols ) {
      my $colinfo = $self->column_info( $col );
      
      if(  $col ne 'id'                         && 
           $colinfo->{data_type} ne 'timestamp' &&  
           $colinfo->{data_type} ne 'datetime' &&  
           not $colinfo->{is_nullable} 
       ) {
        $class->_validate_existance->{$col} = { nonempty => 1, message => humanize( $col ) . " can not be empty" };
        
      }
    }
  }
}




1;
__END__


