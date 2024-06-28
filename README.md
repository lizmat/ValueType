[![Actions Status](https://github.com/lizmat/ValueType/workflows/test/badge.svg)](https://github.com/lizmat/ValueType/actions)

NAME
====

ValueType - A role to create Value Type classes

SYNOPSIS
========

```raku
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
```

DESCRIPTION
===========

The `ValueType` role mixes the logic of creating a proper [value type](https://docs.raku.org/language/glossary#Value_type) into a class. A class is considered to be a value type if the `.WHICH` method returns an object of the `ValueObjAt` class: that then indicates that objects that return the same `WHICH` value, are in fact identical and can be used interchangeably.

This is specifically important when using set operators (such as `(elem)`, or `Set`s, `Bag`s or `Mix`es, or any other functionality that is based on the `===` operator functionality, such as `unique` and `squish`.

The format of the value that is being returned by `WHICH` is only valid during a run of a process. So it should **not** be stored in any permanent medium.

THEORY OF OPERATION
===================

At role composition time, each attribute will be checked for mutability. If any mutable attributes are found, then a compilation error will occur.

Then, the first time the `WHICH` method (mixed in by this role) is called, it will check all of its attribute values for being a value type. If they all are, then it will construct a `ValueObjAt` object for its `WHICH` value, save it for future reference, and return it. If any of the attribute values are **not** a value type, then an exception will be thrown.

AUTHOR
======

Elizabeth Mattijsen <liz@raku.rocks>

Source can be located at: https://github.com/lizmat/ValueType . Comments and Pull Requests are welcome.

If you like this module, or what I’m doing more generally, committing to a [small sponsorship](https://github.com/sponsors/lizmat/) would mean a great deal to me!

COPYRIGHT AND LICENSE
=====================

Copyright 2020, 2021, 2024 Elizabeth Mattijsen

This library is free software; you can redistribute it and/or modify it under the Artistic License 2.0.

