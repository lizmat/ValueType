use v6.c;

role ValueType:ver<0.0.2>:auth<cpan:ELIZABETH> {
    has $!WHICH;

    multi method WHICH(::?CLASS:D: --> ValueObjAt:D) {
        $!WHICH.defined
          ?? $!WHICH
          !! self!WHICH
    }

    method !WHICH() {
        my @rest = self.^name;
        for self.^attributes -> $attribute {
            my $name := $attribute.name;
            unless $name eq '$!WHICH' {
                my $WHICH := $attribute.get_value(self).WHICH;

                $WHICH ~~ ValueObjAt
                  ?? @rest.push($WHICH)
                  !! die "Attribute '$name' is not a Value Type";
            }
        }
        $!WHICH := ValueObjAt.new(@rest.join('|'))
    }
}

=begin pod

=head1 NAME

ValueType - A role to create Value Type classes

=head1 SYNOPSIS

  use ValueType;

  class Point does ValueType {
      has $.x = 0;
      has $.y = 0;
  }

  say Point.new.WHICH;  # Point|Int|0|Int|0

  # fill a bag with random Points
  my $bag = bag (^1000).map: {
    Point.new: x => (-10..10).roll, y => (-10..10).roll
  }
  say $bag.elems;  # less than 1000

=head1 DESCRIPTION

The ValueType role mixes the logic of creating a proper ValueType into a
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

=head1 AUTHOR

Elizabeth Mattijsen <liz@wenzperl.nl>

Source can be located at: https://github.com/lizmat/ValueType . Comments and
Pull Requests are welcome.

=head1 COPYRIGHT AND LICENSE

Copyright 2020 Elizabeth Mattijsen

This library is free software; you can redistribute it and/or modify it under
the Artistic License 2.0.

=end pod

# vim: ft=perl6 expandtab sw=4
