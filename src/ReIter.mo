import Iter "mo:base/Iter";
import Buffer "mo:base/Buffer";
import Char "mo:base/Char";
import Text "mo:base/Text";

module {

    private class ReIter<T>(iter : Iter.Iter<T>) {
        let previousValues = Buffer.Buffer<T>(1);
        var previousOffset : Nat = 0;
        public var position : ?Nat = null;

        public func current() : ?T {
            if (previousOffset == 0 and previousValues.size() == 0) {
                // No value if none have been iterated over
                return null;
            };
            return ?previousValues.get(previousValues.size() - previousOffset - 1);
        };

        public func peek() : ?T {
            do ? {
                if (previousOffset == 0) {
                    let next = iter.next()!;
                    previousOffset := 1;
                    previousValues.add(next);
                };
                previousValues.get(previousOffset - 1);
            };
        };

        public func next() : ?T {
            do ? {
                position := switch (position) {
                    case (null) ?0;
                    case (?p) ?(p + 1);
                };
                if (previousOffset == 0) {
                    // If there is no offset, get next
                    let next = iter.next()!;
                    previousValues.add(next);
                    next;
                } else {
                    // next is moving up the previous value list
                    let next = previousValues.get(previousValues.size() - previousOffset);
                    // Move offset by one to move forward
                    previousOffset -= 1;
                    next;
                };
            };
        };

        public func clearPreviousValues() {
            previousValues.clear();
            previousOffset := 0;
        };

        public func resetPosition() {
            previousOffset := previousValues.size() - 1;
        };

    };
};
