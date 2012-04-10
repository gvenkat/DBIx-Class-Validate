use strict;
use Test::More 'no_plan'; 
use FindBin;
use lib "$FindBin::Bin/lib";
use Test::Schema;
use Test::Exception;
use File::Spec::Functions qw( catfile );
use Data::Dumper;


use_ok 'Test::Schema';
use_ok 'AM::DBIC::Validate';
can_ok( 'AM::DBIC::Validate', 'validates_numericality_of' );

my $dir = "$FindBin::Bin/db"; 
my $file = "$dir/test.db";

mkdir $dir, 0755;


my $schema = Test::Schema->connect( "dbi:SQLite:$file", "", "" );
$schema->deploy( { add_drop_table => 1 } );

my $a = $schema->resultset( 'A' );
my $b = $a->create( { a => 1 } );

ok( $b->a == 1, 'a == 1' );
# throws_ok { $a->create( { a => 'hello' } ); } qr/must be a number/, 'can not insert a non-number';
my $b = $a->create( { a => 'hello' } );
can_ok( $b, 'is_error' );
can_ok( $b, 'errors' );
ok( $b->is_error );
is_deeply( $b->errors->get_for( 'a' ), [ 'error' ] );


my $c = $a->create( { a => 1, b => 1 } );
ok( $c->a == 1, 'a == 1'  );
ok( $c->b == 1, 'b == 1' );
ok( not $c->is_error );

$b = $a->create( { a => 1, b => 2 } ); 
ok( $b->is_error );
is( $b->errors->get_for( 'b' )->[0], 'b must be odd' );

$b =  $a->create( { c => 3 } );
ok( $b->is_error );
is( $b->errors->get_for( 'c' )->[0], 'c must be even' );

$b =  $a->create( { d => 8 } ); 
ok( $b->is_error );
is( $b->errors->get_for( 'd' )->[0], 'd must be even and greater than or equal to 10' );

my $d = $a->create( { f => 1001 } );
ok( $d->f == 1001, 'f == 1001' );

$b = $a->create( { d => 11 } ); 
ok( $b->is_error );
is( $b->errors->get_for( 'd' )->[0], 'd must be even and greater than or equal to 10' );

$b =  $a->create( { e => 3 } ); 
ok( $b->is_error );
is( $b->errors->get_for( 'e' )->[0], 'e must be even greater than 9 and less than 101' );

$b =  $a->create( { e => 4 } ); 
ok( $b->is_error );
ok( not $b->in_storage );
is( $b->errors->get_for( 'e' )->[0], 'e must be even greater than 9 and less than 101' );

$b = $a->create( { e => 104 } ); 
ok( $b->is_error );
ok( not $b->in_storage );
is( $b->errors->get_for( 'e' )->[0], 'e must be even greater than 9 and less than 101' );

$b = $a->create( { f => 100 } ); 
ok( $b->is_error );
ok( not $b->in_storage );
is( $b->errors->get_for( 'f' )->[0], 'must be greater than 1000' );

$b =  $a->create( { g => 2000 } ); 
ok( $b->is_error );
ok( not $b->in_storage );
is( $b->errors->get_for( 'g' )->[0], 'must be less than 1000' );

$b = $schema->resultset( 'B' );
$c = $b->create( { a => 'ab' } );
ok( $c->a == 'ab', 'a == "ab"' );
ok( not $c->is_error );

$c =  $b->create( { a => 'foobar' } ); 
ok( $c->is_error );
ok( not $c->in_storage );
is( $c->errors->get_for( 'a' )->[0], 'x' );

$c =  $b->create( { b => '22' } ); 
ok( $c->is_error );
ok( not $c->in_storage );
is( $c->errors->get_for( 'b' )->[0], 'x'x2 );

$c =  $b->create( { c => 10 } ); 
ok( $c->is_error );
ok( not $c->in_storage );
is( $c->errors->get_for( 'c' )->[0], 'x'x3 );

$d = $b->create( { b => 'M23AB' } );
ok( $d->b eq 'M23AB' );
ok( not $d->is_error );

$d = $b->create( { e => q(http://google.com) } );
ok( $d->e eq 'http://google.com' );
ok( not $d->is_error );

$d = $b->create( { c => 'gaminginteractive' } );
ok( $d->c eq 'gaminginteractive' );
ok( not $d->is_error );

$d = $b->create( { e => q(http://google.com/hello/foo) } );
ok( $d->e eq 'http://google.com/hello/foo' );
ok( not $d->is_error );

$b = $schema->resultset( 'C' );
$c = $b->create( { a => 'hello', b => 'hello'x3 } );
ok( $c->a eq 'hello' );
ok( $c->b eq 'hello'x3 );
ok( not $c->is_error );

$c = $b->create( { a => ' ', b => ' ' } ); 
ok( $c->is_error );
ok( not $c->in_storage );
is( $c->errors->get_for( 'a' )->[0], 'x' );
is( $c->errors->get_for( 'b' )->[0], 'xx' );

$c =  $b->create( { a => 'hello', b => ' ' } ); 
ok( $c->is_error );
ok( not $c->in_storage );
is( $c->errors->get_for( 'b' )->[0], 'xx' );

$c= $b->create( { a => '', b => 'hello' } ); 
ok( $c->is_error );
ok( not $c->in_storage );
is( $c->errors->get_for( 'b' )->[0], 'xx' );


my $d = $schema->resultset( 'D' );
my $do = $d->create( { email => 'laksjdflkasdf' } );
ok( $do->is_error );
ok( not $do->in_storage );
is( $do->errors->get_for( 'email' )->[0], 'email is invalid' );


=pod
=cut



