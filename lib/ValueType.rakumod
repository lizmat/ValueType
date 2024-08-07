use v6.d;

my role Excluded {}
multi trait_mod:<is>(Attribute:D $attr, :$hidden-from-ValueType!) is export {
    $attr does Excluded
}

role ValueType {
    has $!WHICH;

    my @attributes = ::?CLASS.^attributes.map: {
        $_ unless .name eq 'WHICH' || $_ ~~ Excluded
    }

    if @attributes.grep(*.rw) -> @mutables {
        die "These attributes are mutable: "
          ~ @mutables.map(*.name).join(', ');
    }

    multi method WHICH(::?CLASS:D: --> ValueObjAt:D) {
        $!WHICH.defined
          ?? $!WHICH
          !! self!WHICH
    }

    method !WHICH() {
        my str @rest = self.^name;
        for @attributes -> $attribute {
            my $WHICH := $attribute.get_value(self).WHICH;
            $WHICH ~~ ValueObjAt
              ?? @rest.push($WHICH.Str)
              !! die "Attribute '$attribute.name()' is not a Value Type";
        }
        $!WHICH := ValueObjAt.new(@rest.join('|'))
    }
}

=begin pod

=head1 NAME

ValueType - A role to create Value Type classes

=head1 SYNOPSIS

=begin code :lang<raku>

use ValueType;

class Point does ValueType {
    has $.x = 0;
    has $.y = 0;
    has $.distance is hidden-from-ValueType is built(False);

    method TWEAK() {
        $!distance = sqrt $!x² + $!y²;
    }
}

say Point.new.WHICH;                     # Point|Int|0|Int|0

say Point.new(x => 3, y => 4).distance;  # 5

# fill a bag with random Points
my $bag = bag (^1000).map: {
  Point.new: x => (-10..10).roll, y => (-10..10).roll
}
say $bag.elems;  # less than 1000

=end code

=head1 DESCRIPTION

The C<ValueType> role mixes the logic of creating a proper
L<value type|https://docs.raku.org/language/glossary#Value_type> into a
class.  A class is considered to be a value type if the C<.WHICH> method
returns an object of the C<ValueObjAt> class: that then indicates that
objects that return the same C<WHICH> value, are in fact identical and
can be used interchangeably.

This is specifically important when using set operators (such as C<(elem)>,
or C<Set>s, C<Bag>s or C<Mix>es, or any other functionality that is based
on the C<===> operator functionality, such as C<unique> and C<squish>.

The format of the value that is being returned by C<WHICH> is only valid
during a run of a process.  So it should B<not> be stored in any permanent
medium.

=head1 EXCLUDING ATTRIBUTES

Sometimes a class has an extra attribute that depends on the other
attributes, but which cannot be set, and doesn't need to be included
in the calculation of the C<WHICH> value.  Such attributes can be marked
with the C<is hidden-from-ValueType> attribute.

=head1 THEORY OF OPERATION

At role composition time, each attribute will be checked for mutability.
If any mutable attributes are found, then a compilation error will occur.

Then, the first time the C<WHICH> method (mixed in by this role) is called,
it will check all of its attribute values for being a value type.  If they
all are, then it will construct a C<ValueObjAt> object for its C<WHICH>
value, save it for future reference, and return it.  If any of the attribute
values are B<not> a value type, then an exception will be thrown.

=head1 AUTHOR

Elizabeth Mattijsen <liz@raku.rocks>

Source can be located at: https://github.com/lizmat/ValueType . Comments and
Pull Requests are welcome.

If you like this module, or what I’m doing more generally, committing to a
L<small sponsorship|https://github.com/sponsors/lizmat/>  would mean a great
deal to me!

=head1 COPYRIGHT AND LICENSE

Copyright 2020, 2021, 2024 Elizabeth Mattijsen

This library is free software; you can redistribute it and/or modify it under
the Artistic License 2.0.

=end pod

# vim: expandtab shiftwidth=4
