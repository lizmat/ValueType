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

# vim: expandtab shiftwidth=4
