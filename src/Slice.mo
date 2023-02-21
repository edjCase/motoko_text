import Buffer "mo:base/Buffer";
import Debug "mo:base/Debug";
import Iter "mo:base/Iter";
module Slice {

    public type Slice<T> = {
        match : (cases : [MatchType<T>], catchAllCase : MatchCatchAll<T>) -> Slice<T>;
        toIter : () -> Iter.Iter<T>;
    };

    public type StaticValue<T> = {
        #array : [T];
        #buffer : Buffer.Buffer<T>;
    };

    public type Value<T> = StaticValue<T> or {
        #iter : Iter.Iter<T>;
    };

    public type MatchCatchAll<T> = Slice<T> -> Slice<T>;

    public type AffixMatch<T> = {
        value : Value<T>;
        onMatch : { #strip };
    };

    public type MatchType<T> = {
        #prefix : AffixMatch<T>;
        #suffix : AffixMatch<T>;
    };

    private func getValueSize<T>(value : StaticValue<T>) : Nat {
        switch (value) {
            case (#array(a)) a.size();
            case (#buffer(b)) b.size();
        };
    };

    private func getStaticValue<T>(value : Value<T>) : StaticValue<T> {
        switch (value) {
            case (#iter(i)) #buffer(Buffer.fromIter(i));
            case (#array(a)) #array(a);
            case (#buffer(b)) #buffer(b);
        };
    };

    private func getAtIndex<T>(value : StaticValue<T>, i : Nat) : T {
        switch (value) {
            case (#array(a)) a[i];
            case (#buffer(b)) b.get(i);
        };
    };

    public func Slice<T>(
        value : Value<T>,
        comparer : (T, T) -> Bool,
        startIndex : Nat,
        length : ?Nat,
    ) : Slice<T> = object sliceRef {
        let originalStartIndex = startIndex;
        let staticValue = getStaticValue(value);
        let valueSize = getValueSize(staticValue);
        let originalLength : Nat = switch (length) {
            // If no length specified, stop at end of chars
            case (null) {
                if (startIndex >= valueSize) {
                    Debug.trap("Start index must be less than the length of the value");
                };
                valueSize - startIndex;
            };
            case (?l) {
                if (startIndex + l >= valueSize) {
                    Debug.trap("Start index + length must be less than the length of the value");
                };
                l;
            };
        };

        public func slice(startIndex : Nat, length : ?Nat) : Slice<T> {
            Slice<T>(value, comparer, originalStartIndex + startIndex, length);
        };

        public func match(cases : [MatchType<T>], catchAllCase : MatchCatchAll<T>) : Slice<T> {
            for (c in Iter.fromArray(cases)) {

                let result = switch (c) {
                    case (#prefix(prefix)) matchesFix(prefix, true);
                    case (#suffix(suffix)) matchesFix(suffix, false);
                };
                switch (result) {
                    case (null)(); // Didn't match case, try next case
                    case (?slice) return slice; // matched case, return result
                };
            };
            catchAllCase(sliceRef);
        };

        public func toIter() : Iter.Iter<T> {
            switch (staticValue) {
                case (#array(a)) a.vals();
                case (#buffer(b)) b.vals();
            };
        };

        private func matchesFix(affix : AffixMatch<T>, isPre : Bool) : ?Slice<T> {
            let staticAffix = getStaticValue(affix.value);
            let affixSize = getValueSize<T>(staticAffix);
            if (valueSize < affixSize) {
                return null;
            };
            if (affixSize < 1) {
                return ?sliceRef;
            };

            let (startIndex : Nat, length : Nat) = if (isPre) {
                (0, affixSize - 1) : (Nat, Nat);
            } else {
                (valueSize - 1 - affixSize, valueSize - 1) : (Nat, Nat);
            };

            for (i in Iter.range(startIndex, length)) {
                let v = getAtIndex(staticValue, i);
                let f = getAtIndex(staticAffix, i);
                let matched = comparer(f, v);
                if (not matched) {
                    return null;
                };
            };

            return ?slice(startIndex, ?length);
        };

    };
};
