use v6.*;
use Test;
use ValueType;

plan 2;

class Point does ValueType {
    has $.x = 0;
    has $.y = 0;

    # this is only a cache attribute
    # that is calculated only based on the other ones
    # so it should not affect .WHICH
    has $!distance-from-origin is excluded-from-valuetype;

    method distance-from-origin () {
        $!distance-from-origin //= sqrt $!x² + $!y²
    }

    # testing method to make sure that the hidden attribute changed
    method raw-distance-attr () { $!distance-from-origin }
}

my $a = Point.new( x => 30, y => 40 );
my $b = Point.new( x => 30, y => 40 );

# change the caching attribute on only one of them
$a.distance-from-origin;

cmp-ok $a.raw-distance-attr, &[!eqv],  $b.raw-distance-attr, 'double checking that an excluded attribute changed';
cmp-ok $a, &[===], $b, ｢objects match even though an excluded attribute doesnt match｣;

# vim: expandtab shiftwidth=4
