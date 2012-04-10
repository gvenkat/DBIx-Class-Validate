package Test::Schema::Result::A;

use strict;
use parent 'AM::DBIC::Core'; 
use CLASS;


CLASS->table( 'a' );
CLASS->add_columns( 
  a => { data_type => 'int', is_nullable => 1 }, 
  b => { data_type => 'int', is_nullable => 1 }, 
  c => { data_type => 'int', is_nullable => 1 }, 
  d => { data_type => 'int', is_nullable => 1 }, 
  e => { data_type => 'int', is_nullable => 1 }, 
  f => { data_type => 'int', is_nullable => 1 }, 
  g => { data_type => 'int', is_nullable => 1 }, 
);

# CLASS->set_primary_key( 'id' );

CLASS->validates_numericality_of( 'a' );
CLASS->validates_numericality_of( 'b', odd  => 1, message => 'b must be odd' );
CLASS->validates_numericality_of( 'c', even => 1, message => 'c must be even' );
CLASS->validates_numericality_of( 'd', even => 1, ge => 10, message => 'd must be even and greater than or equal to 10');
CLASS->validates_numericality_of( 'e', even => 1, ge => 10, le => 100, message => 'e must be even greater than 9 and less than 101' );
CLASS->validates_numericality_of( 'f', gt => 1000, message => 'must be greater than 1000' ); 
CLASS->validates_numericality_of( 'g', lt => 1000, message => 'must be less than 1000'); 


1;
__END__




