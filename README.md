[![Actions Status](https://github.com/lizmat/ValueType/workflows/test/badge.svg)](https://github.com/lizmat/ValueType/actions)

NAME
====

ValueType - A role to create Value Type classes

SYNOPSIS
========

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

DESCRIPTION
===========

The ValueType role mixes the logic of creating a proper ValueType into a class. A class is considered to be a value type if the `.WHICH` method returns an object of the `ValueObjAt` class: that then indicates that objects that return the same `WHICH` value, are in fact identical and can be used interchangeably.

This is specifically important when using set operators (such as `(elem)`, or `Set`s, `Bag`s or `Mix`es, or any other functionality that is based on the `===` operator functionality, such as `unique` and `squish`.

The format of the value that is being returned by `WHICH` is only valid during a run of a process. So it should **not** be stored in any permanent medium.

THEORY OF OPERATION
===================

The first time the `WHICH` method (mixed in by this role) is called, it will check all of its attribute values for being a value type. If they all are, then it will construct a `ValueObjAt` object for its `WHICH` value, save it for future reference, and return it. If any of the attribute values are **not** a value type, then an exception will be thrown.

AUTHOR
======

Elizabeth Mattijsen <liz@raku.rocks>

Source can be located at: https://github.com/lizmat/ValueType . Comments and Pull Requests are welcome.

COPYRIGHT AND LICENSE
=====================

Copyright 2020, 2021 Elizabeth Mattijsen

This library is free software; you can redistribute it and/or modify it under the Artistic License 2.0.

